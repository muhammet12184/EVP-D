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
  final double fuelConsumption; // Yakıt tüketimi (L/h) - PID'den gelecek

  const EngineSection({
    super.key,
    required this.rpm,
    required this.engineTemp,
    required this.boost,
    required this.throttle,
    required this.engineLoad,
    required this.fuelAirRatio,
    required this.transmissionTemp,
    this.fuelConsumption = 0.0, // Varsayılan değer, PID bağlantısı yapıldığında güncellenecek
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
                'MOTOR',
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
          
          // RPM Göstergesi
          Expanded(
            flex: 3,
            child: _RPMMeter(rpm: rpm),
          ),
          
          const SizedBox(height: 15),
          
          // Alt Metrikler
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(child: _MetricCard(
                  title: 'HARARET',
                  value: engineTemp,
                  unit: '°C',
                  min: 60,
                  max: 120,
                  icon: Icons.thermostat,
                )),
                const SizedBox(width: 8),
                Expanded(child: _MetricCard(
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
                Expanded(child: _MetricCard(
                  title: 'GAZ KELEBEĞİ',
                  value: throttle,
                  unit: '%',
                  min: 0,
                  max: 100,
                  icon: Icons.trending_up,
                )),
                const SizedBox(width: 8),
                Expanded(child: _MetricCard(
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
                Expanded(child: _MetricCard(
                  title: 'YAKIT TÜKETİMİ',
                  value: fuelConsumption,
                  unit: 'L/h',
                  min: 0,
                  max: 20,
                  icon: Icons.local_gas_station,
                  highlightColor: fuelConsumption > 0.0 ? Colors.orange : Colors.grey,
                )),
                const SizedBox(width: 8),
                Expanded(child: _MetricCard(
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

class _RPMMeter extends StatelessWidget {
  final double rpm;

  const _RPMMeter({required this.rpm});

  Color _getRPMColor(double rpm) {
    if (rpm < 2000) return Colors.green.shade400;
    if (rpm < 4000) return Colors.yellow.shade400;
    if (rpm < 6000) return Colors.orange.shade400;
    return Colors.red.shade400;
  }

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
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              rpm.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: _getRPMColor(rpm),
                shadows: [
                  Shadow(
                    color: _getRPMColor(rpm).withOpacity(0.8),
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
}

class _RPMMeterPainter extends CustomPainter {
  final double rpm;

  _RPMMeterPainter({required this.rpm});

  Color _getRPMColor(double rpm) {
    if (rpm < 2000) return Colors.green.shade400;
    if (rpm < 4000) return Colors.yellow.shade400;
    if (rpm < 6000) return Colors.orange.shade400;
    return Colors.red.shade400;
  }

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
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5 * rpmPercent,
      false,
      paint,
    );
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
  final IconData icon;
  final Color? highlightColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.icon,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final color = highlightColor ?? _getColorForPercentage(percentage);
    
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value.toStringAsFixed(value < 1.0 ? 2 : 1),
                  style: TextStyle(
                    fontSize: 24,
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
                    fontSize: 12,
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

  Color _getColorForPercentage(double percentage) {
    if (percentage < 0.3) return Colors.green;
    if (percentage < 0.6) return Colors.yellow;
    if (percentage < 0.8) return Colors.orange;
    return Colors.red;
  }
}
