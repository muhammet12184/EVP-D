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
  
  double batteryTemp = 28;
  double motorSpeed = 3500;
  double batteryHealth = 92;
  double batterySOC = 78;
  double regenPower = 15;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    // Simüle edilmiş veri güncellemeleri
    _simulateDataUpdates();
  }

  void _simulateDataUpdates() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          rpm = (rpm + (math.Random().nextDouble() * 200 - 100)).clamp(0, 8000);
          engineTemp = (engineTemp + (math.Random().nextDouble() * 2 - 1)).clamp(60, 120);
          boost = (boost + (math.Random().nextDouble() * 0.1 - 0.05)).clamp(0, 1);
          throttle = (throttle + (math.Random().nextDouble() * 10 - 5)).clamp(0, 100);
          engineLoad = (engineLoad + (math.Random().nextDouble() * 5 - 2.5)).clamp(0, 100);
          transmissionTemp = (transmissionTemp + (math.Random().nextDouble() * 1 - 0.5)).clamp(60, 100);
          
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
          child: Row(
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
                ),
              ),
              
              // Orta Ayırıcı
              Container(
                width: 2,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.blue.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
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
        ),
      ),
    );
  }
}
