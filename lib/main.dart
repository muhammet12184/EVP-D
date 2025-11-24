import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(
    () async {
      try {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);

        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Color(0xFF1A1A1C),
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );
      } catch (e) {
        print('SystemChrome hatası: $e');
      }

      runApp(const OBDProApp());
    },
    (error, stack) {
      print('Uygulama hatası: $error');
    },
  );
}

class OBDProApp extends StatelessWidget {
  const OBDProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBD-II Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A1C),
        cardColor: const Color(0xFF232326),
        primaryColor: const Color(0xFFE50914),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF232326),
          foregroundColor: Color(0xFFF2F2F2),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFF2F2F2)),
          bodyMedium: TextStyle(color: Color(0xFFF2F2F2)),
          bodySmall: TextStyle(color: Color(0xFFF2F2F2)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      print('Başlatma hatası: $e');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car,
              size: 100,
              color: const Color(0xFFE50914),
            ),
            const SizedBox(height: 20),
            const Text(
              'OBD-II Pro',
              style: TextStyle(
                color: Color(0xFFF2F2F2),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Profesyonel Araç Teşhis',
              style: TextStyle(
                color: Color(0xFFF2F2F2),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Color(0xFFE50914),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String durum = 'Başlatılıyor...';
  bool bluetoothAcik = false;
  bool izinlerVerildi = false;
  Color durumRenk = const Color(0xFFFFFF00);

  double hiz = 0;
  double rpm = 0;
  double soc = 0;
  double guc = 0;
  double tork = 0;
  double bataryaSicakligi = 0;
  double motorSicakligi = 0;
  bool evMod = false;

  @override
  void initState() {
    super.initState();
    _basla();
  }

  Future<void> _basla() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _izinleriKontrolEt();
    await _bluetoothKontrolEt();
  }

  Future<void> _izinleriKontrolEt() async {
    try {
      var bluetooth = await Permission.bluetooth.request();
      var bluetoothScan = await Permission.bluetoothScan.request();
      var bluetoothConnect = await Permission.bluetoothConnect.request();
      var location = await Permission.location.request();

      if (!mounted) return;

      setState(() {
        izinlerVerildi = bluetooth.isGranted &&
            bluetoothScan.isGranted &&
            bluetoothConnect.isGranted &&
            location.isGranted;

        if (izinlerVerildi) {
          durum = 'İzinler Verildi';
          durumRenk = const Color(0xFF00FF00);
        } else {
          durum = 'İzinler Gerekli';
          durumRenk = const Color(0xFFFFFF00);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        durum = 'İzin Hatası';
        durumRenk = const Color(0xFFE50914);
      });
    }
  }

  Future<void> _bluetoothKontrolEt() async {
    try {
      var adapterState = await FlutterBluePlus.adapterState.first;
      
      if (!mounted) return;

      setState(() {
        bluetoothAcik = adapterState == BluetoothAdapterState.on;
        
        if (!bluetoothAcik) {
          durum = 'Bluetooth Kapalı';
          durumRenk = const Color(0xFFE50914);
        } else if (izinlerVerildi) {
          durum = 'Hazır';
          durumRenk = const Color(0xFF00FF00);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        durum = 'Bluetooth Hatası';
        durumRenk = const Color(0xFFE50914);
      });
    }
  }

  void _cihazlariTara() async {
    if (!bluetoothAcik || !izinlerVerildi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bluetooth ve izinler gerekli')),
      );
      return;
    }

    try {
      setState(() {
        durum = 'Taranıyor...';
        durumRenk = const Color(0xFFFFFF00);
      });

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
      await Future.delayed(const Duration(seconds: 5));
      await FlutterBluePlus.stopScan();

      if (!mounted) return;

      setState(() {
        durum = 'Tarama Tamamlandı';
        durumRenk = const Color(0xFF00FF00);
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CihazListesi()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        durum = 'Tarama Hatası';
        durumRenk = const Color(0xFFE50914);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OBD-II Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth, color: Color(0xFFE50914)),
            onPressed: _cihazlariTara,
          ),
          Switch(
            value: evMod,
            onChanged: (val) {
              setState(() {
                evMod = val;
              });
            },
            activeColor: const Color(0xFFE50914),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: durumRenk,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    durum,
                    style: const TextStyle(
                      color: Color(0xFF1A1A1C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bluetooth: ${bluetoothAcik ? "Açık" : "Kapalı"}',
                    style: const TextStyle(color: Color(0xFF1A1A1C), fontSize: 14),
                  ),
                  Text(
                    'İzinler: ${izinlerVerildi ? "Verildi" : "Verilmedi"}',
                    style: const TextStyle(color: Color(0xFF1A1A1C), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _DijitalHizGostergesi(hiz: hiz),
            const SizedBox(height: 20),
            if (!evMod) _AnalogRPMGostergesi(rpm: rpm),
            if (evMod) _BataryaSOCGostergesi(soc: soc),
            const SizedBox(height: 20),
            _GucBari(guc: guc, maxGuc: 300, baslik: 'GÜÇ'),
            const SizedBox(height: 15),
            _TorkBari(tork: tork, maxTork: 500),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _SicaklikGostergesi(
                    sicaklik: evMod ? bataryaSicakligi : motorSicakligi,
                    baslik: evMod ? 'BATARYA' : 'MOTOR',
                    icon: evMod ? Icons.battery_charging_full : Icons.thermostat,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SicaklikGostergesi(
                    sicaklik: motorSicakligi,
                    baslik: evMod ? 'MOTOR' : 'SOĞUTMA',
                    icon: Icons.ac_unit,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (!izinlerVerildi)
              ElevatedButton(
                onPressed: _izinleriKontrolEt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('İzinleri Yenile', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            if (!bluetoothAcik && izinlerVerildi)
              ElevatedButton(
                onPressed: _bluetoothKontrolEt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Bluetooth Kontrol Et', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}

class CihazListesi extends StatefulWidget {
  const CihazListesi({super.key});

  @override
  State<CihazListesi> createState() => _CihazListesiState();
}

class _CihazListesiState extends State<CihazListesi> {
  List<ScanResult> cihazlar = [];
  bool taraniyor = false;
  StreamSubscription? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _dinle();
    _taramaBaslat();
  }

  void _dinle() {
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          cihazlar = results;
        });
      }
    });
  }

  void _taramaBaslat() async {
    try {
      if (mounted) {
        setState(() {
          taraniyor = true;
        });
      }
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      await Future.delayed(const Duration(seconds: 10));
      if (mounted) {
        setState(() {
          taraniyor = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          taraniyor = false;
        });
      }
    }
  }

  void _taramaDurdur() async {
    try {
      await FlutterBluePlus.stopScan();
      if (mounted) {
        setState(() {
          taraniyor = false;
        });
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _taramaDurdur();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Cihazlar'),
        actions: [
          IconButton(
            icon: Icon(
              taraniyor ? Icons.stop : Icons.refresh,
              color: const Color(0xFFE50914),
            ),
            onPressed: taraniyor ? _taramaDurdur : _taramaBaslat,
          ),
        ],
      ),
      body: cihazlar.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bluetooth_searching,
                    size: 64,
                    color: Color(0xFFE50914),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cihaz bulunamadı',
                    style: TextStyle(color: Color(0xFFF2F2F2), fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _taramaBaslat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                    ),
                    child: const Text('Tekrar Tara', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: cihazlar.length,
              itemBuilder: (context, index) {
                ScanResult sonuc = cihazlar[index];
                return Card(
                  color: const Color(0xFF232326),
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.bluetooth, color: Color(0xFFE50914)),
                    title: Text(
                      sonuc.device.platformName.isEmpty
                          ? 'Bilinmeyen Cihaz'
                          : sonuc.device.platformName,
                      style: const TextStyle(color: Color(0xFFF2F2F2)),
                    ),
                    subtitle: Text(
                      sonuc.device.remoteId.toString(),
                      style: TextStyle(color: const Color(0xFFF2F2F2).withOpacity(0.7)),
                    ),
                    trailing: Text(
                      '${sonuc.rssi} dBm',
                      style: const TextStyle(color: Color(0xFFE50914)),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${sonuc.device.platformName} seçildi')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _DijitalHizGostergesi extends StatelessWidget {
  final double hiz;
  const _DijitalHizGostergesi({required this.hiz});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF232326),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE50914), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hiz.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE50914),
            ),
          ),
          const Text(
            'KM/H',
            style: TextStyle(fontSize: 18, color: Color(0xFFF2F2F2)),
          ),
        ],
      ),
    );
  }
}

class _AnalogRPMGostergesi extends StatelessWidget {
  final double rpm;
  const _AnalogRPMGostergesi({required this.rpm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFF232326),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              rpm.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF2F2F2),
              ),
            ),
            const Text(
              'RPM',
              style: TextStyle(fontSize: 14, color: Color(0xFFF2F2F2)),
            ),
          ],
        ),
      ),
    );
  }
}

class _BataryaSOCGostergesi extends StatelessWidget {
  final double soc;
  const _BataryaSOCGostergesi({required this.soc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        color: Color(0xFF232326),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${soc.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF2F2F2),
              ),
            ),
            const Text(
              'ŞARJ',
              style: TextStyle(fontSize: 12, color: Color(0xFFF2F2F2)),
            ),
          ],
        ),
      ),
    );
  }
}

class _GucBari extends StatelessWidget {
  final double guc;
  final double maxGuc;
  final String baslik;
  const _GucBari({required this.guc, required this.maxGuc, required this.baslik});

  @override
  Widget build(BuildContext context) {
    double progress = (guc / maxGuc).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF232326),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(baslik, style: const TextStyle(fontSize: 16, color: Color(0xFFF2F2F2))),
              Text(
                '${guc.toStringAsFixed(1)} kW',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE50914),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE50914),
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

class _TorkBari extends StatelessWidget {
  final double tork;
  final double maxTork;
  const _TorkBari({required this.tork, required this.maxTork});

  @override
  Widget build(BuildContext context) {
    double progress = (tork / maxTork).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF232326),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TORK', style: TextStyle(fontSize: 16, color: Color(0xFFF2F2F2))),
              Text(
                '${tork.toStringAsFixed(0)} Nm',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE50914),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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

class _SicaklikGostergesi extends StatelessWidget {
  final double sicaklik;
  final String baslik;
  final IconData icon;
  const _SicaklikGostergesi({
    required this.sicaklik,
    required this.baslik,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color renk = const Color(0xFF00FF00);
    if (sicaklik > 80) {
      renk = const Color(0xFFE50914);
    } else if (sicaklik > 60) {
      renk = const Color(0xFFFFFF00);
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF232326),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: renk, size: 30),
          const SizedBox(height: 8),
          Text(baslik, style: const TextStyle(fontSize: 12, color: Color(0xFFF2F2F2))),
          const SizedBox(height: 4),
          Text(
            '${sicaklik.toStringAsFixed(0)}°C',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: renk),
          ),
        ],
      ),
    );
  }
}
