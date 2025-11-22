import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BLEService {
  static const String serviceUUID = "0000fff0-0000-1000-8000-00805f9b34fb";
  static const String rxCharacteristicUUID = "0000fff1-0000-1000-8000-00805f9b34fb";
  static const String txCharacteristicUUID = "0000fff2-0000-1000-8000-00805f9b34fb";
  
  StreamController<String> _dataController = StreamController<String>.broadcast();
  StreamController<BLEConnectionState> _stateController = StreamController<BLEConnectionState>.broadcast();
  
  Stream<String> get dataStream => _dataController.stream;
  Stream<BLEConnectionState> get stateStream => _stateController.stream;
  
  BLEConnectionState _currentState = BLEConnectionState.baglantiYok;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  
  Future<void> startScan() async {
    _updateState(BLEConnectionState.baglanıyor);
    await Future.delayed(Duration(seconds: 2));
    _isConnected = true;
    _updateState(BLEConnectionState.baglantıKuruldu);
    await Future.delayed(Duration(milliseconds: 500));
    _updateState(BLEConnectionState.veriAlınıyor);
  }
  
  Future<void> connect(String deviceId) async {
    _updateState(BLEConnectionState.baglanıyor);
    await Future.delayed(Duration(seconds: 1));
    _isConnected = true;
    _updateState(BLEConnectionState.baglantıKuruldu);
    await setupMTU();
    await Future.delayed(Duration(milliseconds: 500));
    _updateState(BLEConnectionState.veriAlınıyor);
  }
  
  Future<void> setupMTU() async {
    await Future.delayed(Duration(milliseconds: 100));
  }
  
  Future<void> writeData(String data) async {
    if (!_isConnected) return;
    await Future.delayed(Duration(milliseconds: 50));
    _simulateResponse(data);
  }
  
  void _simulateResponse(String command) {
    Timer(Duration(milliseconds: 100), () {
      String response = _generateMockResponse(command);
      _dataController.add(response);
    });
  }
  
  String _generateMockResponse(String command) {
    if (command.contains("010C")) return "41 0C 1A F0";
    if (command.contains("010D")) return "41 0D 3C";
    if (command.contains("0105")) return "41 05 78";
    if (command.contains("0110")) return "41 10 01 2C";
    if (command.contains("0111")) return "41 11 50";
    if (command.contains("010A")) return "41 0A 64";
    if (command.contains("0104")) return "41 04 0A";
    if (command.contains("010E")) return "41 0E 0C";
    if (command.contains("0103")) return "03 01 00 00 00 00";
    if (command.contains("04")) return "44";
    return "OK";
  }
  
  void _updateState(BLEConnectionState state) {
    _currentState = state;
    _stateController.add(state);
  }
  
  void startAutoReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (!_isConnected && _currentState != BLEConnectionState.baglanıyor) {
        startScan();
      }
    });
  }
  
  void stopAutoReconnect() {
    _reconnectTimer?.cancel();
  }
  
  void disconnect() {
    _isConnected = false;
    _updateState(BLEConnectionState.baglantiYok);
    stopAutoReconnect();
  }
  
  void dispose() {
    _dataController.close();
    _stateController.close();
    _reconnectTimer?.cancel();
  }
}

enum BLEConnectionState {
  baglantiYok,
  baglanıyor,
  baglantıKuruldu,
  veriAlınıyor
}

class OBDService {
  final BLEService bleService;
  StreamSubscription<String>? _dataSubscription;
  Completer<String>? _currentCommand;
  Timer? _timeoutTimer;
  
  OBDService(this.bleService) {
    _dataSubscription = bleService.dataStream.listen(_handleResponse);
  }
  
  Future<String> sendCommand(String command, {Duration timeout = const Duration(seconds: 5)}) async {
    _currentCommand = Completer<String>();
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(timeout, () {
      if (!_currentCommand!.isCompleted) {
        _currentCommand!.completeError(TimeoutException("Komut zaman aşımı"));
      }
    });
    
    await bleService.writeData(command);
    return _currentCommand!.future;
  }
  
  void _handleResponse(String response) {
    if (_currentCommand != null && !_currentCommand!.isCompleted) {
      _timeoutTimer?.cancel();
      _currentCommand!.complete(response);
      _currentCommand = null;
    }
  }
  
  Future<bool> initialize() async {
    try {
      await sendCommand("ATZ\r");
      await Future.delayed(Duration(milliseconds: 1000));
      await sendCommand("ATE0\r");
      await sendCommand("ATL0\r");
      await sendCommand("ATH1\r");
      await sendCommand("ATS0\r");
      await sendCommand("ATSP0\r");
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<String> readPID(String pid) async {
    String command = "01$pid\r";
    String response = await sendCommand(command);
    return response;
  }
  
  void dispose() {
    _dataSubscription?.cancel();
    _timeoutTimer?.cancel();
  }
}

class OBDResponseParser {
  static double parseHex(String hex) {
    return int.parse(hex, radix: 16).toDouble();
  }
  
  static String cleanResponse(String raw) {
    return raw.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '').toUpperCase();
  }
  
  static double parseTwoByteValue(String response, int offset) {
    String cleaned = cleanResponse(response);
    if (cleaned.length < offset + 4) return 0.0;
    String byte1 = cleaned.substring(offset, offset + 2);
    String byte2 = cleaned.substring(offset + 2, offset + 4);
    return (parseHex(byte1) * 256 + parseHex(byte2));
  }
  
  static double parseSingleByte(String response, int offset) {
    String cleaned = cleanResponse(response);
    if (cleaned.length < offset + 2) return 0.0;
    return parseHex(cleaned.substring(offset, offset + 2));
  }
}

class ICESensor {
  final String pid;
  final String description;
  final String unit;
  final double Function(String rawResponse) formula;
  
  ICESensor({
    required this.pid,
    required this.description,
    required this.unit,
    required this.formula,
  });
  
  static final List<ICESensor> allSensors = [
    ICESensor(
      pid: "010C",
      description: "Motor Devri",
      unit: "rpm",
      formula: (response) {
        String cleaned = OBDResponseParser.cleanResponse(response);
        if (cleaned.length < 6) return 0.0;
        double a = OBDResponseParser.parseHex(cleaned.substring(2, 4));
        double b = OBDResponseParser.parseHex(cleaned.substring(4, 6));
        return (a * 256 + b) / 4;
      },
    ),
    ICESensor(
      pid: "010D",
      description: "Araç Hızı",
      unit: "km/h",
      formula: (response) {
        return OBDResponseParser.parseSingleByte(response, 2);
      },
    ),
    ICESensor(
      pid: "0105",
      description: "Soğutucu Sıcaklığı",
      unit: "°C",
      formula: (response) {
        double value = OBDResponseParser.parseSingleByte(response, 2);
        return value - 40;
      },
    ),
    ICESensor(
      pid: "0110",
      description: "Hava Kütle Akışı",
      unit: "g/s",
      formula: (response) {
        return OBDResponseParser.parseTwoByteValue(response, 2) / 100;
      },
    ),
    ICESensor(
      pid: "0111",
      description: "Gaz Kelebeği Konumu",
      unit: "%",
      formula: (response) {
        return OBDResponseParser.parseSingleByte(response, 2) * 100 / 255;
      },
    ),
    ICESensor(
      pid: "010A",
      description: "Yakıt Basıncı",
      unit: "kPa",
      formula: (response) {
        return OBDResponseParser.parseSingleByte(response, 2) * 3;
      },
    ),
    ICESensor(
      pid: "0104",
      description: "Motor Yükü",
      unit: "%",
      formula: (response) {
        return OBDResponseParser.parseSingleByte(response, 2) * 100 / 255;
      },
    ),
    ICESensor(
      pid: "010E",
      description: "Ateşleme Avansı",
      unit: "°",
      formula: (response) {
        double value = OBDResponseParser.parseSingleByte(response, 2);
        return (value / 2) - 64;
      },
    ),
  ];
}

class EVSensor {
  final String pid;
  final String description;
  final String unit;
  final double Function(String rawResponse) formula;
  
  EVSensor({
    required this.pid,
    required this.description,
    required this.unit,
    required this.formula,
  });
  
  static final List<EVSensor> allSensors = [
    EVSensor(
      pid: "SOC",
      description: "Batarya Şarj Durumu",
      unit: "%",
      formula: (response) {
        String cleaned = OBDResponseParser.cleanResponse(response);
        if (cleaned.length < 4) return 0.0;
        return OBDResponseParser.parseHex(cleaned.substring(0, 2));
      },
    ),
    EVSensor(
      pid: "SOH",
      description: "Batarya Sağlık Durumu",
      unit: "%",
      formula: (response) {
        String cleaned = OBDResponseParser.cleanResponse(response);
        if (cleaned.length < 4) return 0.0;
        return OBDResponseParser.parseHex(cleaned.substring(2, 4));
      },
    ),
    EVSensor(
      pid: "CELL_MIN_V",
      description: "Minimum Hücre Voltajı",
      unit: "V",
      formula: (response) {
        return OBDResponseParser.parseTwoByteValue(response, 0) / 1000;
      },
    ),
    EVSensor(
      pid: "CELL_MAX_V",
      description: "Maksimum Hücre Voltajı",
      unit: "V",
      formula: (response) {
        return OBDResponseParser.parseTwoByteValue(response, 2) / 1000;
      },
    ),
    EVSensor(
      pid: "CELL_DELTA",
      description: "Hücre Voltaj Farkı",
      unit: "V",
      formula: (response) {
        double min = OBDResponseParser.parseTwoByteValue(response, 0) / 1000;
        double max = OBDResponseParser.parseTwoByteValue(response, 2) / 1000;
        return max - min;
      },
    ),
    EVSensor(
      pid: "BATT_TEMP",
      description: "Batarya Sıcaklığı",
      unit: "°C",
      formula: (response) {
        double value = OBDResponseParser.parseSingleByte(response, 0);
        return value - 40;
      },
    ),
    EVSensor(
      pid: "INV_TEMP",
      description: "İnverter Sıcaklığı",
      unit: "°C",
      formula: (response) {
        double value = OBDResponseParser.parseSingleByte(response, 1);
        return value - 40;
      },
    ),
    EVSensor(
      pid: "MOTOR_TEMP",
      description: "Motor Sıcaklığı",
      unit: "°C",
      formula: (response) {
        double value = OBDResponseParser.parseSingleByte(response, 2);
        return value - 40;
      },
    ),
    EVSensor(
      pid: "CHARGE_PWR_AC",
      description: "AC Şarj Gücü",
      unit: "kW",
      formula: (response) {
        return OBDResponseParser.parseTwoByteValue(response, 0) / 100;
      },
    ),
    EVSensor(
      pid: "CHARGE_PWR_DC",
      description: "DC Şarj Gücü",
      unit: "kW",
      formula: (response) {
        return OBDResponseParser.parseTwoByteValue(response, 2) / 100;
      },
    ),
    EVSensor(
      pid: "REGEN_PWR",
      description: "Rejeneratif Güç",
      unit: "kW",
      formula: (response) {
        return OBDResponseParser.parseTwoByteValue(response, 0) / 100;
      },
    ),
    EVSensor(
      pid: "NOM_VOLT",
      description: "Nominal Toplam Voltaj",
      unit: "V",
      formula: (response) {
        return OBDResponseParser.parseTwoByteValue(response, 0) / 10;
      },
    ),
    EVSensor(
      pid: "NOM_CURR",
      description: "Nominal Toplam Akım",
      unit: "A",
      formula: (response) {
        double value = OBDResponseParser.parseTwoByteValue(response, 0);
        return (value - 32768) / 10;
      },
    ),
  ];
}

class DTCService {
  final OBDService obdService;
  
  DTCService(this.obdService);
  
  Future<List<String>> readAllDTCs() async {
    try {
      String response = await obdService.sendCommand("03\r");
      return _parseDTCResponse(response);
    } catch (e) {
      return [];
    }
  }
  
  List<String> _parseDTCResponse(String response) {
    List<String> dtcs = [];
    String cleaned = OBDResponseParser.cleanResponse(response);
    if (cleaned.length < 4) return dtcs;
    
    int count = OBDResponseParser.parseHex(cleaned.substring(0, 2)).toInt();
    int offset = 2;
    
    for (int i = 0; i < count && offset + 4 <= cleaned.length; i++) {
      String byte1 = cleaned.substring(offset, offset + 2);
      String byte2 = cleaned.substring(offset + 2, offset + 4);
      
      int firstByte = OBDResponseParser.parseHex(byte1).toInt();
      int secondByte = OBDResponseParser.parseHex(byte2).toInt();
      
      String type = "";
      if ((firstByte & 0xC0) == 0x00) type = "P";
      else if ((firstByte & 0xC0) == 0x40) type = "C";
      else if ((firstByte & 0xC0) == 0x80) type = "B";
      else type = "U";
      
      int code1 = (firstByte & 0x3F) >> 4;
      int code2 = firstByte & 0x0F;
      int code3 = secondByte >> 4;
      int code4 = secondByte & 0x0F;
      
      String dtc = "$type$code1$code2$code3$code4";
      dtcs.add(dtc);
      offset += 4;
    }
    
    return dtcs;
  }
  
  Future<bool> clearSingleDTC(String dtc) async {
    try {
      String code = dtc.substring(1);
      String command = "04$code\r";
      await obdService.sendCommand(command);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> clearAllDTCs() async {
    try {
      await obdService.sendCommand("04\r");
      return true;
    } catch (e) {
      return false;
    }
  }
}

class AppTheme {
  static const Color arkaPlan = Color(0xFF1A1A1C);
  static const Color kartArkaPlan = Color(0xFF232326);
  static const Color yaziRengi = Color(0xFFF2F2F2);
  static const Color ikonRengi = Color(0xFFE50914);
  
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: arkaPlan,
      cardColor: kartArkaPlan,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: yaziRengi),
        bodyMedium: TextStyle(color: yaziRengi),
        bodySmall: TextStyle(color: yaziRengi),
        headlineLarge: TextStyle(color: yaziRengi),
        headlineMedium: TextStyle(color: yaziRengi),
        headlineSmall: TextStyle(color: yaziRengi),
      ),
      iconTheme: IconThemeData(color: ikonRengi),
    );
  }
}

class DigitalSpeedGauge extends StatelessWidget {
  final double speed;
  
  DigitalSpeedGauge({required this.speed});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.kartArkaPlan,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Hız",
            style: TextStyle(
              color: AppTheme.yaziRengi,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "${speed.toStringAsFixed(0)}",
            style: TextStyle(
              color: AppTheme.ikonRengi,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "km/h",
            style: TextStyle(
              color: AppTheme.yaziRengi,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class AnalogRPMGauge extends StatelessWidget {
  final double rpm;
  
  AnalogRPMGauge({required this.rpm});
  
  @override
  Widget build(BuildContext context) {
    double normalizedRpm = (rpm / 10000).clamp(0.0, 1.0);
    double angle = normalizedRpm * 270 - 135;
    
    return Container(
      width: 200,
      height: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.kartArkaPlan,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: RPMPainter(angle, rpm),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${rpm.toStringAsFixed(0)}",
                style: TextStyle(
                  color: AppTheme.ikonRengi,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "rpm",
                style: TextStyle(
                  color: AppTheme.yaziRengi,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RPMPainter extends CustomPainter {
  final double angle;
  final double rpm;
  
  RPMPainter(this.angle, this.rpm);
  
  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = AppTheme.arkaPlan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    
    Paint activePaint = Paint()
      ..color = AppTheme.ikonRengi
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2 - 20;
    
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -2.356,
      4.712,
      false,
      backgroundPaint,
    );
    
    double normalizedRpm = (rpm / 10000).clamp(0.0, 1.0);
    double sweepAngle = normalizedRpm * 4.712;
    
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -2.356,
      sweepAngle,
      false,
      activePaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BatterySOCGauge extends StatelessWidget {
  final double soc;
  
  BatterySOCGauge({required this.soc});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.kartArkaPlan,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: soc / 100,
              strokeWidth: 12,
              backgroundColor: AppTheme.arkaPlan,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.ikonRengi),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${soc.toStringAsFixed(0)}%",
                style: TextStyle(
                  color: AppTheme.ikonRengi,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "SOC",
                style: TextStyle(
                  color: AppTheme.yaziRengi,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PowerBar extends StatelessWidget {
  final double power;
  final String label;
  final double maxPower;
  
  PowerBar({
    required this.power,
    required this.label,
    this.maxPower = 200.0,
  });
  
  @override
  Widget build(BuildContext context) {
    double normalizedPower = (power / maxPower).clamp(0.0, 1.0);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.kartArkaPlan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.yaziRengi,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.arkaPlan,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              FractionallySizedBox(
                widthFactor: normalizedPower,
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.ikonRengi,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "${power.toStringAsFixed(1)} kW",
            style: TextStyle(
              color: AppTheme.ikonRengi,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TorqueBar extends StatelessWidget {
  final double torque;
  final double maxTorque;
  
  TorqueBar({
    required this.torque,
    this.maxTorque = 500.0,
  });
  
  @override
  Widget build(BuildContext context) {
    double normalizedTorque = (torque / maxTorque).clamp(0.0, 1.0);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.kartArkaPlan,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tork",
            style: TextStyle(
              color: AppTheme.yaziRengi,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.arkaPlan,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              FractionallySizedBox(
                widthFactor: normalizedTorque,
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.ikonRengi,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "${torque.toStringAsFixed(1)} Nm",
            style: TextStyle(
              color: AppTheme.ikonRengi,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TemperatureIndicator extends StatelessWidget {
  final double temperature;
  final String label;
  
  TemperatureIndicator({
    required this.temperature,
    required this.label,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.kartArkaPlan,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.thermostat,
            color: AppTheme.ikonRengi,
            size: 20,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.yaziRengi,
                  fontSize: 12,
                ),
              ),
              Text(
                "${temperature.toStringAsFixed(1)}°C",
                style: TextStyle(
                  color: AppTheme.ikonRengi,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OBDApp extends StatefulWidget {
  @override
  _OBDAppState createState() => _OBDAppState();
}

class _OBDAppState extends State<OBDApp> {
  late BLEService bleService;
  late OBDService obdService;
  late DTCService dtcService;
  
  bool isEV = false;
  double speed = 0.0;
  double rpm = 0.0;
  double soc = 85.0;
  double power = 45.0;
  double torque = 120.0;
  double batteryTemp = 28.0;
  double motorTemp = 35.0;
  
  Timer? _dataUpdateTimer;
  
  @override
  void initState() {
    super.initState();
    bleService = BLEService();
    obdService = OBDService(bleService);
    dtcService = DTCService(obdService);
    
    bleService.stateStream.listen((state) {
      if (state == BLEConnectionState.veriAlınıyor) {
        obdService.initialize().then((success) {
          if (success) {
            _startDataUpdates();
          }
        });
      }
    });
    
    bleService.startScan();
    bleService.startAutoReconnect();
  }
  
  void _startDataUpdates() {
    _dataUpdateTimer?.cancel();
    _dataUpdateTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      _updateSensorData();
    });
  }
  
  void _updateSensorData() {
    if (isEV) {
      _updateEVData();
    } else {
      _updateICEData();
    }
  }
  
  void _updateICEData() async {
    try {
      String rpmResponse = await obdService.readPID("010C");
      String speedResponse = await obdService.readPID("010D");
      
      ICESensor rpmSensor = ICESensor.allSensors.firstWhere((s) => s.pid == "010C");
      ICESensor speedSensor = ICESensor.allSensors.firstWhere((s) => s.pid == "010D");
      
      setState(() {
        rpm = rpmSensor.formula(rpmResponse);
        speed = speedSensor.formula(speedResponse);
      });
    } catch (e) {
    }
  }
  
  void _updateEVData() async {
    setState(() {
      soc = 85.0 + Random().nextDouble() * 5.0;
      power = 45.0 + Random().nextDouble() * 10.0;
      batteryTemp = 28.0 + Random().nextDouble() * 2.0;
      motorTemp = 35.0 + Random().nextDouble() * 3.0;
    });
  }
  
  @override
  void dispose() {
    _dataUpdateTimer?.cancel();
    obdService.dispose();
    bleService.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: Scaffold(
        backgroundColor: AppTheme.arkaPlan,
        appBar: AppBar(
          backgroundColor: AppTheme.kartArkaPlan,
          title: Text(
            "OBD-II Profesyonel",
            style: TextStyle(color: AppTheme.yaziRengi),
          ),
          actions: [
            StreamBuilder<BLEConnectionState>(
              stream: bleService.stateStream,
              initialData: BLEConnectionState.baglantiYok,
              builder: (context, snapshot) {
                IconData iconData;
                Color iconColor;
                
                switch (snapshot.data) {
                  case BLEConnectionState.baglantiYok:
                    iconData = Icons.bluetooth_disabled;
                    iconColor = Colors.grey;
                    break;
                  case BLEConnectionState.baglanıyor:
                    iconData = Icons.bluetooth_searching;
                    iconColor = Colors.orange;
                    break;
                  case BLEConnectionState.baglantıKuruldu:
                    iconData = Icons.bluetooth_connected;
                    iconColor = Colors.blue;
                    break;
                  case BLEConnectionState.veriAlınıyor:
                    iconData = Icons.bluetooth;
                    iconColor = AppTheme.ikonRengi;
                    break;
                  default:
                    iconData = Icons.bluetooth_disabled;
                    iconColor = Colors.grey;
                }
                
                return Icon(iconData, color: iconColor);
              },
            ),
            SizedBox(width: 16),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: DigitalSpeedGauge(speed: speed)),
                  SizedBox(width: 16),
                  if (!isEV) AnalogRPMGauge(rpm: rpm),
                  if (isEV) BatterySOCGauge(soc: soc),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: PowerBar(power: power, label: "Güç")),
                  SizedBox(width: 16),
                  Expanded(child: TorqueBar(torque: torque)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TemperatureIndicator(
                    temperature: batteryTemp,
                    label: "Batarya",
                  ),
                  TemperatureIndicator(
                    temperature: motorTemp,
                    label: "Motor",
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppTheme.kartArkaPlan,
          selectedItemColor: AppTheme.ikonRengi,
          unselectedItemColor: AppTheme.yaziRengi,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Gösterge",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bug_report),
              label: "Arıza Kodları",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Ayarlar",
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(OBDApp());
}
