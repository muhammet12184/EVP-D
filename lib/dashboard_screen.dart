import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'widgets/circular_gauge.dart';
import 'widgets/metric_card.dart';
import 'widgets/linear_gauge.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  final Random _random = Random();

  // Motor Section Values
  double rpm = 0;
  double motorSpeed = 0;
  double engineTemp = 90;
  double boost = 0;
  double throttle = 0;
  double engineLoad = 0;
  double fuel = 75;
  double airIntake = 0;
  double transmissionTemp = 85;

  // Electric Section Values
  double batteryTemp = 25;
  double electricSpeed = 0;
  double motorTemp = 60;
  double batteryHealth = 95;
  double batterySOC = 80;
  double power = 0;
  double regen = 0;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        // Simulate motor values
        rpm = 1000 + _random.nextDouble() * 5000;
        motorSpeed = 20 + _random.nextDouble() * 180;
        engineTemp = 85 + _random.nextDouble() * 15;
        boost = _random.nextDouble() * 2.5;
        throttle = _random.nextDouble() * 100;
        engineLoad = _random.nextDouble() * 100;
        fuel = max(0, fuel - _random.nextDouble() * 0.1);
        airIntake = _random.nextDouble() * 100;
        transmissionTemp = 80 + _random.nextDouble() * 20;

        // Simulate electric values
        batteryTemp = 20 + _random.nextDouble() * 15;
        electricSpeed = motorSpeed;
        motorTemp = 55 + _random.nextDouble() * 25;
        batteryHealth = 90 + _random.nextDouble() * 10;
        batterySOC = max(0, min(100, batterySOC + (_random.nextDouble() - 0.5)));
        power = _random.nextDouble() * 200;
        regen = _random.nextDouble() * 50;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0A0A),
              const Color(0xFF1A1A1A),
              const Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildMotorSection()),
                    Container(
                      width: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF0066B1).withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: _buildElectricSection()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF0066B1).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.electric_car,
            color: const Color(0xFF0066B1),
            size: 32,
          ),
          const SizedBox(width: 12),
          Text(
            'BMW i8',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'DASHBOARD',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: const Color(0xFF0066B1),
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'MOTOR',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF6B00),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CircularGauge(
                          title: 'DEVİR',
                          value: rpm,
                          maxValue: 8000,
                          unit: 'RPM',
                          color: const Color(0xFFFF6B00),
                          size: 180,
                        ),
                      ),
                      Expanded(
                        child: CircularGauge(
                          title: 'HIZ',
                          value: motorSpeed,
                          maxValue: 250,
                          unit: 'km/h',
                          color: const Color(0xFF00D9FF),
                          size: 180,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          title: 'HARARET',
                          value: engineTemp.toStringAsFixed(1),
                          unit: '°C',
                          icon: Icons.thermostat,
                          color: _getTemperatureColor(engineTemp, 110),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MetricCard(
                          title: 'BOOST',
                          value: boost.toStringAsFixed(2),
                          unit: 'bar',
                          icon: Icons.speed,
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearGauge(
                    title: 'GAZ KELEBEĞİ',
                    value: throttle,
                    maxValue: 100,
                    unit: '%',
                    color: const Color(0xFF00FF00),
                  ),
                  const SizedBox(height: 8),
                  LinearGauge(
                    title: 'MOTOR YÜKÜ',
                    value: engineLoad,
                    maxValue: 100,
                    unit: '%',
                    color: const Color(0xFFFF6B00),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          title: 'YAKIT',
                          value: fuel.toStringAsFixed(1),
                          unit: '%',
                          icon: Icons.local_gas_station,
                          color: _getFuelColor(fuel),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MetricCard(
                          title: 'HAVA',
                          value: airIntake.toStringAsFixed(0),
                          unit: '%',
                          icon: Icons.air,
                          color: const Color(0xFF00D9FF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  MetricCard(
                    title: 'ŞANZIMAN SICAKLIĞI',
                    value: transmissionTemp.toStringAsFixed(1),
                    unit: '°C',
                    icon: Icons.settings,
                    color: _getTemperatureColor(transmissionTemp, 120),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElectricSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'ELEKTRİK',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0066B1),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CircularGauge(
                          title: 'BATARYA SOC',
                          value: batterySOC,
                          maxValue: 100,
                          unit: '%',
                          color: _getBatteryColor(batterySOC),
                          size: 180,
                        ),
                      ),
                      Expanded(
                        child: CircularGauge(
                          title: 'HIZ',
                          value: electricSpeed,
                          maxValue: 250,
                          unit: 'km/h',
                          color: const Color(0xFF00D9FF),
                          size: 180,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          title: 'BATARYA SICAKLIĞI',
                          value: batteryTemp.toStringAsFixed(1),
                          unit: '°C',
                          icon: Icons.thermostat,
                          color: _getTemperatureColor(batteryTemp, 45),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: MetricCard(
                          title: 'MOTOR SICAKLIĞI',
                          value: motorTemp.toStringAsFixed(1),
                          unit: '°C',
                          icon: Icons.thermostat,
                          color: _getTemperatureColor(motorTemp, 80),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  MetricCard(
                    title: 'BATARYA SAĞLIĞI',
                    value: batteryHealth.toStringAsFixed(1),
                    unit: '%',
                    icon: Icons.battery_charging_full,
                    color: _getBatteryHealthColor(batteryHealth),
                  ),
                  const SizedBox(height: 8),
                  LinearGauge(
                    title: 'GÜÇ',
                    value: power,
                    maxValue: 250,
                    unit: 'kW',
                    color: const Color(0xFF0066B1),
                  ),
                  const SizedBox(height: 8),
                  LinearGauge(
                    title: 'REJENERASYON',
                    value: regen,
                    maxValue: 70,
                    unit: 'kW',
                    color: const Color(0xFF00FF00),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTemperatureColor(double temp, double maxNormal) {
    if (temp < maxNormal * 0.7) return const Color(0xFF00FF00);
    if (temp < maxNormal * 0.85) return const Color(0xFFFFD700);
    if (temp < maxNormal) return const Color(0xFFFF8C00);
    return const Color(0xFFFF0000);
  }

  Color _getFuelColor(double fuelLevel) {
    if (fuelLevel > 50) return const Color(0xFF00FF00);
    if (fuelLevel > 25) return const Color(0xFFFFD700);
    return const Color(0xFFFF0000);
  }

  Color _getBatteryColor(double soc) {
    if (soc > 60) return const Color(0xFF00FF00);
    if (soc > 30) return const Color(0xFFFFD700);
    if (soc > 15) return const Color(0xFFFF8C00);
    return const Color(0xFFFF0000);
  }

  Color _getBatteryHealthColor(double health) {
    if (health > 80) return const Color(0xFF00FF00);
    if (health > 60) return const Color(0xFFFFD700);
    return const Color(0xFFFF8C00);
  }
}
