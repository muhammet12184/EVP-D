import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'engine_section.dart';
import 'electric_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  
  // Mock data - gerçek uygulamada sensörlerden gelecek
  double rpm = 2500;
  double engineTemp = 85;
  double boost = 0.8;
  double throttle = 45;
  double engineLoad = 65;
  double fuelAirRatio = 14.7;
  double transmissionTemp = 75;
  double fuelConsumption = 0.0; // Yakıt tüketimi (L/h) - PID'den gelecek
  
  double batteryTemp = 28;
  double motorSpeed = 3500;
  double batteryHealth = 92;
  double batterySOC = 78;
  double regenPower = 15;
  
  // Araç marka tespiti (PIDRouter'dan gelecek)
  String? detectedVehicleBrand;
  bool showDebugInfo = true; // Debug bilgilerini göster/gizle

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    // Araç marka tespitini simüle et (gerçek uygulamada PIDRouter'dan gelecek)
    _detectVehicleBrand();
    
    // Simüle edilmiş veri güncellemeleri
    _simulateDataUpdates();
  }

  void _detectVehicleBrand() {
    // Simüle edilmiş marka tespiti
    // Gerçek uygulamada bu PIDRouter.detect_vehicle_brand() çağrısından gelecek
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          // Örnek: TOGG, BMW, Tesla, vb. tespit edilebilir
          detectedVehicleBrand = "TOGG"; // Varsayılan, gerçekte PIDRouter'dan gelecek
        });
      }
    });
  }

  void _simulateDataUpdates() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          rpm = (rpm + (math.Random().nextDouble() * 200 - 100)).clamp(0, 8500);
          engineTemp = (engineTemp + (math.Random().nextDouble() * 2 - 1)).clamp(60, 120);
          boost = (boost + (math.Random().nextDouble() * 0.1 - 0.05)).clamp(0, 1);
          throttle = (throttle + (math.Random().nextDouble() * 10 - 5)).clamp(0, 100);
          engineLoad = (engineLoad + (math.Random().nextDouble() * 5 - 2.5)).clamp(0, 100);
          transmissionTemp = (transmissionTemp + (math.Random().nextDouble() * 1 - 0.5)).clamp(60, 100);
          
          // Yakıt tüketimi simülasyonu (gerçekte PID'den gelecek)
          fuelConsumption = (fuelConsumption + (math.Random().nextDouble() * 0.5 - 0.25)).clamp(0, 20);
          
          batteryTemp = (batteryTemp + (math.Random().nextDouble() * 0.5 - 0.25)).clamp(20, 40);
          motorSpeed = (motorSpeed + (math.Random().nextDouble() * 100 - 50)).clamp(0, 8000);
          batterySOC = (batterySOC + (math.Random().nextDouble() * 0.2 - 0.1)).clamp(0, 100);
          regenPower = (regenPower + (math.Random().nextDouble() * 2 - 1)).clamp(0, 50);
        });
        _simulateDataUpdates();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A0A0A),
              const Color(0xFF1A1A2E),
              const Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Row(
                children: [
                  // Motor Bölümü
                  Expanded(
                    child: EngineSection(
                      rpm: rpm,
                      engineTemp: engineTemp,
                      boost: boost,
                      throttle: throttle,
                      engineLoad: engineLoad,
                      fuelAirRatio: fuelAirRatio,
                      transmissionTemp: transmissionTemp,
                      fuelConsumption: fuelConsumption,
                    ),
                  ),
                  
                  // Orta Ayırıcı
                  Container(
                    width: 3,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xFFDC143C).withOpacity(0.6), // Ferrari kırmızısı
                          Colors.blue.withOpacity(0.6), // BMW mavisi
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.4, 0.6, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFDC143C).withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  
                  // Elektrik Bölümü
                  Expanded(
                    child: ElectricSection(
                      batteryTemp: batteryTemp,
                      motorSpeed: motorSpeed,
                      batteryHealth: batteryHealth,
                      batterySOC: batterySOC,
                      regenPower: regenPower,
                    ),
                  ),
                ],
              ),
              
              // Debug Bilgi Widget'ı (Araç Marka Tespiti)
              if (showDebugInfo)
                Positioned(
                  top: 10,
                  right: 10,
                  child: _VehicleBrandDebugInfo(
                    detectedBrand: detectedVehicleBrand,
                    onToggle: () {
                      setState(() {
                        showDebugInfo = !showDebugInfo;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleBrandDebugInfo extends StatelessWidget {
  final String? detectedBrand;
  final VoidCallback onToggle;

  const _VehicleBrandDebugInfo({
    required this.detectedBrand,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: detectedBrand != null ? Colors.green : Colors.orange,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (detectedBrand != null ? Colors.green : Colors.orange).withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              detectedBrand != null ? Icons.check_circle : Icons.info,
              color: detectedBrand != null ? Colors.green : Colors.orange,
              size: 16,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ARAÇ MARKASI',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade400,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detectedBrand ?? 'Tespit Ediliyor...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: detectedBrand != null ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.close,
              color: Colors.grey.shade400,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
