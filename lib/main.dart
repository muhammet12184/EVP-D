import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(OBDUygulamasi());
}

class OBDUygulamasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBD-II Pro',
      debugShowCheckedModeBanner: false,
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

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String durum = 'Bağlantı Yok';
  bool bluetoothAcik = false;
  bool izinlerVerildi = false;
  
  double hiz = 0;
  double rpm = 0;
  double soc = 0;
  bool evMod = false;

  @override
  void initState() {
    super.initState();
    basla();
  }

  Future<void> basla() async {
    await Future.delayed(Duration(milliseconds: 500));
    await izinleriKontrolEt();
    await bluetoothKontrolEt();
  }

  Future<void> izinleriKontrolEt() async {
    try {
      var bluetooth = await Permission.bluetooth.request();
      var bluetoothScan = await Permission.bluetoothScan.request();
      var bluetoothConnect = await Permission.bluetoothConnect.request();
      var location = await Permission.location.request();
      
      if (mounted) {
        setState(() {
          izinlerVerildi = bluetooth.isGranted && 
                          bluetoothScan.isGranted && 
                          bluetoothConnect.isGranted && 
                          location.isGranted;
          if (izinlerVerildi) {
            durum = 'İzinler Verildi';
          } else {
            durum = 'İzinler Gerekli';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          durum = 'İzin Hatası: $e';
        });
      }
    }
  }

  Future<void> bluetoothKontrolEt() async {
    try {
      var adapterState = await FlutterBluePlus.adapterState.first;
      if (mounted) {
        setState(() {
          bluetoothAcik = adapterState == BluetoothAdapterState.on;
          if (!bluetoothAcik) {
            durum = 'Bluetooth Kapalı';
          } else if (izinlerVerildi) {
            durum = 'Hazır';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          durum = 'Bluetooth Hatası: $e';
        });
      }
    }
  }

  void cihazlariTara() async {
    if (!bluetoothAcik || !izinlerVerildi) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bluetooth ve izinler gerekli')),
      );
      return;
    }

    try {
      if (mounted) {
        setState(() {
          durum = 'Taranıyor...';
        });
      }

      await FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
      
      await Future.delayed(Duration(seconds: 5));
      
      await FlutterBluePlus.stopScan();
      
      if (mounted) {
        setState(() {
          durum = 'Tarama Tamamlandı';
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CihazListesi()),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          durum = 'Tarama Hatası: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color durumRenk = Color(0xFFE50914);
    if (durum == 'Hazır') {
      durumRenk = Color(0xFF00FF00);
    } else if (durum.contains('İzin')) {
      durumRenk = Color(0xFFFFFF00);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('OBD-II Pro', style: TextStyle(color: Color(0xFFF2F2F2))),
        backgroundColor: Color(0xFF232326),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth, color: Color(0xFFE50914)),
            onPressed: cihazlariTara,
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
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: durumRenk,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    durum,
                    style: TextStyle(
                      color: Color(0xFF1A1A1C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bluetooth: ${bluetoothAcik ? "Açık" : "Kapalı"}',
                    style: TextStyle(color: Color(0xFF1A1A1C), fontSize: 14),
                  ),
                  Text(
                    'İzinler: ${izinlerVerildi ? "Verildi" : "Verilmedi"}',
                    style: TextStyle(color: Color(0xFF1A1A1C), fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            DijitalHizGostergesi(hiz: hiz),
            SizedBox(height: 20),
            if (!evMod) AnalogRPMGostergesi(rpm: rpm),
            if (evMod) BataryaSOCGostergesi(soc: soc),
            SizedBox(height: 20),
            GucBari(guc: 0, maxGuc: 300, baslik: 'GÜÇ'),
            SizedBox(height: 15),
            TorkBari(tork: 0, maxTork: 500),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SicaklikGostergesi(
                    sicaklik: 0,
                    baslik: evMod ? 'BATARYA' : 'MOTOR',
                    icon: evMod ? Icons.battery_charging_full : Icons.thermostat,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SicaklikGostergesi(
                    sicaklik: 0,
                    baslik: evMod ? 'MOTOR' : 'SOĞUTMA',
                    icon: Icons.ac_unit,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            if (!izinlerVerildi)
              ElevatedButton(
                onPressed: izinleriKontrolEt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE50914),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('İzinleri Yenile', style: TextStyle(fontSize: 16)),
              ),
            if (!bluetoothAcik && izinlerVerildi)
              ElevatedButton(
                onPressed: bluetoothKontrolEt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE50914),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('Bluetooth Kontrol Et', style: TextStyle(fontSize: 16)),
              ),
          ],
        ),
      ),
    );
  }
}

class CihazListesi extends StatefulWidget {
  @override
  _CihazListesiState createState() => _CihazListesiState();
}

class _CihazListesiState extends State<CihazListesi> {
  List<ScanResult> cihazlar = [];
  bool taraniyor = false;

  @override
  void initState() {
    super.initState();
    dinle();
  }

  void dinle() {
    FlutterBluePlus.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          cihazlar = results;
        });
      }
    });
  }

  void taramaBaslat() async {
    try {
      if (mounted) {
        setState(() {
          taraniyor = true;
        });
      }
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
      await Future.delayed(Duration(seconds: 10));
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

  void taramaDurdur() async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Cihazlar', style: TextStyle(color: Color(0xFFF2F2F2))),
        backgroundColor: Color(0xFF232326),
        actions: [
          IconButton(
            icon: Icon(taraniyor ? Icons.stop : Icons.refresh, color: Color(0xFFE50914)),
            onPressed: taraniyor ? taramaDurdur : taramaBaslat,
          ),
        ],
      ),
      body: cihazlar.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bluetooth_searching, size: 64, color: Color(0xFFE50914)),
                  SizedBox(height: 16),
                  Text('Cihaz bulunamadı', style: TextStyle(color: Color(0xFFF2F2F2), fontSize: 18)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: taramaBaslat,
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE50914)),
                    child: Text('Tekrar Tara'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: cihazlar.length,
              itemBuilder: (context, index) {
                ScanResult sonuc = cihazlar[index];
                return Card(
                  color: Color(0xFF232326),
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Icon(Icons.bluetooth, color: Color(0xFFE50914)),
                    title: Text(
                      sonuc.device.platformName.isEmpty ? 'Bilinmeyen Cihaz' : sonuc.device.platformName,
                      style: TextStyle(color: Color(0xFFF2F2F2)),
                    ),
                    subtitle: Text(
                      sonuc.device.remoteId.toString(),
                      style: TextStyle(color: Color(0xFFF2F2F2).withOpacity(0.7)),
                    ),
                    trailing: Text(
                      '${sonuc.rssi} dBm',
                      style: TextStyle(color: Color(0xFFE50914)),
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

  @override
  void dispose() {
    taramaDurdur();
    super.dispose();
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
          Text(hiz.toStringAsFixed(0), style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Color(0xFFE50914))),
          Text('KM/H', style: TextStyle(fontSize: 18, color: Color(0xFFF2F2F2))),
        ],
      ),
    );
  }
}

class AnalogRPMGostergesi extends StatelessWidget {
  final double rpm;
  AnalogRPMGostergesi({required this.rpm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(rpm.toStringAsFixed(0), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF2F2F2))),
            Text('RPM', style: TextStyle(fontSize: 14, color: Color(0xFFF2F2F2))),
          ],
        ),
      ),
    );
  }
}

class BataryaSOCGostergesi extends StatelessWidget {
  final double soc;
  BataryaSOCGostergesi({required this.soc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFF232326),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${soc.toStringAsFixed(0)}%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFF2F2F2))),
            Text('ŞARJ', style: TextStyle(fontSize: 12, color: Color(0xFFF2F2F2))),
          ],
        ),
      ),
    );
  }
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
      decoration: BoxDecoration(color: Color(0xFF232326), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(baslik, style: TextStyle(fontSize: 16, color: Color(0xFFF2F2F2))),
              Text('${guc.toStringAsFixed(1)} kW', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE50914))),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 20,
            decoration: BoxDecoration(color: Color(0xFF1A1A1C), borderRadius: BorderRadius.circular(10)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(decoration: BoxDecoration(color: Color(0xFFE50914), borderRadius: BorderRadius.circular(10))),
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
      decoration: BoxDecoration(color: Color(0xFF232326), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TORK', style: TextStyle(fontSize: 16, color: Color(0xFFF2F2F2))),
              Text('${tork.toStringAsFixed(0)} Nm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE50914))),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 20,
            decoration: BoxDecoration(color: Color(0xFF1A1A1C), borderRadius: BorderRadius.circular(10)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFE50914), Color(0xFFFF6B6B)]), borderRadius: BorderRadius.circular(10))),
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
  SicaklikGostergesi({required this.sicaklik, required this.baslik, required this.icon});

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
      decoration: BoxDecoration(color: Color(0xFF232326), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Icon(icon, color: renk, size: 30),
          SizedBox(height: 8),
          Text(baslik, style: TextStyle(fontSize: 12, color: Color(0xFFF2F2F2))),
          SizedBox(height: 4),
          Text('${sicaklik.toStringAsFixed(0)}°C', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: renk)),
        ],
      ),
    );
  }
}
