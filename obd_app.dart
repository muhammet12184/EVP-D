import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Color(0xFF1A1A1C),
      cardColor: Color(0xFF232326),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: Color(0xFFF2F2F2)),
      ),
    ),
    home: OBDApp(),
  ));
}

class OBDApp extends StatefulWidget {
  @override
  _OBDAppState createState() => _OBDAppState();
}

class _OBDAppState extends State<OBDApp> {
  final BLEManager bleManager = BLEManager();
  final OBDService obdService = OBDService();
  final BehaviorSubject<Map<String, double>> _sensorData = BehaviorSubject.seeded({});
  final BehaviorSubject<List<String>> _dtcCodes = BehaviorSubject.seeded([]);
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  void _initializeApp() async {
    bleManager.connectionStateStream.listen((state) {
      if (state == BLEConnectionState.connected) {
        obdService.setBLEManager(bleManager);
        obdService.initialize();
        _startDataPolling();
      }
    });
    bleManager.startScan();
  }
  
  void _startDataPolling() {
    Timer.periodic(Duration(milliseconds: 250), (_) async {
      if (bleManager.connectionState == BLEConnectionState.connected) {
        Map<String, double> data = {};
        for (var sensor in [...ICESensors.sensors, ...EVSensors.sensors]) {
          final value = await obdService.readPID(sensor);
          if (value != null) {
            data[sensor.pid] = value;
          }
        }
        _sensorData.add(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<BLEConnectionState>(
          stream: bleManager.connectionStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data ?? BLEConnectionState.noConnection;
            
            if (state != BLEConnectionState.connected) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFE50914)),
                    SizedBox(height: 20),
                    Text(
                      _getConnectionStateText(state),
                      style: TextStyle(fontSize: 18, color: Color(0xFFF2F2F2)),
                    ),
                  ],
                ),
              );
            }
            
            return StreamBuilder<Map<String, double>>(
              stream: _sensorData,
              builder: (context, dataSnapshot) {
                final data = dataSnapshot.data ?? {};
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: SpeedometerWidget(speed: data['010D'] ?? 0)),
                          SizedBox(width: 16),
                          Expanded(child: RPMGaugeWidget(rpm: data['010C'] ?? 0)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: BatterySOCWidget(soc: data['SOC'] ?? 0)),
                          SizedBox(width: 16),
                          Expanded(child: PowerBarWidget(power: data['POWER'] ?? 0)),
                        ],
                      ),
                      SizedBox(height: 20),
                      TorqueBarWidget(torque: data['TORQUE'] ?? 0),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TemperatureWidget(
                            label: 'Batarya Sıcaklığı',
                            temperature: data['BATT_TEMP'] ?? 0,
                          ),
                          TemperatureWidget(
                            label: 'Motor Sıcaklığı',
                            temperature: data['MOTOR_TEMP'] ?? 0,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE50914),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final codes = await obdService.readDTCCodes();
                          _dtcCodes.add(codes);
                          _showDTCDialog(codes);
                        },
                        child: Text('Arıza Kodlarını Oku'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
  
  String _getConnectionStateText(BLEConnectionState state) {
    switch (state) {
      case BLEConnectionState.noConnection:
        return 'Bağlantı Yok';
      case BLEConnectionState.connecting:
        return 'Bağlanıyor...';
      case BLEConnectionState.connected:
        return 'Bağlandı';
      case BLEConnectionState.dataReceiving:
        return 'Veri Alınıyor';
    }
  }
  
  void _showDTCDialog(List<String> codes) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF232326),
        title: Text('Arıza Kodları', style: TextStyle(color: Color(0xFFF2F2F2))),
        content: codes.isEmpty
            ? Text('Arıza kodu bulunamadı', style: TextStyle(color: Color(0xFFF2F2F2)))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: codes.map((code) => 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(code, style: TextStyle(color: Color(0xFFF2F2F2))),
                      IconButton(
                        icon: Icon(Icons.delete, color: Color(0xFFE50914)),
                        onPressed: () async {
                          await obdService.clearSpecificDTC(code);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ).toList(),
              ),
        actions: [
          if (codes.isNotEmpty)
            TextButton(
              onPressed: () async {
                await obdService.clearAllDTCs();
                Navigator.pop(context);
              },
              child: Text('Tümünü Temizle', style: TextStyle(color: Color(0xFFE50914))),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat', style: TextStyle(color: Color(0xFFF2F2F2))),
          ),
        ],
      ),
    );
  }
}

enum BLEConnectionState {
  noConnection,
  connecting,
  connected,
  dataReceiving,
}

class BLEManager {
  static const String SERVICE_UUID = "0000fff0-0000-1000-8000-00805f9b34fb";
  static const String RX_CHARACTERISTIC_UUID = "0000fff1-0000-1000-8000-00805f9b34fb";
  static const String TX_CHARACTERISTIC_UUID = "0000fff2-0000-1000-8000-00805f9b34fb";
  
  BluetoothDevice? _device;
  BluetoothCharacteristic? _rxCharacteristic;
  BluetoothCharacteristic? _txCharacteristic;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _connectionSubscription;
  
  final BehaviorSubject<BLEConnectionState> _connectionStateSubject = 
      BehaviorSubject.seeded(BLEConnectionState.noConnection);
  
  Stream<BLEConnectionState> get connectionStateStream => _connectionStateSubject.stream;
  BLEConnectionState get connectionState => _connectionStateSubject.value;
  
  final StreamController<String> _dataStreamController = StreamController.broadcast();
  Stream<String> get dataStream => _dataStreamController.stream;
  
  void startScan() async {
    _connectionStateSubject.add(BLEConnectionState.connecting);
    
    _scanSubscription?.cancel();
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        if (result.device.name.toUpperCase().contains('OBD') || 
            result.device.name.toUpperCase().contains('ELM327')) {
          _connectToDevice(result.device);
          stopScan();
          break;
        }
      }
    });
    
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
  }
  
  void stopScan() {
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
  }
  
  Future<void> _connectToDevice(BluetoothDevice device) async {
    _device = device;
    
    try {
      await device.connect(autoConnect: true);
      _connectionStateSubject.add(BLEConnectionState.connected);
      
      _connectionSubscription = device.state.listen((state) {
        if (state == BluetoothDeviceState.disconnected) {
          _handleDisconnection();
        }
      });
      
      await _discoverServices();
      await _setupMTU();
    } catch (e) {
      _connectionStateSubject.add(BLEConnectionState.noConnection);
      _reconnect();
    }
  }
  
  Future<void> _discoverServices() async {
    if (_device == null) return;
    
    List<BluetoothService> services = await _device!.discoverServices();
    for (var service in services) {
      if (service.uuid.toString().toLowerCase() == SERVICE_UUID) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toLowerCase() == RX_CHARACTERISTIC_UUID) {
            _rxCharacteristic = characteristic;
            await characteristic.setNotifyValue(true);
            characteristic.value.listen((data) {
              if (data.isNotEmpty) {
                _dataStreamController.add(String.fromCharCodes(data));
                _connectionStateSubject.add(BLEConnectionState.dataReceiving);
              }
            });
          } else if (characteristic.uuid.toString().toLowerCase() == TX_CHARACTERISTIC_UUID) {
            _txCharacteristic = characteristic;
          }
        }
      }
    }
  }
  
  Future<void> _setupMTU() async {
    if (_device != null) {
      try {
        await _device!.requestMtu(512);
      } catch (_) {}
    }
  }
  
  void _handleDisconnection() {
    _connectionStateSubject.add(BLEConnectionState.noConnection);
    _reconnect();
  }
  
  void _reconnect() {
    Timer(Duration(seconds: 2), () {
      if (_connectionStateSubject.value == BLEConnectionState.noConnection) {
        startScan();
      }
    });
  }
  
  Future<void> sendCommand(String command) async {
    if (_txCharacteristic != null && _device != null) {
      await _txCharacteristic!.write(Uint8List.fromList('$command\r'.codeUnits));
    }
  }
  
  void dispose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    _dataStreamController.close();
    _connectionStateSubject.close();
    _device?.disconnect();
  }
}

class OBDService {
  BLEManager? _bleManager;
  final StreamController<String> _responseController = StreamController.broadcast();
  String _buffer = '';
  
  void setBLEManager(BLEManager manager) {
    _bleManager = manager;
    _bleManager!.dataStream.listen((data) {
      _buffer += data;
      if (_buffer.contains('>')) {
        final response = _buffer.substring(0, _buffer.indexOf('>'));
        _buffer = _buffer.substring(_buffer.indexOf('>') + 1);
        _responseController.add(response.trim());
      }
    });
  }
  
  Future<void> initialize() async {
    await _sendCommand('ATZ');
    await Future.delayed(Duration(milliseconds: 1000));
    await _sendCommand('ATE0');
    await _sendCommand('ATL0');
    await _sendCommand('ATH1');
    await _sendCommand('ATS0');
    await _sendCommand('ATSP0');
  }
  
  Future<String?> _sendCommand(String command, {int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      try {
        await _bleManager?.sendCommand(command);
        
        final response = await _responseController.stream
            .timeout(Duration(seconds: 2))
            .first;
        
        if (!response.contains('NO DATA') && 
            !response.contains('ERROR') &&
            !response.contains('UNABLE TO CONNECT')) {
          return response;
        }
      } catch (_) {}
      
      if (i < retries - 1) {
        await Future.delayed(Duration(milliseconds: 500));
      }
    }
    return null;
  }
  
  Future<double?> readPID(OBDSensor sensor) async {
    final response = await _sendCommand(sensor.pid);
    if (response != null) {
      return sensor.formula(response);
    }
    return null;
  }
  
  Future<List<String>> readDTCCodes() async {
    List<String> codes = [];
    final response = await _sendCommand('03');
    if (response != null && !response.contains('NO DATA')) {
      codes = _parseDTCResponse(response);
    }
    return codes;
  }
  
  Future<void> clearSpecificDTC(String code) async {
    await _sendCommand('04');
  }
  
  Future<void> clearAllDTCs() async {
    await _sendCommand('04');
  }
  
  List<String> _parseDTCResponse(String response) {
    List<String> codes = [];
    final lines = response.split('\n');
    for (var line in lines) {
      final bytes = line.replaceAll(' ', '').trim();
      if (bytes.length >= 4) {
        for (int i = 0; i < bytes.length - 3; i += 4) {
          final dtcBytes = bytes.substring(i, i + 4);
          if (dtcBytes != '0000') {
            codes.add(_decodeDTC(dtcBytes));
          }
        }
      }
    }
    return codes;
  }
  
  String _decodeDTC(String bytes) {
    final firstByte = int.parse(bytes.substring(0, 2), radix: 16);
    String prefix = 'P';
    switch ((firstByte >> 6) & 0x03) {
      case 0: prefix = 'P'; break;
      case 1: prefix = 'C'; break;
      case 2: prefix = 'B'; break;
      case 3: prefix = 'U'; break;
    }
    final code = ((firstByte & 0x3F) << 8) | int.parse(bytes.substring(2, 4), radix: 16);
    return '$prefix${code.toRadixString(16).padLeft(4, '0').toUpperCase()}';
  }
  
  void dispose() {
    _responseController.close();
  }
}

class OBDSensor {
  final String pid;
  final String description;
  final String unit;
  final double Function(String) formula;
  
  OBDSensor({
    required this.pid,
    required this.description,
    required this.unit,
    required this.formula,
  });
}

class ICESensors {
  static final List<OBDSensor> sensors = [
    OBDSensor(
      pid: '010C',
      description: 'Motor Devri',
      unit: 'RPM',
      formula: (response) {
        final bytes = _parseBytes(response);
        if (bytes.length >= 2) {
          return ((bytes[0] * 256) + bytes[1]) / 4.0;
        }
        return 0;
      },
    ),
    OBDSensor(
      pid: '010D',
      description: 'Hız',
      unit: 'km/h',
      formula: (response) {
        final bytes = _parseBytes(response);
        return bytes.isNotEmpty ? bytes[0].toDouble() : 0;
      },
    ),
    OBDSensor(
      pid: '0105',
      description: 'Su Sıcaklığı',
      unit: '°C',
      formula: (response) {
        final bytes = _parseBytes(response);
        return bytes.isNotEmpty ? bytes[0] - 40.0 : 0;
      },
    ),
    OBDSensor(
      pid: '0110',
      description: 'MAF',
      unit: 'g/s',
      formula: (response) {
        final bytes = _parseBytes(response);
        if (bytes.length >= 2) {
          return ((bytes[0] * 256) + bytes[1]) / 100.0;
        }
        return 0;
      },
    ),
    OBDSensor(
      pid: '0111',
      description: 'Gaz Kelebeği',
      unit: '%',
      formula: (response) {
        final bytes = _parseBytes(response);
        return bytes.isNotEmpty ? (bytes[0] * 100.0 / 255.0) : 0;
      },
    ),
    OBDSensor(
      pid: '010A',
      description: 'Yakıt Basıncı',
      unit: 'kPa',
      formula: (response) {
        final bytes = _parseBytes(response);
        return bytes.isNotEmpty ? bytes[0] * 3.0 : 0;
      },
    ),
  ];
  
  static List<int> _parseBytes(String response) {
    final cleanResponse = response.replaceAll(' ', '').replaceAll('41', '');
    if (cleanResponse.length >= 4) {
      final dataBytes = cleanResponse.substring(2);
      List<int> bytes = [];
      for (int i = 0; i < dataBytes.length - 1; i += 2) {
        bytes.add(int.parse(dataBytes.substring(i, i + 2), radix: 16));
      }
      return bytes;
    }
    return [];
  }
}

class EVSensors {
  static final List<OBDSensor> sensors = [
    OBDSensor(
      pid: 'SOC',
      description: 'Batarya Şarj Durumu',
      unit: '%',
      formula: (response) => _parseEVValue(response, 0, 100),
    ),
    OBDSensor(
      pid: 'SOH',
      description: 'Batarya Sağlığı',
      unit: '%',
      formula: (response) => _parseEVValue(response, 0, 100),
    ),
    OBDSensor(
      pid: 'CELL_MIN_V',
      description: 'Minimum Hücre Voltajı',
      unit: 'V',
      formula: (response) => _parseEVValue(response, 0, 5),
    ),
    OBDSensor(
      pid: 'CELL_MAX_V',
      description: 'Maksimum Hücre Voltajı',
      unit: 'V',
      formula: (response) => _parseEVValue(response, 0, 5),
    ),
    OBDSensor(
      pid: 'CELL_DELTA',
      description: 'Hücre Delta',
      unit: 'mV',
      formula: (response) => _parseEVValue(response, 0, 500),
    ),
    OBDSensor(
      pid: 'BATT_TEMP',
      description: 'Batarya Sıcaklığı',
      unit: '°C',
      formula: (response) => _parseEVValue(response, -40, 100),
    ),
    OBDSensor(
      pid: 'INV_TEMP',
      description: 'İnverter Sıcaklığı',
      unit: '°C',
      formula: (response) => _parseEVValue(response, -40, 150),
    ),
    OBDSensor(
      pid: 'MOTOR_TEMP',
      description: 'Motor Sıcaklığı',
      unit: '°C',
      formula: (response) => _parseEVValue(response, -40, 150),
    ),
    OBDSensor(
      pid: 'CHARGE_POWER',
      description: 'Şarj Gücü',
      unit: 'kW',
      formula: (response) => _parseEVValue(response, 0, 350),
    ),
    OBDSensor(
      pid: 'REGEN_POWER',
      description: 'Rejenerasyon Gücü',
      unit: 'kW',
      formula: (response) => _parseEVValue(response, -150, 0),
    ),
    OBDSensor(
      pid: 'POWER',
      description: 'Güç',
      unit: 'kW',
      formula: (response) => _parseEVValue(response, -200, 400),
    ),
    OBDSensor(
      pid: 'TORQUE',
      description: 'Tork',
      unit: 'Nm',
      formula: (response) => _parseEVValue(response, -500, 1000),
    ),
  ];
  
  static double _parseEVValue(String response, double min, double max) {
    try {
      final cleanResponse = response.replaceAll(' ', '').replaceAll('7E8', '');
      if (cleanResponse.length >= 4) {
        final value = int.parse(cleanResponse.substring(0, 4), radix: 16);
        return min + (value / 65535.0) * (max - min);
      }
    } catch (_) {}
    return min;
  }
}

class SpeedometerWidget extends StatelessWidget {
  final double speed;
  
  const SpeedometerWidget({required this.speed});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Hız',
            style: TextStyle(color: Color(0xFFF2F2F2), fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            '${speed.toStringAsFixed(0)}',
            style: TextStyle(
              color: Color(0xFFE50914),
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'km/h',
            style: TextStyle(color: Color(0xFFF2F2F2), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class RPMGaugeWidget extends StatelessWidget {
  final double rpm;
  
  const RPMGaugeWidget({required this.rpm});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomPaint(
        painter: RPMPainter(rpm: rpm),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'RPM',
                style: TextStyle(color: Color(0xFFF2F2F2), fontSize: 16),
              ),
              Text(
                '${rpm.toStringAsFixed(0)}',
                style: TextStyle(
                  color: Color(0xFFE50914),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
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
  final double rpm;
  
  RPMPainter({required this.rpm});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20;
    
    final backgroundPaint = Paint()
      ..color = Color(0xFF1A1A1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    
    final progressPaint = Paint()
      ..color = Color(0xFFE50914)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -225 * pi / 180,
      270 * pi / 180,
      false,
      backgroundPaint,
    );
    
    final progress = (rpm / 10000).clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -225 * pi / 180,
      270 * pi / 180 * progress,
      false,
      progressPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BatterySOCWidget extends StatelessWidget {
  final double soc;
  
  const BatterySOCWidget({required this.soc});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomPaint(
        painter: SOCPainter(soc: soc),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.battery_charging_full,
                color: Color(0xFFE50914),
                size: 32,
              ),
              Text(
                '${soc.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Color(0xFFF2F2F2),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Batarya',
                style: TextStyle(color: Color(0xFFF2F2F2), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SOCPainter extends CustomPainter {
  final double soc;
  
  SOCPainter({required this.soc});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20;
    
    final backgroundPaint = Paint()
      ..color = Color(0xFF1A1A1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    
    final progressPaint = Paint()
      ..color = soc > 20 ? Color(0xFFE50914) : Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    final progress = (soc / 100).clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * pi / 180,
      360 * pi / 180 * progress,
      false,
      progressPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PowerBarWidget extends StatelessWidget {
  final double power;
  
  const PowerBarWidget({required this.power});
  
  @override
  Widget build(BuildContext context) {
    final normalizedPower = ((power + 200) / 600).clamp(0.0, 1.0);
    
    return Container(
      height: 180,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Güç',
            style: TextStyle(color: Color(0xFFF2F2F2), fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            '${power.toStringAsFixed(0)} kW',
            style: TextStyle(
              color: Color(0xFFE50914),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1C),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 30,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: MediaQuery.of(context).size.width * 0.35 * normalizedPower,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: power < 0
                            ? [Colors.green, Colors.lightGreen]
                            : [Color(0xFFE50914), Colors.orange],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TorqueBarWidget extends StatelessWidget {
  final double torque;
  
  const TorqueBarWidget({required this.torque});
  
  @override
  Widget build(BuildContext context) {
    final normalizedTorque = ((torque + 500) / 1500).clamp(0.0, 1.0);
    
    return Container(
      height: 100,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tork',
                style: TextStyle(color: Color(0xFFF2F2F2), fontSize: 16),
              ),
              Text(
                '${torque.toStringAsFixed(0)} Nm',
                style: TextStyle(
                  color: Color(0xFFE50914),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * normalizedTorque,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE50914), Colors.redAccent],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TemperatureWidget extends StatelessWidget {
  final String label;
  final double temperature;
  
  const TemperatureWidget({required this.label, required this.temperature});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: Color(0xFFF2F2F2), fontSize: 12),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.thermostat,
                color: temperature > 80 ? Colors.orange : Color(0xFFE50914),
                size: 20,
              ),
              SizedBox(width: 5),
              Text(
                '${temperature.toStringAsFixed(1)}°C',
                style: TextStyle(
                  color: temperature > 80 ? Colors.orange : Color(0xFFF2F2F2),
                  fontSize: 18,
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