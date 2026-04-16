import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/mock_obd_service.dart';

class DashboardScreen extends StatefulWidget {
  final MockOBDService obdService;
  const DashboardScreen({super.key, required this.obdService});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  StreamSubscription? _sub;
  Map<String, SensorData> _sensors = {};

  @override
  void initState() {
    super.initState();
    _sensors = widget.obdService.currentSensors;
    _sub = widget.obdService.sensorStream.listen((data) {
      if (mounted) setState(() => _sensors = data);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ids = widget.obdService.dashboardSensorIds;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // Row 1: 3 large gauges (HIZ, RPM, GAZ)
              _buildGaugeRow(ids.sublist(0, 3), constraints.maxWidth, isLarge: true),
              const SizedBox(height: 6),
              // Row 2: 4 medium gauges
              _buildGaugeRow(ids.sublist(3, 7), constraints.maxWidth),
              const SizedBox(height: 6),
              // Row 3: 4 medium gauges
              _buildGaugeRow(ids.sublist(7, 11), constraints.maxWidth),
              const SizedBox(height: 6),
              // Row 4: 3 medium gauges
              _buildGaugeRow(ids.sublist(11, 14), constraints.maxWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGaugeRow(List<String> sensorIds, double maxWidth, {bool isLarge = false}) {
    int count = sensorIds.length;
    double spacing = 6;
    double totalSpacing = spacing * (count - 1);
    double gaugeSize = (maxWidth - 16 - totalSpacing) / count;
    if (isLarge) gaugeSize = gaugeSize.clamp(0, 160);
    if (!isLarge) gaugeSize = gaugeSize.clamp(0, 120);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: sensorIds.map((id) {
        final sensor = _sensors[id];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: SizedBox(
            width: gaugeSize,
            height: gaugeSize,
            child: _CircularGauge(
              sensor: sensor,
              size: gaugeSize,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CircularGauge extends StatelessWidget {
  final SensorData? sensor;
  final double size;

  const _CircularGauge({required this.sensor, required this.size});

  @override
  Widget build(BuildContext context) {
    final s = sensor;
    final hasVal = s != null && s.hasValue;
    final normalized = hasVal ? s.normalizedValue : 0.0;

    // Determine value color
    Color valueColor = const Color(0xFFFFFFFF);
    if (s != null && hasVal) {
      if (s.id == 'voltage' && s.value! > 15.0) {
        valueColor = const Color(0xFFFF3333);
      } else if (s.id == 'coolant_temp' && s.value! > 100) {
        valueColor = const Color(0xFFFF3333);
      } else if (s.id == 'exhaust_temp' && s.value! > 700) {
        valueColor = const Color(0xFFFF3333);
      } else if (normalized > 0.85) {
        valueColor = const Color(0xFFFF3333);
      }
    }

    return CustomPaint(
      painter: _GaugePainter(
        progress: normalized,
        isActive: hasVal,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s?.name ?? '---',
              style: TextStyle(
                fontSize: size * 0.11,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: size * 0.02),
            Text(
              s?.displayValue ?? '---',
              style: TextStyle(
                fontSize: size * 0.28,
                fontWeight: FontWeight.bold,
                color: valueColor,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            Text(
              s?.unit ?? '',
              style: TextStyle(
                fontSize: size * 0.1,
                color: Colors.white.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final bool isActive;

  _GaugePainter({required this.progress, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    final strokeWidth = radius * 0.12;

    // Outer ring glow
    final glowPaint = Paint()
      ..color = const Color(0xFF1A4A6B).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(center, radius, glowPaint);

    // Background circle
    final bgPaint = Paint()
      ..color = const Color(0xFF1A2A3A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Outer ring
    final ringPaint = Paint()
      ..color = const Color(0xFF2A4A5A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, ringPaint);

    // Tick marks
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1;

    for (int i = 0; i < 40; i++) {
      double angle = -math.pi * 0.75 + (i / 39) * math.pi * 1.5;
      double innerR = radius - strokeWidth - 2;
      double outerR = radius - strokeWidth / 2;
      if (i % 5 == 0) {
        tickPaint.strokeWidth = 1.5;
        innerR = radius - strokeWidth - 5;
      } else {
        tickPaint.strokeWidth = 0.8;
        innerR = radius - strokeWidth - 3;
      }
      canvas.drawLine(
        Offset(center.dx + innerR * math.cos(angle), center.dy + innerR * math.sin(angle)),
        Offset(center.dx + outerR * math.cos(angle), center.dy + outerR * math.sin(angle)),
        tickPaint,
      );
    }

    if (!isActive) return;

    // Progress arc
    const startAngle = -math.pi * 0.75;
    final sweepAngle = progress * math.pi * 1.5;

    Color arcColor;
    if (progress < 0.6) {
      arcColor = const Color(0xFF00AAFF);
    } else if (progress < 0.8) {
      arcColor = const Color(0xFFFFAA00);
    } else {
      arcColor = const Color(0xFFFF3333);
    }

    // Arc glow
    final arcGlow = Paint()
      ..color = arcColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 2
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      arcGlow,
    );

    // Main arc
    final arcPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Needle indicator dot
    double needleAngle = startAngle + sweepAngle;
    double dotRadius = 3;
    Offset dotPos = Offset(
      center.dx + (radius - strokeWidth / 2) * math.cos(needleAngle),
      center.dy + (radius - strokeWidth / 2) * math.sin(needleAngle),
    );

    canvas.drawCircle(
      dotPos,
      dotRadius,
      Paint()
        ..color = Colors.white
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
    canvas.drawCircle(dotPos, dotRadius - 1, Paint()..color = arcColor);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isActive != isActive;
  }
}
