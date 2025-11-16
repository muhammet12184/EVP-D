import 'package:flutter/material.dart';
import 'dart:math' as math;

class EngineSection extends StatelessWidget {
  final double rpm;
  final double engineTemp;
  final double boost;
  final double throttle;
  final double engineLoad;
  final double fuelAirRatio;
  final double transmissionTemp;

  const EngineSection({
    super.key,
    required this.rpm,
    required this.engineTemp,
    required this.boost,
    required this.throttle,
    required this.engineLoad,
    required this.fuelAirRatio,
    required this.transmissionTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Başlık
          Text(
            'MOTOR',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade400,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 20),
          
          // RPM Göstergesi (Büyük)
          Expanded(
            flex: 2,
            child: _RPMMeter(rpm: rpm),
          ),
          
          const SizedBox(height: 20),
          
          // Alt Metrikler
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(child: _MetricCard(
                  title: 'HARARET',
                  value: engineTemp,
                  unit: '°C',
                  min: 60,
                  max: 120,
                  color: Colors.red,
                )),
                const SizedBox(width: 10),
                Expanded(child: _MetricCard(
                  title: 'BOOST',
                  value: boost * 100,
                  unit: '%',
                  min: 0,
                  max: 100,
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
                  title: 'GAZ KELEBEĞİ',
                  value: throttle,
                  unit: '%',
                  min: 0,
                  max: 100,
                  color: Colors.green,
                )),
                const SizedBox(width: 10),
                Expanded(child: _MetricCard(
                  title: 'MOTOR YÜKÜ',
                  value: engineLoad,
                  unit: '%',
                  min: 0,
                  max: 100,
                  color: Colors.yellow,
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(child: _MetricCard(
                  title: 'YAKIT/HAVA',
                  value: fuelAirRatio,
                  unit: ':1',
                  min: 10,
                  max: 20,
                  color: Colors.purple,
                )),
                const SizedBox(width: 10),
                Expanded(child: _MetricCard(
                  title: 'ŞANZIMAN',
                  value: transmissionTemp,
                  unit: '°C',
                  min: 60,
                  max: 100,
                  color: Colors.cyan,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RPMMeter extends StatelessWidget {
  final double rpm;

  const _RPMMeter({required this.rpm});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RPMMeterPainter(rpm: rpm),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'RPM',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade400,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              rpm.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _getRPMColor(rpm),
                shadows: [
                  Shadow(
                    color: _getRPMColor(rpm).withOpacity(0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRPMColor(double rpm) {
    if (rpm < 2000) return Colors.green;
    if (rpm < 4000) return Colors.yellow;
    if (rpm < 6000) return Colors.orange;
    return Colors.red;
  }
}

class _RPMMeterPainter extends CustomPainter {
  final double rpm;

  _RPMMeterPainter({required this.rpm});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.4;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    
    // Arka plan yayı
    paint.color = Colors.grey.shade800;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5,
      false,
      paint,
    );
    
    // RPM yayı
    final rpmPercent = (rpm / 8000).clamp(0.0, 1.0);
    paint.color = _getRPMColor(rpm);
    paint.shader = LinearGradient(
      colors: [
        _getRPMColor(rpm),
        _getRPMColor(rpm).withOpacity(0.3),
      ],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5 * rpmPercent,
      false,
      paint,
    );
    
    // İşaretler
    paint.shader = null;
    paint.color = Colors.white;
    paint.strokeWidth = 2;
    
    for (int i = 0; i <= 8; i++) {
      final angle = -math.pi * 0.75 + (math.pi * 1.5 * i / 8);
      final start = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final end = Offset(
        center.dx + (radius + 15) * math.cos(angle),
        center.dy + (radius + 15) * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  Color _getRPMColor(double rpm) {
    if (rpm < 2000) return Colors.green;
    if (rpm < 4000) return Colors.yellow;
    if (rpm < 6000) return Colors.orange;
    return Colors.red;
  }

  @override
  bool shouldRepaint(_RPMMeterPainter oldDelegate) => oldDelegate.rpm != rpm;
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
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
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
