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

  // Ferrari kırmızısı
  static const Color ferrariRed = Color(0xFFDC143C);
  static const Color ferrariDarkRed = Color(0xFF8B0000);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            Colors.black,
            Color(0xFF1A0000),
            Colors.black,
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Ferrari Logo/Başlık
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: ferrariRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ferrariRed.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: Colors.yellow.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'FERRARI F430',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ferrariRed,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(
                      color: ferrariRed.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // RPM Göstergesi (Ferrari tarzı klasik tachometer)
          Expanded(
            flex: 3,
            child: _FerrariRPMMeter(rpm: rpm),
          ),
          
          const SizedBox(height: 15),
          
          // Alt Metrikler - Ferrari tarzı analog göstergeler
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(child: _FerrariMetricCard(
                  title: 'HARARET',
                  value: engineTemp,
                  unit: '°C',
                  min: 60,
                  max: 120,
                  icon: Icons.thermostat,
                )),
                const SizedBox(width: 8),
                Expanded(child: _FerrariMetricCard(
                  title: 'BOOST',
                  value: boost * 100,
                  unit: 'bar',
                  min: 0,
                  max: 100,
                  icon: Icons.speed,
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(child: _FerrariMetricCard(
                  title: 'GAZ KELEBEĞİ',
                  value: throttle,
                  unit: '%',
                  min: 0,
                  max: 100,
                  icon: Icons.trending_up,
                )),
                const SizedBox(width: 8),
                Expanded(child: _FerrariMetricCard(
                  title: 'MOTOR YÜKÜ',
                  value: engineLoad,
                  unit: '%',
                  min: 0,
                  max: 100,
                  icon: Icons.power,
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(child: _FerrariMetricCard(
                  title: 'YAKIT/HAVA',
                  value: fuelAirRatio,
                  unit: ':1',
                  min: 10,
                  max: 20,
                  icon: Icons.air,
                )),
                const SizedBox(width: 8),
                Expanded(child: _FerrariMetricCard(
                  title: 'ŞANZIMAN',
                  value: transmissionTemp,
                  unit: '°C',
                  min: 60,
                  max: 100,
                  icon: Icons.settings,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FerrariRPMMeter extends StatelessWidget {
  final double rpm;

  const _FerrariRPMMeter({required this.rpm});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: EngineSection.ferrariRed.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _FerrariRPMMeterPainter(rpm: rpm),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'RPM',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 3,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                rpm.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                  shadows: [
                    Shadow(
                      color: EngineSection.ferrariRed.withOpacity(0.8),
                      blurRadius: 25,
                      offset: Offset(0, 0),
                    ),
                    Shadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      EngineSection.ferrariRed,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FerrariRPMMeterPainter extends CustomPainter {
  final double rpm;

  _FerrariRPMMeterPainter({required this.rpm});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.45;
    
    // Dış çerçeve
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.white.withOpacity(0.2);
    
    canvas.drawCircle(center, radius + 20, outerPaint);
    
    // İç çerçeve
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = EngineSection.ferrariRed.withOpacity(0.3);
    
    canvas.drawCircle(center, radius + 10, innerPaint);
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    
    // Arka plan yayı (siyah)
    paint.color = Colors.black.withOpacity(0.8);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.8,
      math.pi * 1.6,
      false,
      paint,
    );
    
    // RPM yayı (Ferrari kırmızısı)
    final rpmPercent = (rpm / 8500).clamp(0.0, 1.0);
    final sweepAngle = math.pi * 1.6 * rpmPercent;
    
    // Kırmızı bölge (yüksek RPM)
    if (rpmPercent > 0.7) {
      paint.shader = LinearGradient(
        colors: [
          Colors.yellow.shade600,
          EngineSection.ferrariRed,
          EngineSection.ferrariDarkRed,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    } else {
      paint.shader = LinearGradient(
        colors: [
          Colors.green.shade400,
          EngineSection.ferrariRed,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    }
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.8,
      sweepAngle,
      false,
      paint,
    );
    
    // İşaretler ve sayılar
    paint.shader = null;
    paint.color = Colors.white;
    paint.strokeWidth = 2;
    
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    
    // Ana işaretler (her 1000 RPM)
    for (int i = 0; i <= 8; i++) {
      final rpmValue = i * 1000;
      final angle = -math.pi * 0.8 + (math.pi * 1.6 * i / 8);
      
      // Uzun çizgi
      final start = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final end = Offset(
        center.dx + (radius + 20) * math.cos(angle),
        center.dy + (radius + 20) * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
      
      // Sayılar
      final textOffset = Offset(
        center.dx + (radius + 35) * math.cos(angle) - 15,
        center.dy + (radius + 35) * math.sin(angle) - 8,
      );
      textPainter.text = TextSpan(
        text: '${rpmValue ~/ 1000}',
        style: textStyle.copyWith(fontSize: 14),
      );
      textPainter.layout();
      textPainter.paint(canvas, textOffset);
      
      // Kısa işaretler (500 RPM aralıklarla)
      if (i < 8) {
        final midAngle = angle + (math.pi * 1.6 / 16);
        final midStart = Offset(
          center.dx + radius * math.cos(midAngle),
          center.dy + radius * math.sin(midAngle),
        );
        final midEnd = Offset(
          center.dx + (radius + 10) * math.cos(midAngle),
          center.dy + (radius + 10) * math.sin(midAngle),
        );
        paint.strokeWidth = 1;
        paint.color = Colors.white.withOpacity(0.6);
        canvas.drawLine(midStart, midEnd, paint);
        paint.strokeWidth = 2;
        paint.color = Colors.white;
      }
    }
    
    // Kırmızı bölge işareti (7000+ RPM)
    final redZoneAngle = -math.pi * 0.8 + (math.pi * 1.6 * 0.7);
    final redZonePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.yellow.shade600;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 5),
      redZoneAngle,
      math.pi * 1.6 * 0.3,
      false,
      redZonePaint,
    );
  }

  @override
  bool shouldRepaint(_FerrariRPMMeterPainter oldDelegate) => oldDelegate.rpm != rpm;
}

class _FerrariMetricCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final double min;
  final double max;
  final IconData icon;

  const _FerrariMetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final isHighValue = percentage > 0.7;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Color(0xFF1A0000),
            Colors.black,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighValue 
              ? EngineSection.ferrariRed.withOpacity(0.6)
              : Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          if (isHighValue)
            BoxShadow(
              color: EngineSection.ferrariRed.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: EngineSection.ferrariRed.withOpacity(0.8),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isHighValue ? EngineSection.ferrariRed : Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                  shadows: [
                    if (isHighValue)
                      Shadow(
                        color: EngineSection.ferrariRed.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3, left: 3),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                widthFactor: percentage,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isHighValue
                          ? [
                              Colors.yellow.shade600,
                              EngineSection.ferrariRed,
                            ]
                          : [
                              Colors.green.shade400,
                              EngineSection.ferrariRed.withOpacity(0.7),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
