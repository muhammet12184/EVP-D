import 'package:flutter/material.dart';
import 'dart:math' as math;

class PerformanceSection extends StatelessWidget {
  final double turboPressure;
  final double o2Sensor;
  final double afr;
  final double batteryVoltage;

  const PerformanceSection({
    super.key,
    required this.turboPressure,
    required this.o2Sensor,
    required this.afr,
    required this.batteryVoltage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            Colors.black,
            Color(0xFF0A0A0A),
            Colors.black,
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Başlık
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.speed,
                  color: Colors.yellow.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'PERFORMANS TESTLERİ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade400,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      color: Colors.orange.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 2x2 Grid - Yarış tipi göstergeler
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _RaceGauge(
                          title: 'TURBO BASINCI',
                          value: turboPressure,
                          unit: 'bar',
                          min: 0,
                          max: 2.5,
                          color: Colors.red.shade400,
                          icon: Icons.air,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _RaceGauge(
                          title: 'O2 SENSÖR',
                          value: o2Sensor,
                          unit: 'V',
                          min: 0,
                          max: 1,
                          color: Colors.green.shade400,
                          icon: Icons.sensors,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _RaceGauge(
                          title: 'AFR',
                          value: afr,
                          unit: ':1',
                          min: 10,
                          max: 20,
                          color: Colors.blue.shade400,
                          icon: Icons.air,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _RaceGauge(
                          title: 'AKÜ VOLTAJI',
                          value: batteryVoltage,
                          unit: 'V',
                          min: 10,
                          max: 15,
                          color: Colors.yellow.shade400,
                          icon: Icons.battery_charging_full,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RaceGauge extends StatefulWidget {
  final String title;
  final double value;
  final String unit;
  final double min;
  final double max;
  final Color color;
  final IconData icon;

  const _RaceGauge({
    required this.title,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.color,
    required this.icon,
  });

  @override
  State<_RaceGauge> createState() => _RaceGaugeState();
}

class _RaceGaugeState extends State<_RaceGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  double _animatedValue = 0;

  @override
  void initState() {
    super.initState();
    _animatedValue = widget.value;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void didUpdateWidget(_RaceGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animateValue();
    }
  }

  void _animateValue() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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
    _rotationController.dispose();
    super.dispose();
  }

  Color _getDynamicColor() {
    final percentage = ((_animatedValue - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
    
    if (widget.color == Colors.red.shade400) {
      if (percentage < 0.5) return Colors.green.shade400;
      if (percentage < 0.7) return Colors.yellow.shade400;
      if (percentage < 0.9) return Colors.orange.shade400;
      return Colors.red.shade400;
    } else if (widget.color == Colors.green.shade400) {
      if (percentage < 0.3) return Colors.green.shade300;
      if (percentage < 0.6) return Colors.green.shade400;
      if (percentage < 0.8) return Colors.cyan.shade400;
      return Colors.blue.shade400;
    } else if (widget.color == Colors.blue.shade400) {
      if (percentage < 0.3) return Colors.blue.shade300;
      if (percentage < 0.5) return Colors.blue.shade400;
      if (percentage < 0.7) return Colors.purple.shade400;
      return Colors.red.shade400;
    } else {
      if (percentage < 0.3) return Colors.red.shade400;
      if (percentage < 0.5) return Colors.orange.shade400;
      if (percentage < 0.7) return Colors.yellow.shade400;
      return Colors.green.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = ((_animatedValue - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
    final isHighValue = percentage > 0.7;
    final pulseGlow = 0.4 + (math.sin(_pulseController.value * 2 * math.pi) * 0.3);
    final dynamicColor = _getDynamicColor();
    
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _rotationController]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.black,
                Color(0xFF1A0000),
                Colors.black,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: dynamicColor.withOpacity(isHighValue ? pulseGlow : 0.6),
              width: isHighValue ? 3 : 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: dynamicColor.withOpacity(pulseGlow * (isHighValue ? 1.5 : 1.0)),
                blurRadius: isHighValue ? 30 : 20,
                spreadRadius: isHighValue ? 6 : 4,
              ),
              BoxShadow(
                color: dynamicColor.withOpacity(0.5),
                blurRadius: isHighValue ? 50 : 30,
                spreadRadius: isHighValue ? 10 : 6,
              ),
              if (isHighValue)
                BoxShadow(
                  color: dynamicColor.withOpacity(0.3),
                  blurRadius: 70,
                  spreadRadius: 15,
                ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Başlık ve ikon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          dynamicColor.withOpacity(0.4),
                          dynamicColor.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: dynamicColor.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      size: 16,
                      color: dynamicColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: dynamicColor.withOpacity(0.9),
                            blurRadius: 10,
                          ),
                          Shadow(
                            color: dynamicColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Dairesel gösterge
              Expanded(
                child: CustomPaint(
                  painter: _RaceGaugePainter(
                    value: _animatedValue,
                    min: widget.min,
                    max: widget.max,
                    color: dynamicColor,
                    pulseValue: _pulseController.value,
                    isHighValue: isHighValue,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: dynamicColor,
                            fontFeatures: [FontFeature.tabularFigures()],
                            shadows: [
                              Shadow(
                                color: dynamicColor.withOpacity(0.9),
                                blurRadius: 25,
                              ),
                              Shadow(
                                color: dynamicColor.withOpacity(0.6),
                                blurRadius: 40,
                              ),
                              Shadow(
                                color: Colors.black,
                                blurRadius: 10,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            _animatedValue.toStringAsFixed(2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.unit,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Alt çubuk gösterge
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(3),
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
                                dynamicColor,
                                dynamicColor.withOpacity(0.8),
                                dynamicColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: dynamicColor.withOpacity(0.9),
                                blurRadius: 12,
                                spreadRadius: 3,
                              ),
                              BoxShadow(
                                color: dynamicColor.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
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
                                  Colors.white.withOpacity(0.4),
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

class _RaceGaugePainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final Color color;
  final double pulseValue;
  final bool isHighValue;

  _RaceGaugePainter({
    required this.value,
    required this.min,
    required this.max,
    required this.color,
    required this.pulseValue,
    required this.isHighValue,
  });

  Color _getDynamicColor() {
    final percentage = ((value - min) / (max - min)).clamp(0.0, 1.0);
    
    // Her gösterge için özel renk geçişleri
    if (color == Colors.red.shade400) {
      // Turbo Basıncı - Yeşilden kırmızıya
      if (percentage < 0.5) return Colors.green.shade400;
      if (percentage < 0.7) return Colors.yellow.shade400;
      if (percentage < 0.9) return Colors.orange.shade400;
      return Colors.red.shade400;
    } else if (color == Colors.green.shade400) {
      // O2 Sensör - Yeşilden maviye
      if (percentage < 0.3) return Colors.green.shade300;
      if (percentage < 0.6) return Colors.green.shade400;
      if (percentage < 0.8) return Colors.cyan.shade400;
      return Colors.blue.shade400;
    } else if (color == Colors.blue.shade400) {
      // AFR - Maviden kırmızıya
      if (percentage < 0.3) return Colors.blue.shade300;
      if (percentage < 0.5) return Colors.blue.shade400;
      if (percentage < 0.7) return Colors.purple.shade400;
      return Colors.red.shade400;
    } else {
      // Akü Voltajı - Kırmızıdan yeşile
      if (percentage < 0.3) return Colors.red.shade400;
      if (percentage < 0.5) return Colors.orange.shade400;
      if (percentage < 0.7) return Colors.yellow.shade400;
      return Colors.green.shade400;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.35;
    
    final percentage = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final sweepAngle = math.pi * 2 * percentage;
    final dynamicColor = _getDynamicColor();
    final pulseGlow = 0.5 + (math.sin(pulseValue * 2 * math.pi) * 0.3);
    
    // Dış çerçeve - neon efekt
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = dynamicColor.withOpacity(0.4);
    canvas.drawCircle(center, radius + 15, outerPaint);
    
    // İç çerçeve
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = dynamicColor.withOpacity(0.3);
    canvas.drawCircle(center, radius + 8, innerPaint);
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    
    // Arka plan yayı (siyah)
    paint.color = Colors.black.withOpacity(0.9);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2,
      false,
      paint,
    );
    
    // Değer yayı - canlı çok renkli gradient
    List<Color> gradientColors;
    if (color == Colors.red.shade400) {
      // Turbo - Yeşil → Sarı → Turuncu → Kırmızı
      gradientColors = [
        Colors.green.shade400,
        Colors.green.shade300,
        Colors.yellow.shade400,
        Colors.orange.shade400,
        Colors.red.shade400,
        Colors.red.shade600,
      ];
    } else if (color == Colors.green.shade400) {
      // O2 - Koyu yeşil → Açık yeşil → Cyan → Mavi
      gradientColors = [
        Colors.green.shade700,
        Colors.green.shade400,
        Colors.green.shade300,
        Colors.cyan.shade400,
        Colors.blue.shade400,
      ];
    } else if (color == Colors.blue.shade400) {
      // AFR - Mavi → Mor → Pembe → Kırmızı
      gradientColors = [
        Colors.blue.shade300,
        Colors.blue.shade400,
        Colors.purple.shade400,
        Colors.pink.shade400,
        Colors.red.shade400,
      ];
    } else {
      // Akü - Kırmızı → Turuncu → Sarı → Yeşil
      gradientColors = [
        Colors.red.shade400,
        Colors.orange.shade400,
        Colors.yellow.shade400,
        Colors.yellow.shade300,
        Colors.green.shade400,
      ];
    }
    
    paint.shader = LinearGradient(
      colors: gradientColors,
      stops: List.generate(gradientColors.length, (i) => i / (gradientColors.length - 1)),
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    if (isHighValue) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * pulseGlow);
    }
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      paint,
    );
    
    paint.maskFilter = null;
    
    // İşaretler ve sayılar
    paint.shader = null;
    paint.color = Colors.white.withOpacity(0.7);
    paint.strokeWidth = 2;
    
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    
    // Ana işaretler
    for (int i = 0; i <= 8; i++) {
      final angle = -math.pi / 2 + (math.pi * 2 * i / 8);
      final start = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final end = Offset(
        center.dx + (radius + 15) * math.cos(angle),
        center.dy + (radius + 15) * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
      
      // Sayılar
      final valueAtMark = min + ((max - min) * i / 8);
      final textOffset = Offset(
        center.dx + (radius + 25) * math.cos(angle) - 10,
        center.dy + (radius + 25) * math.sin(angle) - 6,
      );
      textPainter.text = TextSpan(
        text: valueAtMark.toStringAsFixed(1),
        style: textStyle.copyWith(fontSize: 9),
      );
      textPainter.layout();
      textPainter.paint(canvas, textOffset);
      
      // Kısa işaretler
      if (i < 8) {
        final midAngle = angle + (math.pi * 2 / 16);
        final midStart = Offset(
          center.dx + radius * math.cos(midAngle),
          center.dy + radius * math.sin(midAngle),
        );
        final midEnd = Offset(
          center.dx + (radius + 8) * math.cos(midAngle),
          center.dy + (radius + 8) * math.sin(midAngle),
        );
        paint.strokeWidth = 1;
        paint.color = Colors.white.withOpacity(0.5);
        canvas.drawLine(midStart, midEnd, paint);
        paint.strokeWidth = 2;
        paint.color = Colors.white.withOpacity(0.7);
      }
    }
    
    // Yüksek değer uyarı bölgesi
    if (isHighValue) {
      final warningAngle = -math.pi / 2 + (math.pi * 2 * 0.7);
      final warningPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 + (math.sin(pulseValue * 2 * math.pi) * 2)
        ..color = Colors.yellow.shade400;
      warningPaint.maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        5 + (math.sin(pulseValue * 2 * math.pi) * 3),
      );
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius + 3),
        warningAngle,
        math.pi * 2 * 0.3,
        false,
        warningPaint,
      );
    }
    
    // İğne - gerçekçi
    final needleAngle = -math.pi / 2 + sweepAngle;
    final needleLength = radius * 0.85;
    final needleTip = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );
    
    // İğne gölgesi
    final needleShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..strokeWidth = 6
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawLine(center, needleTip, needleShadowPaint);
    
    // İğne çizgisi - kalın ve parlak
    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleTip, needlePaint);
    
    // İğne ucu - parlak ve renkli
    final tipGlowPaint = Paint()
      ..color = dynamicColor
      ..style = PaintingStyle.fill;
    tipGlowPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(needleTip, 8, tipGlowPaint);
    
    final tipPaint = Paint()
      ..color = dynamicColor
      ..style = PaintingStyle.fill;
    tipPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(needleTip, 6, tipPaint);
    canvas.drawCircle(needleTip, 4, Paint()..color = Colors.white);
    
    // Merkez nokta - parlak
    final centerGlowPaint = Paint()
      ..color = dynamicColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    centerGlowPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, 10, centerGlowPaint);
    
    canvas.drawCircle(center, 8, Paint()..color = Colors.white);
    canvas.drawCircle(center, 6, Paint()..color = Colors.black);
    canvas.drawCircle(center, 3, Paint()..color = dynamicColor);
  }

  @override
  bool shouldRepaint(_RaceGaugePainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.pulseValue != pulseValue ||
      oldDelegate.isHighValue != isHighValue;
}
