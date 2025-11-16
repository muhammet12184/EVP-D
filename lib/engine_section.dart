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

class _FerrariRPMMeter extends StatefulWidget {
  final double rpm;

  const _FerrariRPMMeter({required this.rpm});

  @override
  State<_FerrariRPMMeter> createState() => _FerrariRPMMeterState();
}

class _FerrariRPMMeterState extends State<_FerrariRPMMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  double _animatedRPM = 0;

  @override
  void initState() {
    super.initState();
    _animatedRPM = widget.rpm;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void didUpdateWidget(_FerrariRPMMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rpm != widget.rpm) {
      _animateRPM();
    }
  }

  void _animateRPM() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    final animation = Tween<double>(
      begin: _animatedRPM,
      end: widget.rpm,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));

    animation.addListener(() {
      setState(() {
        _animatedRPM = animation.value;
      });
    });

    controller.forward().then((_) => controller.dispose());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getRPMColor(double rpm) {
    if (rpm < 2000) return Colors.green.shade400;
    if (rpm < 4000) return Colors.yellow.shade400;
    if (rpm < 6000) return Colors.orange.shade400;
    if (rpm < 7000) return Colors.red.shade400;
    return EngineSection.ferrariRed;
  }

  @override
  Widget build(BuildContext context) {
    final rpmColor = _getRPMColor(_animatedRPM);
    final isRedZone = _animatedRPM > 7000;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = (_pulseController.value * 2 * math.pi);
        final glowIntensity = isRedZone
            ? 0.5 + (math.sin(pulseValue) * 0.3)
            : 0.3;

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: rpmColor.withOpacity(glowIntensity),
                blurRadius: 40,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: rpmColor.withOpacity(glowIntensity * 0.5),
                blurRadius: 60,
                spreadRadius: 20,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _FerrariRPMMeterPainter(
              rpm: _animatedRPM,
              pulseValue: _pulseController.value,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'RPM',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 3,
                      fontWeight: FontWeight.w300,
                      shadows: [
                        Shadow(
                          color: rpmColor.withOpacity(0.8),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: rpmColor,
                      fontFeatures: [FontFeature.tabularFigures()],
                      shadows: [
                        Shadow(
                          color: rpmColor.withOpacity(0.9),
                          blurRadius: 30,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          color: rpmColor.withOpacity(0.6),
                          blurRadius: 50,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.black,
                          blurRadius: 15,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _animatedRPM.toStringAsFixed(0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 80,
                    height: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          rpmColor,
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: rpmColor.withOpacity(0.8),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FerrariRPMMeterPainter extends CustomPainter {
  final double rpm;
  final double pulseValue;

  _FerrariRPMMeterPainter({
    required this.rpm,
    this.pulseValue = 0,
  });

  Color _getRPMColor(double rpm) {
    if (rpm < 2000) return Colors.green.shade400;
    if (rpm < 4000) return Colors.yellow.shade400;
    if (rpm < 6000) return Colors.orange.shade400;
    if (rpm < 7000) return Colors.red.shade400;
    return EngineSection.ferrariRed;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.45;
    
    // Dış çerçeve - neon efekt
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.white.withOpacity(0.3);
    
    canvas.drawCircle(center, radius + 20, outerPaint);
    
    // İç çerçeve - kırmızı glow
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = EngineSection.ferrariRed.withOpacity(0.5);
    
    canvas.drawCircle(center, radius + 10, innerPaint);
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    // Arka plan yayı (siyah)
    paint.color = Colors.black.withOpacity(0.9);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.8,
      math.pi * 1.6,
      false,
      paint,
    );
    
    // RPM yayı - canlı renkler
    final rpmPercent = (rpm / 8500).clamp(0.0, 1.0);
    final sweepAngle = math.pi * 1.6 * rpmPercent;
    final rpmColor = _getRPMColor(rpm);
    final isRedZone = rpmPercent > 0.7;
    
    // Canlı gradient
    if (isRedZone) {
      final pulseGlow = 0.5 + (math.sin(pulseValue * 2 * math.pi) * 0.3);
      paint.shader = LinearGradient(
        colors: [
          Colors.yellow.shade400,
          Colors.orange.shade400,
          EngineSection.ferrariRed,
          EngineSection.ferrariDarkRed,
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * pulseGlow);
    } else {
      paint.shader = LinearGradient(
        colors: [
          Colors.green.shade400,
          Colors.green.shade300,
          Colors.yellow.shade400,
          Colors.orange.shade400,
          EngineSection.ferrariRed,
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    }
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.8,
      sweepAngle,
      false,
      paint,
    );
    
    paint.maskFilter = null;
    
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
    
    // Kırmızı bölge işareti (7000+ RPM) - pulse efekti
    final redZoneAngle = -math.pi * 0.8 + (math.pi * 1.6 * 0.7);
    final redZonePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 + (math.sin(pulseValue * 2 * math.pi) * 2)
      ..color = Colors.yellow.shade400;
    redZonePaint.maskFilter = MaskFilter.blur(
      BlurStyle.normal,
      5 + (math.sin(pulseValue * 2 * math.pi) * 3),
    );
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 5),
      redZoneAngle,
      math.pi * 1.6 * 0.3,
      false,
      redZonePaint,
    );
    
    // RPM İğnesi (gerçekçi)
    final needleAngle = -math.pi * 0.8 + (math.pi * 1.6 * rpmPercent);
    final needlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;
    
    final needleLength = radius * 0.85;
    final needleTip = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );
    
    // İğne gölgesi
    final needleShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);
    
    canvas.drawLine(
      center,
      needleTip,
      needleShadowPaint,
    );
    
    // İğne çizgisi
    canvas.drawLine(
      center,
      needleTip,
      needlePaint..strokeWidth = 4,
    );
    
    // İğne ucu - parlak nokta
    final tipPaint = Paint()
      ..color = rpmColor
      ..style = PaintingStyle.fill;
    tipPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(needleTip, 6, tipPaint);
    canvas.drawCircle(needleTip, 4, Paint()..color = Colors.white);
    
    // Merkez nokta
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, centerPaint);
    canvas.drawCircle(center, 6, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(_FerrariRPMMeterPainter oldDelegate) =>
      oldDelegate.rpm != rpm || oldDelegate.pulseValue != pulseValue;
}

class _FerrariMetricCard extends StatefulWidget {
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
  State<_FerrariMetricCard> createState() => _FerrariMetricCardState();
}

class _FerrariMetricCardState extends State<_FerrariMetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  double _animatedValue = 0;

  @override
  void initState() {
    super.initState();
    _animatedValue = widget.value;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_FerrariMetricCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animateValue();
    }
  }

  void _animateValue() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    final animation = Tween<double>(
      begin: _animatedValue,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));

    animation.addListener(() {
      setState(() {
        _animatedValue = animation.value;
      });
    });

    controller.forward().then((_) => controller.dispose());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = ((_animatedValue - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
    final isHighValue = percentage > 0.7;
    final pulseGlow = 0.3 + (math.sin(_pulseController.value * 2 * math.pi) * 0.2);
    
    Color cardColor;
    if (percentage < 0.3) {
      cardColor = Colors.green.shade400;
    } else if (percentage < 0.6) {
      cardColor = Colors.yellow.shade400;
    } else if (percentage < 0.8) {
      cardColor = Colors.orange.shade400;
    } else {
      cardColor = EngineSection.ferrariRed;
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
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
              color: cardColor.withOpacity(isHighValue ? 0.8 : 0.3),
              width: isHighValue ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(pulseGlow * (isHighValue ? 1.5 : 0.8)),
                blurRadius: isHighValue ? 15 : 8,
                spreadRadius: isHighValue ? 3 : 1,
              ),
              if (isHighValue)
                BoxShadow(
                  color: cardColor.withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: 5,
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.icon,
                      size: 16,
                      color: cardColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w300,
                      shadows: [
                        Shadow(
                          color: cardColor.withOpacity(0.6),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: cardColor,
                      fontFeatures: [FontFeature.tabularFigures()],
                      shadows: [
                        Shadow(
                          color: cardColor.withOpacity(0.8),
                          blurRadius: 15,
                        ),
                        Shadow(
                          color: cardColor.withOpacity(0.4),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    child: Text(
                      _animatedValue.toStringAsFixed(1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3, left: 3),
                    child: Text(
                      widget.unit,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.6),
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
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: percentage,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                cardColor,
                                cardColor.withOpacity(0.7),
                                cardColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: cardColor.withOpacity(0.8),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isHighValue)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
