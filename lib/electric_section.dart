import 'package:flutter/material.dart';
import 'dart:math' as math;

class ElectricSection extends StatelessWidget {
  final double batteryTemp;
  final double motorSpeed;
  final double batteryHealth;
  final double batterySOC;
  final double regenPower;

  const ElectricSection({
    super.key,
    required this.batteryTemp,
    required this.motorSpeed,
    required this.batteryHealth,
    required this.batterySOC,
    required this.regenPower,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // BMW Logo/Başlık
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.electric_bolt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'BMW i8',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade400,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(
                      color: Colors.blue.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Batarya SOC Göstergesi (Büyük)
          Expanded(
            flex: 2,
            child: _BatterySOCMeter(soc: batterySOC, health: batteryHealth),
          ),
          
          const SizedBox(height: 20),
          
          // Alt Metrikler
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(child: _MetricCard(
                  title: 'BATARYA SICAKLIĞI',
                  value: batteryTemp,
                  unit: '°C',
                  min: 20,
                  max: 40,
                  color: Colors.orange,
                )),
                const SizedBox(width: 10),
                Expanded(child: _MetricCard(
                  title: 'MOTOR HIZI',
                  value: motorSpeed,
                  unit: 'RPM',
                  min: 0,
                  max: 8000,
                  color: Colors.blue,
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(child: _MetricCard(
                  title: 'BATARYA SAĞLIĞI',
                  value: batteryHealth,
                  unit: '%',
                  min: 0,
                  max: 100,
                  color: Colors.green,
                )),
                const SizedBox(width: 10),
                Expanded(child: _MetricCard(
                  title: 'REJENERATİF GÜÇ',
                  value: regenPower,
                  unit: 'kW',
                  min: 0,
                  max: 50,
                  color: Colors.cyan,
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Güç Akışı Göstergesi
          Expanded(
            flex: 2,
            child: _PowerFlowIndicator(
              regenPower: regenPower,
              batterySOC: batterySOC,
            ),
          ),
        ],
      ),
    );
  }
}

class _BatterySOCMeter extends StatelessWidget {
  final double soc;
  final double health;

  const _BatterySOCMeter({
    required this.soc,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.withOpacity(0.5),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'BATARYA',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                soc.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: _getSOCColor(soc),
                  shadows: [
                    Shadow(
                      color: _getSOCColor(soc).withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  '%',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: soc / 100,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getSOCColor(soc),
                          _getSOCColor(soc).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Sağlık: ${health.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSOCColor(double soc) {
    if (soc > 70) return Colors.green;
    if (soc > 40) return Colors.yellow;
    if (soc > 20) return Colors.orange;
    return Colors.red;
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final double min;
  final double max;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = ((value - min) / (max - min)).clamp(0.0, 1.0);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 6,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _PowerFlowIndicator extends StatelessWidget {
  final double regenPower;
  final double batterySOC;

  const _PowerFlowIndicator({
    required this.regenPower,
    required this.batterySOC,
  });

  @override
  Widget build(BuildContext context) {
    final isCharging = regenPower > 0;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.cyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'GÜÇ AKIŞI',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Motor
              Column(
                children: [
                  Icon(
                    Icons.electric_bolt,
                    color: Colors.yellow,
                    size: 30,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MOTOR',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              
              // Ok
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  isCharging ? Icons.arrow_back : Icons.arrow_forward,
                  color: isCharging ? Colors.green : Colors.blue,
                  size: 40,
                ),
              ),
              
              // Batarya
              Column(
                children: [
                  Icon(
                    Icons.battery_charging_full,
                    color: isCharging ? Colors.green : Colors.blue,
                    size: 30,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'BATARYA',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isCharging)
            Text(
              '${regenPower.toStringAsFixed(1)} kW Rejeneratif',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            )
          else
            Text(
              'Güç Çıkışı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }
}
