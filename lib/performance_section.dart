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

  @override
  Widget build(BuildContext context) {
    final percentage = ((_animatedValue - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
    final isHighValue = percentage > 0.7;
    final pulseGlow = 0.4 + (math.sin(_pulseController.value * 2 * math.pi) * 0.3);
    
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
              color: widget.color.withOpacity(isHighValue ? pulseGlow : 0.5),
              width: isHighValue ? 2.5 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(pulseGlow * (isHighValue ? 1.2 : 0.8)),
                blurRadius: isHighValue ? 25 : 15,
                spreadRadius: isHighValue ? 5 : 3,
              ),
              if (isHighValue)
                BoxShadow(
                  color: widget.color.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 8,
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
                      color: widget.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 16,
                      color: widget.color,
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
                            color: widget.color.withOpacity(0.8),
                            blurRadius: 8,
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
                    color: widget.color,
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
                            color: widget.color,
                            fontFeatures: [FontFeature.tabularFigures()],
                            shadows: [
                              Shadow(
                                color: widget.color.withOpacity(0.9),
                                blurRadius: 20,
                              ),
                              Shadow(
                                color: widget.color.withOpacity(0.5),
                                blurRadius: 35,
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
                                widget.color,
                                widget.color.withOpacity(0.6),
                                widget.color,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: widget.color.withOpacity(0.9),
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

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.35;
    
    final percentage = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final sweepAngle = math.pi * 2 * percentage;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    
    // Arka plan yayı
    paint.color = Colors.black.withOpacity(0.8);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2,
      false,
      paint,
    );
    
    // Değer yayı - canlı gradient
    final pulseGlow = 0.5 + (math.sin(pulseValue * 2 * math.pi) * 0.3);
    paint.shader = LinearGradient(
      colors: [
        color,
        color.withOpacity(0.7),
        color,
      ],
      stops: [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    if (isHighValue) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 6 * pulseGlow);
    }
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      paint,
    );
    
    paint.maskFilter = null;
    
    // İşaretler
    paint.shader = null;
    paint.color = Colors.white.withOpacity(0.6);
    paint.strokeWidth = 2;
    
    for (int i = 0; i <= 8; i++) {
      final angle = -math.pi / 2 + (math.pi * 2 * i / 8);
      final start = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final end = Offset(
        center.dx + (radius + 12) * math.cos(angle),
        center.dy + (radius + 12) * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
    
    // İğne
    final needleAngle = -math.pi / 2 + sweepAngle;
    final needleLength = radius * 0.8;
    final needleTip = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );
    
    // İğne gölgesi
    final needleShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..strokeWidth = 5
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawLine(center, needleTip, needleShadowPaint);
    
    // İğne
    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleTip, needlePaint);
    
    // İğne ucu
    final tipPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    tipPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(needleTip, 5, tipPaint);
    canvas.drawCircle(needleTip, 3, Paint()..color = Colors.white);
    
    // Merkez nokta
    canvas.drawCircle(center, 6, Paint()..color = Colors.white);
    canvas.drawCircle(center, 4, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(_RaceGaugePainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.pulseValue != pulseValue ||
      oldDelegate.isHighValue != isHighValue;
}
