import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(OBDUygulamasi());
}

class OBDUygulamasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBD-II Pro',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF1A1A1C),
        cardColor: Color(0xFF232326),
        primaryColor: Color(0xFFE50914),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFF2F2F2)),
          bodyMedium: TextStyle(color: Color(0xFFF2F2F2)),
          bodySmall: TextStyle(color: Color(0xFFF2F2F2)),
        ),
      ),
      home: AnaSayfa(),
    );
  }
}

enum BaglantiDurumu {
  baglantiYok,
  baglanıyor,
  baglandi,
  veriAliniyor,
}

class BLEYonetici {
  BluetoothDevice? baglıCihaz;
  BluetoothCharacteristic? rxCharacteristic;
  BluetoothCharacteristic? txCharacteristic;
  StreamController<BaglantiDurumu> durumController = StreamController<BaglantiDurumu>.broadcast();
  StreamController<String> veriController = StreamController<String>.broadcast();
  
  final String servisUUID = "0000fff0-0000-1000-8000-00805f9b34fb";
  final String rxUUID = "0000fff1-0000-1000-8000-00805f9b34fb";
  final String txUUID = "0000fff2-0000-1000-8000-00805f9b34fb";
  
  bool otomatikBaglan = true;
  Timer? yenidenBaglanmaTimer;
  String? sonCihazId;

  void taramayiBaslat(Function(List<ScanResult>) onSonuc) async {
    durumController.add(BaglantiDurumu.baglantiYok);
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
    FlutterBluePlus.scanResults.listen((results) {
      onSonuc(results);
    });
  }

  void taramayiDurdur() async {
    await FlutterBluePlus.stopScan();
  }

  Future<bool> cihazaBaglan(BluetoothDevice cihaz) async {
    try {
      durumController.add(BaglantiDurumu.baglanıyor);
      await cihaz.connect(timeout: Duration(seconds: 15));
      baglıCihaz = cihaz;
      sonCihazId = cihaz.id.toString();
      
      await Future.delayed(Duration(milliseconds: 500));
      
      List<BluetoothService> servisler = await cihaz.discoverServices();
      
      for (var servis in servisler) {
        for (var characteristic in servis.characteristics) {
          if (characteristic.uuid.toString().toLowerCase().contains("fff1") || 
              characteristic.properties.write) {
            txCharacteristic = characteristic;
          }
          if (characteristic.uuid.toString().toLowerCase().contains("fff2") || 
              characteristic.properties.notify) {
            rxCharacteristic = characteristic;
            await characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              if (value.isNotEmpty) {
                String veri = String.fromCharCodes(value);
                veriController.add(veri);
              }
            });
          }
        }
      }
      
      if (txCharacteristic != null && rxCharacteristic != null) {
        await cihaz.requestMtu(512);
        durumController.add(BaglantiDurumu.baglandi);
        baglantiyiIzle();
        return true;
      }
      return false;
    } catch (e) {
      durumController.add(BaglantiDurumu.baglantiYok);
      return false;
    }
  }

  void baglantiyiIzle() {
    baglıCihaz?.state.listen((durum) {
      if (durum == BluetoothDeviceState.disconnected) {
        durumController.add(BaglantiDurumu.baglantiYok);
        if (otomatikBaglan && sonCihazId != null) {
          yenidenBaglan();
        }
      }
    });
  }

  void yenidenBaglan() {
    yenidenBaglanmaTimer?.cancel();
    yenidenBaglanmaTimer = Timer(Duration(seconds: 3), () async {
      if (baglıCihaz != null) {
        await cihazaBaglan(baglıCihaz!);
      }
    });
  }

  Future<void> veriGonder(String komut) async {
    if (txCharacteristic != null && baglıCihaz != null) {
      try {
        String tam = komut.trim() + '\r';
        await txCharacteristic!.write(tam.codeUnits, withoutResponse: false);
      } catch (e) {
        durumController.add(BaglantiDurumu.baglantiYok);
      }
    }
  }

  void baglantiyiKes() async {
    otomatikBaglan = false;
    yenidenBaglanmaTimer?.cancel();
    if (baglıCihaz != null) {
      await baglıCihaz!.disconnect();
      baglıCihaz = null;
      rxCharacteristic = null;
      txCharacteristic = null;
    }
    durumController.add(BaglantiDurumu.baglantiYok);
  }

  void dispose() {
    yenidenBaglanmaTimer?.cancel();
    durumController.close();
    veriController.close();
  }
}

class OBDParser {
  static String temizle(String ham) {
    return ham.replaceAll(' ', '').replaceAll('>', '').replaceAll('\r', '').replaceAll('\n', '').trim();
  }

  static double? hexToInt(String hex) {
    try {
      return int.parse(hex, radix: 16).toDouble();
    } catch (e) {
      return null;
    }
  }

  static double? pidDegerAl(String yanit, double Function(List<int>) formula) {
    try {
      String temiz = temizle(yanit);
      if (temiz.length < 4) return null;
      
      List<int> bytes = [];
      for (int i = 0; i < temiz.length; i += 2) {
        if (i + 1 < temiz.length) {
          bytes.add(int.parse(temiz.substring(i, i + 2), radix: 16));
        }
      }
      
      if (bytes.length < 2) return null;
      return formula(bytes);
    } catch (e) {
      return null;
    }
  }

  static List<String> dtcCoz(String yanit) {
    List<String> dtcler = [];
    try {
      String temiz = temizle(yanit);
      if (temiz.length < 4) return dtcler;
      
      for (int i = 0; i < temiz.length; i += 4) {
        if (i + 3 < temiz.length) {
          String dtcHex = temiz.substring(i, i + 4);
          int val = int.parse(dtcHex, radix: 16);
          if (val == 0) continue;
          
          int first = (val >> 14) & 0x03;
          int second = (val >> 12) & 0x03;
          int third = (val >> 8) & 0x0F;
          int fourth = val & 0xFF;
          
          String prefix = ['P', 'C', 'B', 'U'][first];
          dtcler.add('$prefix$second$third${fourth.toRadixString(16).padLeft(2, '0').toUpperCase()}');
        }
      }
    } catch (e) {}
    return dtcler;
  }
}

class OBDServis {
  BLEYonetici bleYonetici;
  bool baslatildi = false;
  Map<String, Completer<String>> bekleyenYanitlar = {};
  Timer? timeoutTimer;

  OBDServis(this.bleYonetici) {
    bleYonetici.veriController.stream.listen((veri) {
      bekleyenYanitlar.forEach((komut, completer) {
        if (!completer.isCompleted) {
          completer.complete(veri);
        }
      });
      bekleyenYanitlar.clear();
    });
  }

  Future<bool> elm327Baslat() async {
    try {
      await komutGonder('ATZ');
      await Future.delayed(Duration(milliseconds: 1500));
      await komutGonder('ATE0');
      await Future.delayed(Duration(milliseconds: 300));
      await komutGonder('ATL0');
      await Future.delayed(Duration(milliseconds: 300));
      await komutGonder('ATH1');
      await Future.delayed(Duration(milliseconds: 300));
      await komutGonder('ATS0');
      await Future.delayed(Duration(milliseconds: 300));
      await komutGonder('ATSP0');
      await Future.delayed(Duration(milliseconds: 300));
      baslatildi = true;
      bleYonetici.durumController.add(BaglantiDurumu.veriAliniyor);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> komutGonder(String komut, {int denemeSayisi = 3}) async {
    for (int i = 0; i < denemeSayisi; i++) {
      try {
        Completer<String> completer = Completer<String>();
        bekleyenYanitlar[komut] = completer;
        
        await bleYonetici.veriGonder(komut);
        
        String yanit = await completer.future.timeout(
          Duration(seconds: 2),
          onTimeout: () => 'TIMEOUT',
        );
        
        if (yanit != 'TIMEOUT' && !yanit.contains('ERROR')) {
          return yanit;
        }
      } catch (e) {}
      await Future.delayed(Duration(milliseconds: 300));
    }
    return 'ERROR';
  }

  Future<double?> pidOku(String pid, double Function(List<int>) formula) async {
    if (!baslatildi) return null;
    String yanit = await komutGonder(pid);
    if (yanit == 'ERROR' || yanit == 'TIMEOUT') return null;
    return OBDParser.pidDegerAl(yanit, formula);
  }

  Future<List<String>> dtcOku() async {
    if (!baslatildi) return [];
    String yanit = await komutGonder('03');
    return OBDParser.dtcCoz(yanit);
  }

  Future<bool> dtcTemizle() async {
    if (!baslatildi) return false;
    String yanit = await komutGonder('04');
    return !yanit.contains('ERROR');
  }
}

class PIDTanim {
  final String pid;
  final String aciklama;
  final String birim;
  final double Function(List<int>) formula;

  PIDTanim({
    required this.pid,
    required this.aciklama,
    required this.birim,
    required this.formula,
  });
}

class ICEPIDler {
  static final PIDTanim rpm = PIDTanim(
    pid: '010C',
    aciklama: 'Motor Devri',
    birim: 'rpm',
    formula: (bytes) => ((bytes[2] * 256 + bytes[3]) / 4),
  );

  static final PIDTanim hiz = PIDTanim(
    pid: '010D',
    aciklama: 'Araç Hızı',
    birim: 'km/h',
    formula: (bytes) => bytes[2].toDouble(),
  );

  static final PIDTanim suSicakligi = PIDTanim(
    pid: '0105',
    aciklama: 'Motor Soğutma Suyu Sıcaklığı',
    birim: '°C',
    formula: (bytes) => bytes[2] - 40.0,
  );

  static final PIDTanim maf = PIDTanim(
    pid: '0110',
    aciklama: 'Hava Akış Miktarı',
    birim: 'g/s',
    formula: (bytes) => ((bytes[2] * 256 + bytes[3]) / 100),
  );

  static final PIDTanim gazKelebegi = PIDTanim(
    pid: '0111',
    aciklama: 'Gaz Kelebeği Açıklığı',
    birim: '%',
    formula: (bytes) => (bytes[2] * 100 / 255),
  );

  static final PIDTanim yakitBasinci = PIDTanim(
    pid: '010A',
    aciklama: 'Yakıt Basıncı',
    birim: 'kPa',
    formula: (bytes) => bytes[2] * 3.0,
  );

  static final PIDTanim kisaTrim1 = PIDTanim(
    pid: '0106',
    aciklama: 'Kısa Yakıt Trim Bank 1',
    birim: '%',
    formula: (bytes) => (bytes[2] - 128) * 100 / 128,
  );

  static final PIDTanim uzunTrim1 = PIDTanim(
    pid: '0107',
    aciklama: 'Uzun Yakıt Trim Bank 1',
    birim: '%',
    formula: (bytes) => (bytes[2] - 128) * 100 / 128,
  );

  static final PIDTanim ateslemeAvansi = PIDTanim(
    pid: '010E',
    aciklama: 'Ateşleme Avansı',
    birim: '°',
    formula: (bytes) => (bytes[2] / 2) - 64,
  );

  static List<PIDTanim> tumPIDler() {
    return [
      rpm,
      hiz,
      suSicakligi,
      maf,
      gazKelebegi,
      yakitBasinci,
      kisaTrim1,
      uzunTrim1,
      ateslemeAvansi,
    ];
  }
}

class EVPIDler {
  static final PIDTanim soc = PIDTanim(
    pid: '01DB',
    aciklama: 'Batarya Şarj Durumu',
    birim: '%',
    formula: (bytes) => bytes[2].toDouble(),
  );

  static final PIDTanim soh = PIDTanim(
    pid: '01DC',
    aciklama: 'Batarya Sağlık Durumu',
    birim: '%',
    formula: (bytes) => bytes[2].toDouble(),
  );

  static final PIDTanim hucreminVoltaj = PIDTanim(
    pid: '01DD',
    aciklama: 'Minimum Hücre Voltajı',
    birim: 'V',
    formula: (bytes) => ((bytes[2] * 256 + bytes[3]) / 1000),
  );

  static final PIDTanim hucremaxVoltaj = PIDTanim(
    pid: '01DE',
    aciklama: 'Maksimum Hücre Voltajı',
    birim: 'V',
    formula: (bytes) => ((bytes[2] * 256 + bytes[3]) / 1000),
  );

  static final PIDTanim hucreDelta = PIDTanim(
    pid: '01DF',
    aciklama: 'Hücre Voltaj Farkı',
    birim: 'mV',
    formula: (bytes) => ((bytes[2] * 256 + bytes[3])).toDouble(),
  );

  static final PIDTanim bataryaSicakligi = PIDTanim(
    pid: '01E0',
    aciklama: 'Batarya Sıcaklığı',
    birim: '°C',
    formula: (bytes) => bytes[2] - 40.0,
  );

  static final PIDTanim inverterSicakligi = PIDTanim(
    pid: '01E1',
    aciklama: 'İnverter Sıcaklığı',
    birim: '°C',
    formula: (bytes) => bytes[2] - 40.0,
  );

  static final PIDTanim motorSicakligi = PIDTanim(
    pid: '01E2',
    aciklama: 'Motor Sıcaklığı',
    birim: '°C',
    formula: (bytes) => bytes[2] - 40.0,
  );

  static final PIDTanim sarjGucu = PIDTanim(
    pid: '01E3',
    aciklama: 'Şarj Gücü',
    birim: 'kW',
    formula: (bytes) => ((bytes[2] * 256 + bytes[3]) / 100),
  );

  static final PIDTanim rejenGucu = PIDTanim(
    pid: '01E4',
    aciklama: 'Rejeneratif Güç',
    birim: 'kW',
    formula: (bytes) => ((bytes[2] * 256 + bytes[3]) / 100),
  );

  static final PIDTanim nominalVoltaj = PIDTanim(
    pid: '01E5',
    aciklama: 'Nominal Toplam Voltaj',
    birim: 'V',
    formula: (bytes) => ((bytes[2] * 256 + bytes[3]) / 10),
  );

  static final PIDTanim nominalAkim = PIDTanim(
    pid: '01E6',
    aciklama: 'Nominal Toplam Akım',
    birim: 'A',
    formula: (bytes) => ((bytes[2] * 256 + bytes[3]) / 10) - 500,
  );

  static List<PIDTanim> tumPIDler() {
    return [
      soc,
      soh,
      hucreminVoltaj,
      hucremaxVoltaj,
      hucreDelta,
      bataryaSicakligi,
      inverterSicakligi,
      motorSicakligi,
      sarjGucu,
      rejenGucu,
      nominalVoltaj,
      nominalAkim,
    ];
  }
}

class DijitalHizGostergesi extends StatelessWidget {
  final double hiz;

  DijitalHizGostergesi({required this.hiz});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFFE50914), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hiz.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE50914),
            ),
          ),
          Text(
            'KM/H',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFF2F2F2),
            ),
          ),
        ],
      ),
    );
  }
}

class AnalogRPMGostergesi extends StatelessWidget {
  final double rpm;
  final double maxRpm = 10000;

  AnalogRPMGostergesi({required this.rpm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: RPMPainter(rpm: rpm, maxRpm: maxRpm),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rpm.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              Text(
                'RPM',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFF2F2F2),
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
  final double maxRpm;

  RPMPainter({required this.rpm, required this.maxRpm});

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = min(centerX, centerY) - 10;

    Paint arcPaint = Paint()
      ..color = Color(0xFF232326)
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -pi * 0.75,
      pi * 1.5,
      false,
      arcPaint,
    );

    Paint progressPaint = Paint()
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double progress = (rpm / maxRpm).clamp(0.0, 1.0);
    double sweepAngle = progress * pi * 1.5;

    if (progress < 0.7) {
      progressPaint.color = Color(0xFF00FF00);
    } else if (progress < 0.85) {
      progressPaint.color = Color(0xFFFFFF00);
    } else {
      progressPaint.color = Color(0xFFE50914);
    }

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -pi * 0.75,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BataryaSOCGostergesi extends StatelessWidget {
  final double soc;

  BataryaSOCGostergesi({required this.soc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: CustomPaint(
        painter: SOCPainter(soc: soc),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${soc.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              Text(
                'ŞARJ',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFF2F2F2),
                ),
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
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = min(centerX, centerY) - 8;

    Paint bgPaint = Paint()
      ..color = Color(0xFF232326)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(centerX, centerY), radius, bgPaint);

    Paint progressPaint = Paint()
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double progress = (soc / 100).clamp(0.0, 1.0);

    if (progress < 0.2) {
      progressPaint.color = Color(0xFFE50914);
    } else if (progress < 0.5) {
      progressPaint.color = Color(0xFFFFFF00);
    } else {
      progressPaint.color = Color(0xFF00FF00);
    }

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -pi / 2,
      progress * 2 * pi,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GucBari extends StatelessWidget {
  final double guc;
  final double maxGuc;
  final String baslik;

  GucBari({required this.guc, required this.maxGuc, required this.baslik});

  @override
  Widget build(BuildContext context) {
    double progress = (guc / maxGuc).clamp(0.0, 1.0);
    
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                baslik,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              Text(
                '${guc.toStringAsFixed(1)} kW',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE50914),
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
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE50914),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TorkBari extends StatelessWidget {
  final double tork;
  final double maxTork;

  TorkBari({required this.tork, required this.maxTork});

  @override
  Widget build(BuildContext context) {
    double progress = (tork / maxTork).clamp(0.0, 1.0);
    
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TORK',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFF2F2F2),
                ),
              ),
              Text(
                '${tork.toStringAsFixed(0)} Nm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE50914),
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
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE50914), Color(0xFFFF6B6B)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SicaklikGostergesi extends StatelessWidget {
  final double sicaklik;
  final String baslik;
  final IconData icon;

  SicaklikGostergesi({
    required this.sicaklik,
    required this.baslik,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color renk = Color(0xFF00FF00);
    if (sicaklik > 80) {
      renk = Color(0xFFE50914);
    } else if (sicaklik > 60) {
      renk = Color(0xFFFFFF00);
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: renk, size: 30),
          SizedBox(height: 8),
          Text(
            baslik,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFFF2F2F2),
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${sicaklik.toStringAsFixed(0)}°C',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: renk,
            ),
          ),
        ],
      ),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  BLEYonetici bleYonetici = BLEYonetici();
  OBDServis? obdServis;
  BaglantiDurumu baglantiDurumu = BaglantiDurumu.baglantiYok;
  
  bool evMod = false;
  
  double hiz = 0;
  double rpm = 0;
  double soc = 0;
  double guc = 0;
  double tork = 0;
  double bataryaSicakligi = 0;
  double motorSicakligi = 0;
  
  Timer? veriOkumaTimer;
  List<String> dtcListesi = [];

  @override
  void initState() {
    super.initState();
    obdServis = OBDServis(bleYonetici);
    bleYonetici.durumController.stream.listen((durum) {
      setState(() {
        baglantiDurumu = durum;
      });
      if (durum == BaglantiDurumu.baglandi) {
        elm327Basla();
      }
    });
  }

  void elm327Basla() async {
    bool basarili = await obdServis!.elm327Baslat();
    if (basarili) {
      veriOkumayaBasla();
    }
  }

  void veriOkumayaBasla() {
    veriOkumaTimer?.cancel();
    veriOkumaTimer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (evMod) {
        double? yeniHiz = await obdServis!.pidOku(ICEPIDler.hiz.pid, ICEPIDler.hiz.formula);
        double? yeniSOC = await obdServis!.pidOku(EVPIDler.soc.pid, EVPIDler.soc.formula);
        double? yeniGuc = await obdServis!.pidOku(EVPIDler.sarjGucu.pid, EVPIDler.sarjGucu.formula);
        double? yeniBatSic = await obdServis!.pidOku(EVPIDler.bataryaSicakligi.pid, EVPIDler.bataryaSicakligi.formula);
        double? yeniMotSic = await obdServis!.pidOku(EVPIDler.motorSicakligi.pid, EVPIDler.motorSicakligi.formula);
        
        setState(() {
          if (yeniHiz != null) hiz = yeniHiz;
          if (yeniSOC != null) soc = yeniSOC;
          if (yeniGuc != null) guc = yeniGuc;
          if (yeniBatSic != null) bataryaSicakligi = yeniBatSic;
          if (yeniMotSic != null) motorSicakligi = yeniMotSic;
          rpm = 0;
          tork = guc * 9549.3 / (rpm > 0 ? rpm : 1);
        });
      } else {
        double? yeniHiz = await obdServis!.pidOku(ICEPIDler.hiz.pid, ICEPIDler.hiz.formula);
        double? yeniRPM = await obdServis!.pidOku(ICEPIDler.rpm.pid, ICEPIDler.rpm.formula);
        double? yeniSic = await obdServis!.pidOku(ICEPIDler.suSicakligi.pid, ICEPIDler.suSicakligi.formula);
        
        setState(() {
          if (yeniHiz != null) hiz = yeniHiz;
          if (yeniRPM != null) rpm = yeniRPM;
          if (yeniSic != null) motorSicakligi = yeniSic;
          soc = 0;
          guc = (rpm * tork) / 9549.3;
        });
      }
    });
  }

  void dtcOku() async {
    List<String> dtcler = await obdServis!.dtcOku();
    setState(() {
      dtcListesi = dtcler;
    });
  }

  void dtcTemizle() async {
    bool basarili = await obdServis!.dtcTemizle();
    if (basarili) {
      setState(() {
        dtcListesi.clear();
      });
    }
  }

  @override
  void dispose() {
    veriOkumaTimer?.cancel();
    bleYonetici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OBD-II Pro', style: TextStyle(color: Color(0xFFF2F2F2))),
        backgroundColor: Color(0xFF232326),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth, color: Color(0xFFE50914)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BLESayfa(bleYonetici: bleYonetici)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.warning, color: Color(0xFFE50914)),
            onPressed: () {
              dtcOku();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Color(0xFF232326),
                  title: Text('Arıza Kodları', style: TextStyle(color: Color(0xFFF2F2F2))),
                  content: dtcListesi.isEmpty
                      ? Text('Arıza bulunamadı', style: TextStyle(color: Color(0xFFF2F2F2)))
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: dtcListesi.map((dtc) => Text(dtc, style: TextStyle(color: Color(0xFFE50914)))).toList(),
                        ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        dtcTemizle();
                        Navigator.pop(context);
                      },
                      child: Text('Temizle', style: TextStyle(color: Color(0xFFE50914))),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Kapat', style: TextStyle(color: Color(0xFFF2F2F2))),
                    ),
                  ],
                ),
              );
            },
          ),
          Switch(
            value: evMod,
            onChanged: (val) {
              setState(() {
                evMod = val;
              });
            },
            activeColor: Color(0xFFE50914),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: baglantiDurumu == BaglantiDurumu.veriAliniyor ? Color(0xFF00FF00) : Color(0xFFE50914),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                baglantiDurumu == BaglantiDurumu.baglantiYok ? 'Bağlantı Yok' :
                baglantiDurumu == BaglantiDurumu.baglanıyor ? 'Bağlanıyor...' :
                baglantiDurumu == BaglantiDurumu.baglandi ? 'Bağlandı' : 'Veri Alınıyor',
                style: TextStyle(color: Color(0xFF1A1A1C), fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            DijitalHizGostergesi(hiz: hiz),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!evMod) AnalogRPMGostergesi(rpm: rpm),
                if (evMod) BataryaSOCGostergesi(soc: soc),
              ],
            ),
            SizedBox(height: 20),
            GucBari(guc: guc, maxGuc: 300, baslik: 'GÜÇ'),
            SizedBox(height: 15),
            TorkBari(tork: tork, maxTork: 500),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SicaklikGostergesi(
                    sicaklik: evMod ? bataryaSicakligi : motorSicakligi,
                    baslik: evMod ? 'BATARYA' : 'MOTOR',
                    icon: evMod ? Icons.battery_charging_full : Icons.thermostat,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SicaklikGostergesi(
                    sicaklik: motorSicakligi,
                    baslik: evMod ? 'MOTOR' : 'SOĞUTMA',
                    icon: Icons.ac_unit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BLESayfa extends StatefulWidget {
  final BLEYonetici bleYonetici;

  BLESayfa({required this.bleYonetici});

  @override
  _BLESayfaState createState() => _BLESayfaState();
}

class _BLESayfaState extends State<BLESayfa> {
  List<ScanResult> cihazlar = [];
  bool taraniyor = false;

  @override
  void initState() {
    super.initState();
    taramaBaslat();
  }

  void taramaBaslat() {
    setState(() {
      taraniyor = true;
    });
    widget.bleYonetici.taramayiBaslat((sonuclar) {
      setState(() {
        cihazlar = sonuclar;
      });
    });
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        taraniyor = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Cihazlar', style: TextStyle(color: Color(0xFFF2F2F2))),
        backgroundColor: Color(0xFF232326),
        actions: [
          IconButton(
            icon: Icon(taraniyor ? Icons.stop : Icons.refresh, color: Color(0xFFE50914)),
            onPressed: () {
              if (taraniyor) {
                widget.bleYonetici.taramayiDurdur();
                setState(() {
                  taraniyor = false;
                });
              } else {
                taramaBaslat();
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cihazlar.length,
        itemBuilder: (context, index) {
          ScanResult sonuc = cihazlar[index];
          return ListTile(
            tileColor: Color(0xFF232326),
            title: Text(
              sonuc.device.name.isEmpty ? 'Bilinmeyen Cihaz' : sonuc.device.name,
              style: TextStyle(color: Color(0xFFF2F2F2)),
            ),
            subtitle: Text(
              sonuc.device.id.toString(),
              style: TextStyle(color: Color(0xFFF2F2F2).withOpacity(0.7)),
            ),
            trailing: Icon(Icons.bluetooth, color: Color(0xFFE50914)),
            onTap: () async {
              bool basarili = await widget.bleYonetici.cihazaBaglan(sonuc.device);
              if (basarili) {
                Navigator.pop(context);
              }
            },
          );
        },
      ),
    );
  }
}