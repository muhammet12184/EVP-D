import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../core/config/app_config.dart';

/// OBD-II Service - Gelişmiş SAE J1979 (Mode 01) PID Desteği
/// ICE (Benzinli/Dizel) araçlar için kapsamlı OBD-II iletişim servisi
class OBDService {
  static final OBDService _instance = OBDService._internal();
  factory OBDService() => _instance;
  OBDService._internal();

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _obdCharacteristic;
  bool _isConnected = false;
  
  final StreamController<OBDData> _dataController = 
      StreamController<OBDData>.broadcast();

  Stream<OBDData> get dataStream => _dataController.stream;
  bool get isConnected => _isConnected;

  // ===========================
  // BLUETOOTH BAĞLANTI YÖNETİMİ
  // ===========================

  /// OBD-II cihazlarını tara
  Stream<BluetoothDevice> scanForDevices() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    
    return FlutterBluePlus.scanResults.map((results) {
      return results
          .where((r) => r.device.name.contains('OBD') || 
                       r.device.name.contains('ELM327') ||
                       r.device.name.contains('OBDII'))
          .map((r) => r.device)
          .toList();
    }).expand((devices) => devices);
  }

  /// OBD-II cihazına bağlan
  Future<bool> connect(BluetoothDevice device) async {
    try {
      await device.connect();
      _connectedDevice = device;

      // Servisleri keşfet
      List<BluetoothService> services = await device.discoverServices();
      
      for (var service in services) {
        if (service.uuid.toString().contains(AppConfig.obdServiceUUID)) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().contains(AppConfig.obdCharacteristicUUID)) {
              _obdCharacteristic = characteristic;
              
              // Bildirimleri etkinleştir
              await characteristic.setNotifyValue(true);
              
              // Veri akışını dinle
              characteristic.value.listen((value) {
                _parseOBDResponse(value);
              });
              
              _isConnected = true;
              
              // OBD-II'yi başlat
              await _initializeOBD();
              
              return true;
            }
          }
        }
      }
      
      return false;
    } catch (e) {
      print('Bağlantı hatası: $e');
      return false;
    }
  }

  /// OBD-II bağlantısını kes
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
      _obdCharacteristic = null;
      _isConnected = false;
    }
  }

  /// OBD-II iletişimini başlat
  Future<void> _initializeOBD() async {
    if (_obdCharacteristic == null) return;

    // Cihazı sıfırla
    await _sendCommand('ATZ');
    await Future.delayed(const Duration(seconds: 1));

    // Echo'yu kapat
    await _sendCommand('ATE0');
    await Future.delayed(const Duration(milliseconds: 500));

    // Protokolü otomatik ayarla
    await _sendCommand('ATSP0');
    await Future.delayed(const Duration(milliseconds: 500));

    // Boşlukları kaldır (hızlı işlem için)
    await _sendCommand('ATS0');
    await Future.delayed(const Duration(milliseconds: 500));

    // Header'ları göster
    await _sendCommand('ATH1');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// OBD-II cihazına komut gönder
  Future<void> _sendCommand(String command) async {
    if (_obdCharacteristic == null) return;

    try {
      final data = utf8.encode('$command\r');
      await _obdCharacteristic!.write(data);
    } catch (e) {
      print('Komut gönderme hatası: $e');
    }
  }

  /// Belirli bir PID iste
  Future<void> requestPID(String pid) async {
    await _sendCommand('01$pid');
  }

  // ===========================
  // SÜREKLİ VERİ İZLEME
  // ===========================

  /// Tüm temel parametreleri sürekli izle
  void startMonitoring() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!_isConnected) {
        timer.cancel();
        return;
      }

      // Temel parametreleri sırayla iste
      await requestPID('0C'); // Motor devri
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('0D'); // Araç hızı
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('05'); // Motor soğutma sıvısı sıcaklığı
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('04'); // Hesaplanan motor yükü
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('0F'); // Emilen hava sıcaklığı
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('10'); // Kütlesel hava debisi (MAF)
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('11'); // Gaz kelebeği pozisyonu
      await Future.delayed(const Duration(milliseconds: 50));
    });
  }

  /// Gelişmiş parametreleri izle (turbo, yakıt, O2)
  void startAdvancedMonitoring() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!_isConnected) {
        timer.cancel();
        return;
      }

      // Gelişmiş parametreler
      await requestPID('0B'); // Manifold basıncı
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('0E'); // Ateşleme avansı
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('06'); // STFT Bank 1
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('08'); // LTFT Bank 1
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('14'); // O2 sensör Bank 1 Sensor 1
      await Future.delayed(const Duration(milliseconds: 50));
      
      await requestPID('42'); // ECU voltajı
      await Future.delayed(const Duration(milliseconds: 50));
    });
  }

  /// Turbo sistemini izle (turbo araçlar için)
  void startTurboMonitoring() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (!_isConnected) {
        timer.cancel();
        return;
      }

      await requestPID('70'); // Komutlanan turbo basıncı
      await Future.delayed(const Duration(milliseconds: 30));
      
      await requestPID('71'); // Gerçek turbo basıncı
      await Future.delayed(const Duration(milliseconds: 30));
      
      await requestPID('73'); // Turbo kompresör giriş basıncı
    });
  }

  // ===========================
  // SAE J1979 PID PARSE FONKSİYONLARI
  // ===========================

  /// Gelen OBD-II yanıtını parse et
  void _parseOBDResponse(List<int> rawData) {
    try {
      final response = utf8.decode(rawData).trim().replaceAll(' ', '');
      
      if (response.isEmpty || 
          response.contains('NODATA') || 
          response.contains('?') ||
          response.contains('ERROR')) {
        return;
      }

      // Yanıt formatı: 41 XX YY ZZ ... (Mode 01 yanıtı 41 ile başlar)
      if (!response.startsWith('41')) return;

      final obdData = OBDData();

      // PID'i tespit et (3. ve 4. karakter)
      final pidCode = response.substring(2, 4).toUpperCase();

      // İlgili PID parser'ını çağır
      switch (pidCode) {
        // ========== TEMEL MOTOR PARAMETRELERİ ==========
        case '0C':
          obdData.engineRpm = _parsePID_0C(response);
          break;
        case '0D':
          obdData.vehicleSpeed = _parsePID_0D(response);
          break;
        case '05':
          obdData.coolantTemp = _parsePID_05(response);
          break;
        case '04':
          obdData.engineLoad = _parsePID_04(response);
          break;
        case '0F':
          obdData.intakeAirTemp = _parsePID_0F(response);
          break;

        // ========== HAVA/YAKIT SİSTEMİ ==========
        case '10':
          obdData.mafAirFlow = _parsePID_10(response);
          break;
        case '0B':
          obdData.intakeManifoldPressure = _parsePID_0B(response);
          break;
        case '11':
          obdData.throttlePosition = _parsePID_11(response);
          break;

        // ========== YAKIT TRİMİ ==========
        case '06':
          obdData.shortTermFuelTrim1 = _parsePID_06(response);
          break;
        case '08':
          obdData.longTermFuelTrim1 = _parsePID_08(response);
          break;

        // ========== TURBO SİSTEMİ ==========
        case '70':
          obdData.turboBoostPressureCmd = _parsePID_70(response);
          break;
        case '71':
          obdData.turboBoostPressureActual = _parsePID_71(response);
          break;
        case '73':
          obdData.turboCompressorInletPressure = _parsePID_73(response);
          break;

        // ========== YAKIT BASINÇ ==========
        case '0A':
          obdData.fuelPressure = _parsePID_0A(response);
          break;
        case '22':
          obdData.fuelRailPressureManifold = _parsePID_22(response);
          break;
        case '23':
          obdData.fuelRailPressureDirect = _parsePID_23(response);
          break;

        // ========== ATEŞLEMEVİNCİ ==========
        case '0E':
          obdData.timingAdvance = _parsePID_0E(response);
          break;

        // ========== OKSİJEN SENSÖRÜ ==========
        case '14':
          final o2Data = _parsePID_14(response);
          obdData.o2SensorVoltage = o2Data['voltage'];
          obdData.o2SensorSTFT = o2Data['stft'];
          break;
        case '24':
          obdData.o2SensorLambda = _parsePID_24(response);
          break;

        // ========== SİSTEM DURUMU ==========
        case '03':
          obdData.fuelSystemStatus = _parsePID_03(response);
          break;
        case '01':
          final milData = _parsePID_01(response);
          obdData.milStatus = milData['mil'];
          obdData.dtcCount = milData['dtcCount'];
          break;
        case '1C':
          obdData.obdStandard = _parsePID_1C(response);
          break;

        // ========== ELEKTRİK ==========
        case '42':
          obdData.controlModuleVoltage = _parsePID_42(response);
          break;

        // ========== TORK ==========
        case '61':
          obdData.driverDemandTorque = _parsePID_61(response);
          break;
        case '62':
          obdData.actualEngineTorque = _parsePID_62(response);
          break;
        case '63':
          obdData.engineReferenceTorque = _parsePID_63(response);
          break;

        // ========== MUTLAK YÜK ==========
        case '43':
          obdData.absoluteLoadValue = _parsePID_43(response);
          break;
      }

      // Timestamp ekle
      obdData.timestamp = DateTime.now();

      // Stream'e gönder
      _dataController.add(obdData);

    } catch (e) {
      print('Parse hatası: $e');
    }
  }

  // ===========================
  // PID PARSER FONKSİYONLARI (SAE J1979)
  // ===========================

  /// PID 01 0C - Motor devri (Engine RPM)
  /// Formül: ((A*256)+B)/4
  /// Birim: rpm
  double _parsePID_0C(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return ((a * 256) + b) / 4.0;
  }

  /// PID 01 0D - Araç hızı
  /// Formül: A
  /// Birim: km/h
  int _parsePID_0D(String response) {
    return int.parse(response.substring(4, 6), radix: 16);
  }

  /// PID 01 10 - Kütlesel hava debisi (MAF)
  /// Formül: ((A*256)+B)/100
  /// Birim: g/s
  double _parsePID_10(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return ((a * 256) + b) / 100.0;
  }

  /// PID 01 0B - Manifold mutlak basıncı (MAP)
  /// Formül: A
  /// Birim: kPa
  int _parsePID_0B(String response) {
    return int.parse(response.substring(4, 6), radix: 16);
  }

  /// PID 01 05 - Motor soğutma sıvısı sıcaklığı (ECT)
  /// Formül: A - 40
  /// Birim: °C
  int _parsePID_05(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    return a - 40;
  }

  /// PID 01 0F - Emilen hava sıcaklığı (IAT)
  /// Formül: A - 40
  /// Birim: °C
  int _parsePID_0F(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    return a - 40;
  }

  /// PID 01 11 - Gaz kelebeği pozisyonu (TPS)
  /// Formül: (A*100)/255
  /// Birim: %
  double _parsePID_11(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    return (a * 100) / 255.0;
  }

  /// PID 01 06 - STFT Bank 1
  /// Formül: ((A-128)*100)/128
  /// Birim: %
  double _parsePID_06(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    return ((a - 128) * 100) / 128.0;
  }

  /// PID 01 08 - LTFT Bank 1
  /// Formül: ((A-128)*100)/128
  /// Birim: %
  double _parsePID_08(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    return ((a - 128) * 100) / 128.0;
  }

  /// PID 01 70 - Komutlanan turbo/boost basıncı
  /// Formül: ((A*256)+B)/10
  /// Birim: kPa
  double _parsePID_70(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return ((a * 256) + b) / 10.0;
  }

  /// PID 01 71 - Gerçek turbo/boost basıncı
  /// Formül: ((A*256)+B)/10
  /// Birim: kPa
  double _parsePID_71(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return ((a * 256) + b) / 10.0;
  }

  /// PID 01 73 - Turbo kompresör giriş basıncı
  /// Formül: ((A*256)+B)/10
  /// Birim: kPa
  double _parsePID_73(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return ((a * 256) + b) / 10.0;
  }

  /// PID 01 0A - Yakıt basıncı (regülatör öncesi)
  /// Formül: A*3
  /// Birim: kPa
  int _parsePID_0A(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    return a * 3;
  }

  /// PID 01 22 - Common rail basıncı (manifolta göre)
  /// Formül: ((A*256)+B)*0.079
  /// Birim: kPa
  double _parsePID_22(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return ((a * 256) + b) * 0.079;
  }

  /// PID 01 23 - Yakıt ray basıncı (gösterge/diesel)
  /// Formül: ((A*256)+B)*10
  /// Birim: kPa
  int _parsePID_23(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return ((a * 256) + b) * 10;
  }

  /// PID 01 0E - Ateşleme avansı
  /// Formül: (A/2) - 64
  /// Birim: °BTDC
  double _parsePID_0E(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    return (a / 2.0) - 64;
  }

  /// PID 01 14 - O2 sensör Bank 1 Sensor 1 (volt + STFT)
  /// Voltage = A*0.005, STFT = ((B-128)*100)/128
  /// Birim: V / %
  Map<String, double> _parsePID_14(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    
    return {
      'voltage': a * 0.005,
      'stft': ((b - 128) * 100) / 128.0,
    };
  }

  /// PID 01 24 - O2 sensör Bank 1 Sensor 1 eşdeğer oranı
  /// Formül: ((A*256)+B)/32768
  /// Birim: lambda (λ)
  double _parsePID_24(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return ((a * 256) + b) / 32768.0;
  }

  /// PID 01 03 - Yakıt sistemi durumu
  /// Bit-coded
  String _parsePID_03(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    
    // Basit interpretasyon
    if (a & 0x01 != 0) return 'Açık Döngü (Open Loop)';
    if (a & 0x02 != 0) return 'Kapalı Döngü (Closed Loop)';
    return 'Bilinmeyen';
  }

  /// PID 01 01 - Emisyon monitör durumu & MIL
  /// MIL bit, DTC sayısı ve monitör bayrakları
  Map<String, dynamic> _parsePID_01(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    
    return {
      'mil': (a & 0x80) != 0, // MIL (Check Engine) lambası
      'dtcCount': a & 0x7F,   // DTC sayısı
    };
  }

  /// PID 01 1C - Desteklenen OBD standardı
  /// Kodlu değer
  String _parsePID_1C(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    
    final standards = {
      0x01: 'OBD-II (CARB)',
      0x02: 'OBD (EPA)',
      0x03: 'OBD & OBD-II',
      0x04: 'OBD-I',
      0x05: 'NOT OBD',
      0x06: 'EOBD (Europe)',
      0x07: 'EOBD & OBD-II',
      0x0A: 'OBD-II (CARB)',
    };
    
    return standards[a] ?? 'Bilinmeyen Standard';
  }

  /// PID 01 42 - Alternatör/ECU besleme voltajı
  /// Formül: ((A*256)+B)/1000
  /// Birim: V
  double _parsePID_42(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return ((a * 256) + b) / 1000.0;
  }

  /// PID 01 61 - Sürücü istek motor torku (%)
  /// Formül: A - 125
  /// Birim: %
  int _parsePID_61(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    return a - 125;
  }

  /// PID 01 62 - Gerçek motor torku (%)
  /// Formül: A - 125
  /// Birim: %
  int _parsePID_62(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    return a - 125;
  }

  /// PID 01 63 - Motor referans torku
  /// Formül: (A*256)+B
  /// Birim: N·m
  int _parsePID_63(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return (a * 256) + b;
  }

  /// PID 01 04 - Hesaplanan motor yükü
  /// Formül: (A*100)/255
  /// Birim: %
  double _parsePID_04(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    return (a * 100) / 255.0;
  }

  /// PID 01 43 - Mutlak yük değeri
  /// Formül: ((A*256)+B)*100/255
  /// Birim: %
  double _parsePID_43(String response) {
    final a = int.parse(response.substring(4, 6), radix: 16);
    final b = int.parse(response.substring(6, 8), radix: 16);
    return ((a * 256) + b) * 100 / 255.0;
  }

  // ===========================
  // DTC (ARİZA KODU) YÖNETİMİ
  // ===========================

  /// Depolanmış arıza kodlarını oku (Mode 03)
  Future<List<String>> readDTCs() async {
    await _sendCommand('03');
    await Future.delayed(const Duration(seconds: 1));
    
    // Gerçek implementasyonda burada cevap parse edilir
    // Şimdilik boş liste dön
    return [];
  }

  /// Onaylanmış arıza kodlarını oku (Mode 07)
  Future<List<String>> readPendingDTCs() async {
    await _sendCommand('07');
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  /// Arıza kodlarını temizle (Mode 04)
  Future<void> clearDTCs() async {
    await _sendCommand('04');
  }

  /// Arıza kodunu Türkçe yorumla
  String interpretDTC(String dtcCode) {
    final Map<String, String> dtcDescriptions = {
      // Motor Ateşleme Sistemi
      'P0300': 'Rastgele ateşleme hatası tespit edildi',
      'P0301': 'Silindir 1 ateşleme hatası',
      'P0302': 'Silindir 2 ateşleme hatası',
      'P0303': 'Silindir 3 ateşleme hatası',
      'P0304': 'Silindir 4 ateşleme hatası',
      
      // Yakıt Sistemi
      'P0171': 'Yakıt karışımı çok zayıf (Bank 1)',
      'P0172': 'Yakıt karışımı çok zengin (Bank 1)',
      'P0174': 'Yakıt karışımı çok zayıf (Bank 2)',
      'P0175': 'Yakıt karışımı çok zengin (Bank 2)',
      
      // Emisyon Sistemi
      'P0420': 'Katalitik konvertör verimliliği düşük (Bank 1)',
      'P0430': 'Katalitik konvertör verimliliği düşük (Bank 2)',
      'P0401': 'EGR akışı yetersiz',
      'P0402': 'EGR akışı fazla',
      
      // Soğutma Sistemi
      'P0128': 'Motor soğutma suyu sıcaklığı çok düşük',
      'P0116': 'Motor soğutma suyu sıcaklık sensörü aralık/performans',
      
      // Yakıt Buharlaşma Sistemi
      'P0442': 'Yakıt buharlaşma sistemi küçük kaçak',
      'P0455': 'Yakıt buharlaşma sistemi büyük kaçak',
      'P0456': 'Yakıt buharlaşma sistemi çok küçük kaçak',
      
      // Oksijen Sensörleri
      'P0135': 'Oksijen sensörü ısıtıcı devresi arızası (Bank 1, Sensor 1)',
      'P0141': 'Oksijen sensörü ısıtıcı devresi arızası (Bank 1, Sensor 2)',
      'P0136': 'Oksijen sensörü devresi arızası (Bank 1, Sensor 2)',
      
      // Hava/Yakıt Sistemi
      'P0100': 'Kütlesel hava debisi (MAF) devre arızası',
      'P0110': 'Emme hava sıcaklığı devre arızası',
      'P0120': 'Gaz kelebeği pozisyon sensörü devre arızası',
      
      // Ateşleme Sistemi
      'P0351': 'Ateşleme bobini A birincil/sekonder devre arızası',
      'P0352': 'Ateşleme bobini B birincil/sekonder devre arızası',
    };

    return dtcDescriptions[dtcCode] ?? 'Bilinmeyen arıza kodu: $dtcCode';
  }

  /// AI destekli tamir önerisi (Türkçe)
  String getAIRepairSuggestion(String dtcCode) {
    final Map<String, String> suggestions = {
      'P0300': '🔧 Korkmayın! Bu genellikle bujilerin yaşlanmasından kaynaklanır.\n'
               '✅ ÇÖzüm: Buji değişimi\n'
               '💰 Tahmini maliyet: 500-1000 TL\n'
               '⏱️ Süre: 30-60 dakika',
               
      'P0301': '🔧 1. silindirde ateşleme sorunu var.\n'
               '✅ Çözüm: İlgili silindir bujisi, ateşleme bobini veya enjektörü kontrol edin.\n'
               '💰 Maliyet: 300-800 TL\n'
               '⚠️ Aciliyet: Orta',
               
      'P0171': '🔧 Hava/yakıt dengesi bozulmuş (Zayıf karışım).\n'
               '✅ Çözüm: Hava filtresi, yakıt pompası veya oksijen sensörü kontrol edilmeli.\n'
               '💰 Maliyet: 300-1200 TL\n'
               '⚠️ Ertelemeyin, yakıt tüketimi artar!',
               
      'P0420': '🔧 Katalitik konvertör verimliliği düşmüş.\n'
               '✅ Çözüm: İlk önce oksijen sensörlerini kontrol edin, gerekirse katalizör değişimi.\n'
               '💰 Maliyet: 2000-6000 TL (katalizör dahil)\n'
               '⚠️ Emisyon testinde sorun çıkarır!',
               
      'P0401': '🔧 EGR (Egzoz Gazı Resirkülasyonu) valfı kirlenmiş.\n'
               '✅ Çözüm: EGR valfı temizliği veya değişimi.\n'
               '💰 Maliyet: 400-1000 TL\n'
               '⏱️ Basit bir işlem.',
               
      'P0442': '🔧 Yakıt buharlaşma sisteminde küçük kaçak var.\n'
               '✅ Çözüm: Yakıt deposu kapağı, hortumlar veya valf kontrol edilmeli.\n'
               '💰 Maliyet: 200-600 TL\n'
               '💡 İlk önce yakıt kapağını kontrol edin!',
               
      'P0128': '🔧 Motor yeterince ısınmıyor.\n'
               '✅ Çözüm: Termostat değişimi gerekebilir.\n'
               '💰 Maliyet: 300-700 TL\n'
               '⚠️ Yakıt tüketimi ve emisyon artar.',
    };

    return suggestions[dtcCode] ?? 
           '📋 Bu kod için detaylı bilgi bulunmuyor.\n'
           '🔍 Bir serviste kontrol ettirmenizi öneririm.\n'
           '📞 Yetkili servis: En doğru teşhis için profesyonel yardım alın.';
  }

  // ===========================
  // YARDIMCI FONKSİYONLAR
  // ===========================

  /// Veri akışını temizle
  void dispose() {
    disconnect();
    _dataController.close();
  }
}

// ===========================
// OBD VERİ MODELİ
// ===========================

/// OBD-II'den gelen tüm parametreleri tutan model
class OBDData {
  // Temel Motor Parametreleri
  double? engineRpm;              // Motor devri (rpm)
  int? vehicleSpeed;              // Araç hızı (km/h)
  int? coolantTemp;               // Soğutma sıvısı sıcaklığı (°C)
  double? engineLoad;             // Motor yükü (%)
  int? intakeAirTemp;             // Emilen hava sıcaklığı (°C)
  
  // Hava/Yakıt Sistemi
  double? mafAirFlow;             // Kütlesel hava debisi (g/s)
  int? intakeManifoldPressure;    // Manifold basıncı (kPa)
  double? throttlePosition;       // Gaz kelebeği pozisyonu (%)
  
  // Yakıt Trimi
  double? shortTermFuelTrim1;     // STFT Bank 1 (%)
  double? longTermFuelTrim1;      // LTFT Bank 1 (%)
  
  // Turbo Sistemi
  double? turboBoostPressureCmd;  // Komutlanan turbo basıncı (kPa)
  double? turboBoostPressureActual; // Gerçek turbo basıncı (kPa)
  double? turboCompressorInletPressure; // Kompresör giriş basıncı (kPa)
  
  // Yakıt Basınç
  int? fuelPressure;              // Yakıt basıncı (kPa)
  double? fuelRailPressureManifold; // Common rail basıncı (kPa)
  int? fuelRailPressureDirect;    // Direkt yakıt ray basıncı (kPa)
  
  // Ateşleme
  double? timingAdvance;          // Ateşleme avansı (°BTDC)
  
  // Oksijen Sensörü
  double? o2SensorVoltage;        // O2 sensör voltajı (V)
  double? o2SensorSTFT;           // O2 sensör STFT (%)
  double? o2SensorLambda;         // Lambda değeri (λ)
  
  // Sistem Durumu
  String? fuelSystemStatus;       // Yakıt sistemi durumu
  bool? milStatus;                // MIL (Check Engine) lambası
  int? dtcCount;                  // DTC sayısı
  String? obdStandard;            // OBD standardı
  
  // Elektrik
  double? controlModuleVoltage;   // ECU voltajı (V)
  
  // Tork
  int? driverDemandTorque;        // Sürücü istek torku (%)
  int? actualEngineTorque;        // Gerçek motor torku (%)
  int? engineReferenceTorque;     // Referans tork (N·m)
  
  // Mutlak Yük
  double? absoluteLoadValue;      // Mutlak yük değeri (%)
  
  // Timestamp
  DateTime? timestamp;

  OBDData();

  @override
  String toString() {
    return '''
OBD Data @ $timestamp
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏎️  Motor Devri: ${engineRpm?.toStringAsFixed(0) ?? 'N/A'} rpm
📊 Motor Yükü: ${engineLoad?.toStringAsFixed(1) ?? 'N/A'} %
🚗 Hız: ${vehicleSpeed ?? 'N/A'} km/h
🌡️  Soğutucu: ${coolantTemp ?? 'N/A'} °C
💨 Gaz Kelebeği: ${throttlePosition?.toStringAsFixed(1) ?? 'N/A'} %
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ''';
  }
}
