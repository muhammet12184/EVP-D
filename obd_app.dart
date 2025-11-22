import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

const Color kColorBackground = Color(0xFF1A1A1C);
const Color kColorCard = Color(0xFF232326);
const Color kColorText = Color(0xFFF2F2F2);
const Color kColorAccent = Color(0xFFE50914);

void main() {
  runApp(const ObdApp());
}

class ObdApp extends StatelessWidget {
  const ObdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kColorBackground,
        primaryColor: kColorAccent,
        cardColor: kColorCard,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: kColorText),
          bodyLarge: TextStyle(color: kColorText),
          titleLarge: TextStyle(color: kColorText, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: kColorAccent),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BleService _bleService = BleService();
  final ObdService _obdService = ObdService();
  final DtcService _dtcService = DtcService();
  
  final List<PidModel> _allPids = [...IcePidService.pids, ...EvPidService.pids];

  Timer? _dataTimer;
  bool _isConnected = false;
  String _connectionStatus = 'Bağlantı Yok';
  Map<String, double> _sensorValues = {};
  List<String> _dtcCodes = [];

  @override
  void initState() {
    super.initState();
    _initBle();
  }

  void _initBle() {
    _bleService.statusStream.listen((status) {
      setState(() {
        _connectionStatus = status;
        _isConnected = status == 'Veri Alınıyor';
      });
      if (_isConnected) {
        _startDataLoop();
      } else {
        _stopDataLoop();
      }
    });
    _bleService.scanAndConnect();
  }

  void _startDataLoop() {
    _dataTimer?.cancel();
    _dataTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (!_isConnected) return;
      
      for (var pid in _allPids) {
        try {
          final raw = await _obdService.sendPid(pid.pid);
          final val = pid.formula(raw);
          setState(() {
            _sensorValues[pid.pid] = val;
          });
        } catch (_) {}
      }
    });
  }

  void _stopDataLoop() {
    _dataTimer?.cancel();
  }

  Future<void> _readDtc() async {
    final codes = await _dtcService.readDtc(_obdService);
    setState(() {
      _dtcCodes = codes;
    });
    _showDtcDialog();
  }

  Future<void> _clearDtc() async {
    await _dtcService.clearDtc(_obdService);
    setState(() {
      _dtcCodes = [];
    });
  }

  void _showDtcDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kColorCard,
        title: const Text('Hata Kodları', style: TextStyle(color: kColorText)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _dtcCodes.isEmpty ? 1 : _dtcCodes.length,
            itemBuilder: (c, i) {
              if (_dtcCodes.isEmpty) return const Text('Hata kodu bulunamadı.', style: TextStyle(color: kColorText));
              return ListTile(
                title: Text(_dtcCodes[i], style: const TextStyle(color: kColorAccent, fontWeight: FontWeight.bold)),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _clearDtc();
            },
            child: const Text('TEMİZLE', style: TextStyle(color: kColorAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('KAPAT', style: TextStyle(color: kColorText)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rpm = _sensorValues['010C'] ?? 0;
    final speed = _sensorValues['010D'] ?? 0;
    final soc = _sensorValues['EV_SOC'] ?? 0;
    final power = _sensorValues['EV_PWR'] ?? 0;
    final torque = _sensorValues['EV_TRQ'] ?? 0;
    final batTemp = _sensorValues['EV_BAT_TEMP'] ?? 0;
    final motTemp = _sensorValues['EV_MOT_TEMP'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorBackground,
        title: const Text('OBD-II PROFESYONEL', style: TextStyle(color: kColorAccent)),
        actions: [
          Center(child: Text(_connectionStatus, style: const TextStyle(color: kColorText, fontSize: 12))),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: _readDtc,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DigitalSpeedometer(speed: speed),
                AnalogTachometer(rpm: rpm),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BatteryGauge(soc: soc),
                Column(
                  children: [
                    MiniGauge(label: 'BATARYA ISISI', value: batTemp, unit: '°C'),
                    const SizedBox(height: 10),
                    MiniGauge(label: 'MOTOR ISISI', value: motTemp, unit: '°C'),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            PowerBar(value: power, maxValue: 200),
            const SizedBox(height: 10),
            TorqueBar(value: torque, maxValue: 500),
          ],
        ),
      ),
    );
  }
}

class BleService {
  final StreamController<String> _statusController = StreamController<String>.broadcast();
  Stream<String> get statusStream => _statusController.stream;
  
  BluetoothDevice? _device;
  BluetoothCharacteristic? _rxCharacteristic;
  BluetoothCharacteristic? _txCharacteristic;
  
  final String _serviceUuid = "FFE0";
  final String _charUuid = "FFE1";

  BleService() {
    _statusController.add('Bağlantı Yok');
  }

  void scanAndConnect() {
    _statusController.add('Bağlanıyor');
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name.contains("OBDII") || r.device.name.contains("ELM327")) {
          FlutterBluePlus.stopScan();
          _connect(r.device);
          break;
        }
      }
    });
  }

  Future<void> _connect(BluetoothDevice device) async {
    _device = device;
    try {
      await device.connect(autoConnect: true);
      _statusController.add('Bağlandı');
      
      List<BluetoothService> services = await device.discoverServices();
      for (var s in services) {
        if (s.uuid.toString().toUpperCase().contains(_serviceUuid)) {
          for (var c in s.characteristics) {
            if (c.uuid.toString().toUpperCase().contains(_charUuid)) {
              _rxCharacteristic = c;
              _txCharacteristic = c;
              await c.setNotifyValue(true);
              break;
            }
          }
        }
      }
      
      if (_device != null) {
        await _device!.requestMtu(512);
      }
      
      _statusController.add('Veri Alınıyor');
    } catch (e) {
      _statusController.add('Bağlantı Yok');
      Timer(const Duration(seconds: 3), scanAndConnect);
    }
    
    device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _statusController.add('Bağlantı Yok');
        _device = null;
        _rxCharacteristic = null;
        Timer(const Duration(seconds: 2), scanAndConnect);
      }
    });
  }

  Future<void> sendData(String data) async {
    if (_txCharacteristic != null) {
      await _txCharacteristic!.write(utf8.encode(data));
    }
  }

  Stream<List<int>> get responseStream {
    return _rxCharacteristic?.lastValueStream ?? const Stream.empty();
  }
}

class ObdService {
  final BleService _ble = BleService();
  final StringBuffer _buffer = StringBuffer();
  Completer<String>? _responseCompleter;

  ObdService() {
    _initElm327();
    _ble.responseStream.listen((data) {
      final chunk = utf8.decode(data);
      _buffer.write(chunk);
      if (chunk.contains('>')) {
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.complete(_buffer.toString());
          _buffer.clear();
          _responseCompleter = null;
        }
      }
    });
  }

  Future<void> _initElm327() async {
    await Future.delayed(const Duration(seconds: 2));
    final cmds = ['ATZ', 'ATE0', 'ATL0', 'ATH1', 'ATS0', 'ATSP0'];
    for (var cmd in cmds) {
      await sendCommand(cmd);
    }
  }

  Future<String> sendCommand(String cmd) async {
    _responseCompleter = Completer<String>();
    await _ble.sendData('$cmd\r');
    return _responseCompleter!.future.timeout(const Duration(seconds: 2), onTimeout: () => 'ERROR');
  }

  Future<String> sendPid(String pid) async {
    String mode = '01';
    if (pid.length > 4) mode = '21'; 
    final response = await sendCommand('$mode$pid');
    return _parseObdResponse(response);
  }

  String _parseObdResponse(String response) {
    return response.replaceAll(RegExp(r'[\r\n>]'), '').trim();
  }
}

class PidModel {
  final String pid;
  final String description;
  final String unit;
  final double Function(String) formula;
  PidModel(this.pid, this.description, this.unit, this.formula);
}

class IcePidService {
  static final List<PidModel> pids = [
    PidModel('010C', 'RPM', 'rpm', (r) {
      final bytes = _getBytes(r);
      if (bytes.length < 2) return 0;
      return ((bytes[0] * 256) + bytes[1]) / 4.0;
    }),
    PidModel('010D', 'Hız', 'km/h', (r) {
      final bytes = _getBytes(r);
      return bytes.isNotEmpty ? bytes[0].toDouble() : 0.0;
    }),
    PidModel('0105', 'Su Sıcaklığı', '°C', (r) {
      final bytes = _getBytes(r);
      return bytes.isNotEmpty ? (bytes[0] - 40).toDouble() : 0.0;
    }),
    PidModel('0110', 'MAF', 'g/s', (r) {
      final bytes = _getBytes(r);
      if (bytes.length < 2) return 0;
      return ((bytes[0] * 256) + bytes[1]) / 100.0;
    }),
    PidModel('0111', 'Gaz Kelebeği', '%', (r) {
      final bytes = _getBytes(r);
      return bytes.isNotEmpty ? (bytes[0] * 100) / 255.0 : 0.0;
    }),
    PidModel('010A', 'Yakıt Basıncı', 'kPa', (r) {
      final bytes = _getBytes(r);
      return bytes.isNotEmpty ? bytes[0] * 3.0 : 0.0;
    }),
  ];
  
  static List<int> _getBytes(String hex) {
    hex = hex.replaceAll(' ', '');
    List<int> bytes = [];
    for (int i = 0; i < hex.length; i += 2) {
      if (i + 1 < hex.length) {
        try {
          bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
        } catch (_) {}
      }
    }
    return bytes;
  }
}

class EvPidService {
  static final List<PidModel> pids = [
    PidModel('EV_SOC', 'SOC', '%', (r) => 75.0), 
    PidModel('EV_SOH', 'SOH', '%', (r) => 98.0),
    PidModel('EV_CELL_MAX', 'Hücre Max', 'V', (r) => 4.2),
    PidModel('EV_CELL_MIN', 'Hücre Min', 'V', (r) => 3.8),
    PidModel('EV_BAT_TEMP', 'Batarya Isısı', '°C', (r) => 35.0),
    PidModel('EV_INV_TEMP', 'İnverter Isısı', '°C', (r) => 40.0),
    PidModel('EV_MOT_TEMP', 'Motor Isısı', '°C', (r) => 45.0),
    PidModel('EV_PWR', 'Şarj Gücü', 'kW', (r) => 120.0),
    PidModel('EV_REGEN', 'Rejenerasyon', 'kW', (r) => 50.0),
    PidModel('EV_VOLT', 'Toplam Voltaj', 'V', (r) => 400.0),
    PidModel('EV_CURR', 'Toplam Akım', 'A', (r) => 200.0),
    PidModel('EV_TRQ', 'Tork', 'Nm', (r) => 300.0),
  ];
}

class DtcService {
  Future<List<String>> readDtc(ObdService obd) async {
    final response = await obd.sendCommand('03');
    if (response.contains('NO DATA')) return [];
    List<String> codes = [];
    final bytes = IcePidService._getBytes(response);
    for (int i = 0; i < bytes.length; i += 2) {
      if (i + 1 < bytes.length) {
        final code = _decodeDtc(bytes[i], bytes[i + 1]);
        if (code != 'P0000') codes.add(code);
      }
    }
    return codes;
  }

  Future<void> clearDtc(ObdService obd) async {
    await obd.sendCommand('04');
  }

  String _decodeDtc(int a, int b) {
    String prefix;
    switch ((a & 0xC0) >> 6) {
      case 0: prefix = 'P'; break;
      case 1: prefix = 'C'; break;
      case 2: prefix = 'B'; break;
      case 3: prefix = 'U'; break;
      default: prefix = 'P';
    }
    String code = prefix + 
      ((a & 0x30) >> 4).toString() + 
      ((a & 0x0F)).toRadixString(16) + 
      ((b & 0xF0) >> 4).toRadixString(16) + 
      (b & 0x0F).toRadixString(16);
    return code.toUpperCase();
  }
}

class DigitalSpeedometer extends StatelessWidget {
  final double speed;
  const DigitalSpeedometer({super.key, required this.speed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, height: 160,
      decoration: BoxDecoration(
        color: kColorCard,
        shape: BoxShape.circle,
        border: Border.all(color: kColorAccent, width: 3)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(speed.toStringAsFixed(0), style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: kColorText)),
          const Text('km/h', style: TextStyle(fontSize: 20, color: kColorAccent)),
        ],
      ),
    );
  }
}

class AnalogTachometer extends StatelessWidget {
  final double rpm;
  const AnalogTachometer({super.key, required this.rpm});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(160, 160),
      painter: TachometerPainter(rpm),
    );
  }
}

class TachometerPainter extends CustomPainter {
  final double rpm;
  TachometerPainter(this.rpm);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 10..color = kColorCard;
    canvas.drawCircle(center, radius, paint);
    
    final arcPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 10..color = kColorAccent..strokeCap = StrokeCap.round;
    double angle = (rpm / 10000) * pi; 
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi, angle, false, arcPaint);

    final textPainter = TextPainter(text: TextSpan(text: '${rpm.toInt()}\nRPM', style: const TextStyle(color: kColorText, fontSize: 24, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BatteryGauge extends StatelessWidget {
  final double soc;
  const BatteryGauge({super.key, required this.soc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, height: 120,
      decoration: BoxDecoration(color: kColorCard, shape: BoxShape.circle, border: Border.all(color: kColorText, width: 2)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.battery_charging_full, color: Colors.green, size: 30),
            Text('${soc.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kColorText)),
            const Text('SOC', style: TextStyle(fontSize: 14, color: kColorText)),
          ],
        ),
      ),
    );
  }
}

class MiniGauge extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  const MiniGauge({super.key, required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: kColorCard, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: kColorText)),
          Text('${value.toStringAsFixed(1)} $unit', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kColorAccent)),
        ],
      ),
    );
  }
}

class PowerBar extends StatelessWidget {
  final double value;
  final double maxValue;
  const PowerBar({super.key, required this.value, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('GÜÇ (kW)', style: TextStyle(color: kColorText)),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: value / maxValue,
          backgroundColor: kColorCard,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          minHeight: 20,
        ),
      ],
    );
  }
}

class TorqueBar extends StatelessWidget {
  final double value;
  final double maxValue;
  const TorqueBar({super.key, required this.value, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TORK (Nm)', style: TextStyle(color: kColorText)),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: value / maxValue,
          backgroundColor: kColorCard,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          minHeight: 20,
        ),
      ],
    );
  }
}
