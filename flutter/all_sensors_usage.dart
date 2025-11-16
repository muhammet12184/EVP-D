/// ⚡ TÜM SENSÖRLER KULLANIM ÖRNEĞİ
import 'all_sensors_pids.dart';

void main() {
  print('═══════════════════════════════════════════════════════════');
  print('   🚗 TÜM SENSÖRLER VE PID LİSTESİ');
  print('═══════════════════════════════════════════════════════════\n');

  // Toplam PID sayısı
  print('📊 Toplam PID Sayısı: ${PIDType.values.length}');
  print('');

  // Araç tipine göre PID'ler
  print('🚗 BENZİNLİ ARAÇLAR:');
  final gasolinePIDs = getPIDsForVehicleType(VehicleType.gasoline);
  print('   ${gasolinePIDs.length} PID');
  gasolinePIDs.take(10).forEach((pid) {
    print('   ✓ ${pid.turkishName} (${pid.pid})');
  });
  print('   ... ve ${gasolinePIDs.length - 10} PID daha\n');

  print('🚜 DİZEL ARAÇLAR:');
  final dieselPIDs = getPIDsForVehicleType(VehicleType.diesel);
  print('   ${dieselPIDs.length} PID');
  dieselPIDs.where((p) => p.name.contains('dpf') || p.name.contains('adBlue'))
      .take(10).forEach((pid) {
    print('   ✓ ${pid.turkishName} (${pid.pid})');
  });
  print('');

  print('⚡ ELEKTRİKLİ ARAÇLAR:');
  final electricPIDs = getPIDsForVehicleType(VehicleType.electric);
  print('   ${electricPIDs.length} PID');
  electricPIDs.take(10).forEach((pid) {
    print('   ✓ ${pid.turkishName} (${pid.pid})');
  });
  print('   ... ve ${electricPIDs.length - 10} PID daha\n');

  print('🔋 HİBRİT ARAÇLAR:');
  final hybridPIDs = getPIDsForVehicleType(VehicleType.hybrid);
  print('   ${hybridPIDs.length} PID\n');

  // Kategoriye göre PID'ler
  print('═══════════════════════════════════════════════════════════');
  print('   📂 KATEGORİLERE GÖRE PID\'LER');
  print('═══════════════════════════════════════════════════════════\n');

  for (var category in PIDCategory.values) {
    final pids = getPIDsByCategory(category);
    if (pids.isNotEmpty) {
      print('📁 ${category.name.toUpperCase()}: ${pids.length} PID');
      pids.take(5).forEach((pid) {
        print('   • ${pid.turkishName}');
      });
      if (pids.length > 5) {
        print('   ... ve ${pids.length - 5} PID daha');
      }
      print('');
    }
  }

  // Özel PID örnekleri
  print('═══════════════════════════════════════════════════════════');
  print('   🎯 ÖZEL PID ÖRNEKLERİ');
  print('═══════════════════════════════════════════════════════════\n');

  print('⛽ YAKIT SİSTEMİ:');
  [
    PIDType.fuelRate,
    PIDType.fuelLevel,
    PIDType.fuelPressure,
    PIDType.fuelType,
  ].forEach((pid) {
    print('   ${pid.turkishName}');
    print('   └─ Command: ${pid.getFullCommand()}');
    print('   └─ Equation: ${pid.equation}\n');
  });

  print('🔋 EV BATARYA:');
  [
    PIDType.batterySoc,
    PIDType.batteryVoltage,
    PIDType.batteryCurrent,
    PIDType.batteryTemp,
    PIDType.regenPower,
  ].forEach((pid) {
    print('   ${pid.turkishName}');
    print('   └─ Command: ${pid.getFullCommand()}');
    print('   └─ Equation: ${pid.equation}\n');
  });

  print('🚜 DİZEL SPESİFİK:');
  [
    PIDType.dpfTemperature,
    PIDType.adBlueLevel,
    PIDType.noxSensorUpstream,
    PIDType.turboBoostPressure,
  ].forEach((pid) {
    print('   ${pid.turkishName}');
    print('   └─ Command: ${pid.getFullCommand()}');
    print('   └─ Equation: ${pid.equation}\n');
  });

  print('🎚️ SENSÖRLER:');
  [
    PIDType.wheelSpeedFL,
    PIDType.steeringAngle,
    PIDType.tirePressureFL,
    PIDType.lateralAcceleration,
  ].forEach((pid) {
    print('   ${pid.turkishName}');
    print('   └─ Command: ${pid.getFullCommand()}\n');
  });
}

/// Kullanım örneği: Gerçek PID okuma
class AllSensorReader {
  Future<Map<String, dynamic>> readAllSensors(VehicleType type) async {
    final pids = getPIDsForVehicleType(type);
    final results = <String, dynamic>{};

    for (var pid in pids) {
      try {
        // PID'i oku
        final value = await _readPID(pid);
        results[pid.turkishName] = value;
      } catch (e) {
        results[pid.turkishName] = 'ERROR';
      }
    }

    return results;
  }

  Future<double> _readPID(PIDType pid) async {
    // Gerçek PID okuma implementasyonu
    // Bu örnek mock değer döndürür
    await Future.delayed(Duration(milliseconds: 10));
    return 0.0;
  }
}

/// Widget örneği: Tüm sensörleri göster
/*
import 'package:flutter/material.dart';

class AllSensorsScreen extends StatelessWidget {
  final VehicleType vehicleType;

  const AllSensorsScreen({Key? key, required this.vehicleType}) 
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pids = getPIDsForVehicleType(vehicleType);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tüm Sensörler (${pids.length} adet)'),
      ),
      body: ListView.builder(
        itemCount: pids.length,
        itemBuilder: (context, index) {
          final pid = pids[index];
          return ListTile(
            leading: Icon(_getIconForPID(pid)),
            title: Text(pid.turkishName),
            subtitle: Text('${pid.description} - ${pid.pid}'),
            trailing: StreamBuilder<double>(
              stream: _readPIDStream(pid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                return Text(
                  '${snapshot.data!.toStringAsFixed(1)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForPID(PIDType pid) {
    if (pid.name.contains('temp')) return Icons.thermostat;
    if (pid.name.contains('battery')) return Icons.battery_charging_full;
    if (pid.name.contains('fuel')) return Icons.local_gas_station;
    if (pid.name.contains('speed')) return Icons.speed;
    if (pid.name.contains('pressure')) return Icons.compress;
    return Icons.sensors;
  }

  Stream<double> _readPIDStream(PIDType pid) async* {
    while (true) {
      // Mock değer
      yield 50.0 + (DateTime.now().millisecond % 50);
      await Future.delayed(Duration(seconds: 1));
    }
  }
}
*/
