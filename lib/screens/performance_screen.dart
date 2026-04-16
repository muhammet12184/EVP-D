import 'dart:async';
import 'package:flutter/material.dart';
import '../services/mock_obd_service.dart';

enum PerformanceMode { mode0_100, mode0_400, mode0_800 }

class PerformanceScreen extends StatefulWidget {
  final MockOBDService obdService;
  const PerformanceScreen({super.key, required this.obdService});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  StreamSubscription? _sub;
  PerformanceMode _mode = PerformanceMode.mode0_100;
  bool _isRunning = false;
  bool _isFinished = false;
  DateTime? _startTime;
  double _elapsedSeconds = 0;
  double _currentSpeed = 0;
  double _coolantTemp = 0;
  double _mafValue = 0;
  double _afrValue = 0;
  Timer? _displayTimer;

  // History for graph
  final List<_SpeedPoint> _speedHistory = [];

  double get _targetSpeed {
    switch (_mode) {
      case PerformanceMode.mode0_100: return 100;
      case PerformanceMode.mode0_400: return 400;
      case PerformanceMode.mode0_800: return 800;
    }
  }

  String get _targetLabel {
    switch (_mode) {
      case PerformanceMode.mode0_100: return '0-100';
      case PerformanceMode.mode0_400: return '0-400';
      case PerformanceMode.mode0_800: return '0-800';
    }
  }

  String get _targetUnit {
    switch (_mode) {
      case PerformanceMode.mode0_100: return 'km/h';
      case PerformanceMode.mode0_400: return 'm';
      case PerformanceMode.mode0_800: return 'm';
    }
  }

  @override
  void initState() {
    super.initState();
    _sub = widget.obdService.sensorStream.listen((data) {
      if (!mounted) return;
      final speed = data['speed']?.value ?? 0;
      final coolant = data['coolant_temp']?.value ?? 0;
      final maf = data['maf']?.value ?? 0;
      final afr = data['afr']?.value ?? 0;

      setState(() {
        _currentSpeed = speed;
        _coolantTemp = coolant;
        _mafValue = maf;
        _afrValue = afr;
      });

      if (_isRunning && !_isFinished) {
        _elapsedSeconds = DateTime.now().difference(_startTime!).inMilliseconds / 1000;
        _speedHistory.add(_SpeedPoint(time: _elapsedSeconds, speed: speed));

        // Check completion
        if (_mode == PerformanceMode.mode0_100 && speed >= 100) {
          _finish();
        }
        // For distance modes, we'd calculate distance from speed integration
        // Simplified: use time-based approximation
        if (_mode == PerformanceMode.mode0_400 && _elapsedSeconds > 20) {
          _finish();
        }
        if (_mode == PerformanceMode.mode0_800 && _elapsedSeconds > 35) {
          _finish();
        }
      }
    });
  }

  void _startTest() {
    setState(() {
      _isRunning = true;
      _isFinished = false;
      _startTime = DateTime.now();
      _elapsedSeconds = 0;
      _speedHistory.clear();
    });
    _displayTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted && _isRunning) {
        setState(() {
          _elapsedSeconds = DateTime.now().difference(_startTime!).inMilliseconds / 1000;
        });
      }
    });
  }

  void _finish() {
    _isFinished = true;
    _isRunning = false;
    _displayTimer?.cancel();
  }

  void _reset() {
    setState(() {
      _isRunning = false;
      _isFinished = false;
      _elapsedSeconds = 0;
      _speedHistory.clear();
      _displayTimer?.cancel();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _displayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Mode selector buttons
            Row(
              children: [
                _modeButton('0-100', PerformanceMode.mode0_100),
                const SizedBox(width: 8),
                _modeButton('0-400', PerformanceMode.mode0_400),
                const SizedBox(width: 8),
                _modeButton('0-800', PerformanceMode.mode0_800),
                const Spacer(),
                // Reset button
                GestureDetector(
                  onTap: _reset,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF3A6A8A), width: 2),
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF1A3A5A).withOpacity(0.8),
                          const Color(0xFF0D1B2A),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'RESET',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Timer display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A4A5A).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Text(
                    _elapsedSeconds.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'monospace',
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isFinished ? '$_targetLabel tamamlandi' : '$_targetLabel $_targetUnit',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isFinished
                          ? const Color(0xFF00E5AA)
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Start button (when not running)
            if (!_isRunning && !_isFinished)
              GestureDetector(
                onTap: _startTest,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00AAFF), Color(0xFF0066CC)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'BASLA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            // Speed graph area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1B2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2A4A5A).withOpacity(0.3)),
                ),
                child: _speedHistory.isEmpty
                    ? Center(
                        child: Text(
                          'Hiz grafigi burada gorunecek',
                          style: TextStyle(color: Colors.white.withOpacity(0.3)),
                        ),
                      )
                    : CustomPaint(
                        painter: _SpeedGraphPainter(
                          points: _speedHistory,
                          maxSpeed: _mode == PerformanceMode.mode0_100 ? 120 : 250,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            // Bottom info bar: HARARET, MAF, AFR
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B2A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A4A5A).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  _bottomInfoTile(
                    icon: Icons.thermostat,
                    label: 'HARARET',
                    value: '${_coolantTemp.toStringAsFixed(0)} \u00b0C',
                    color: const Color(0xFFFF6600),
                  ),
                  Container(width: 1, height: 48, color: const Color(0xFF2A4A5A).withOpacity(0.3)),
                  _bottomInfoTile(
                    icon: Icons.air,
                    label: 'MAF',
                    value: '${_mafValue.toStringAsFixed(1)} g/s',
                    color: const Color(0xFF00AAFF),
                  ),
                  Container(width: 1, height: 48, color: const Color(0xFF2A4A5A).withOpacity(0.3)),
                  _bottomInfoTile(
                    icon: Icons.speed,
                    label: 'AFR',
                    value: '${_afrValue.toStringAsFixed(1)} \u03bb',
                    color: const Color(0xFF00E5AA),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeButton(String label, PerformanceMode mode) {
    final isActive = _mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!_isRunning) {
            setState(() {
              _mode = mode;
              _reset();
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? const Color(0xFF00AAFF) : const Color(0xFF2A4A5A),
              width: isActive ? 2 : 1,
            ),
            color: isActive
                ? const Color(0xFF00AAFF).withOpacity(0.15)
                : const Color(0xFF0D1B2A),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedPoint {
  final double time;
  final double speed;
  _SpeedPoint({required this.time, required this.speed});
}

class _SpeedGraphPainter extends CustomPainter {
  final List<_SpeedPoint> points;
  final double maxSpeed;

  _SpeedGraphPainter({required this.points, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final pad = 16.0;
    final graphW = size.width - pad * 2;
    final graphH = size.height - pad * 2;

    double maxTime = points.last.time;
    if (maxTime <= 0) maxTime = 1;

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFF2A4A5A).withOpacity(0.3)
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 4; i++) {
      double y = pad + graphH * (1 - i / 4);
      canvas.drawLine(Offset(pad, y), Offset(pad + graphW, y), gridPaint);
    }

    // Speed line
    final linePaint = Paint()
      ..color = const Color(0xFF00AAFF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      double x = pad + (points[i].time / maxTime) * graphW;
      double y = pad + graphH * (1 - (points[i].speed / maxSpeed).clamp(0, 1));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    // Fill under curve
    final fillPath = Path.from(path);
    fillPath.lineTo(pad + (points.last.time / maxTime) * graphW, pad + graphH);
    fillPath.lineTo(pad, pad + graphH);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00AAFF).withOpacity(0.3),
          const Color(0xFF00AAFF).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, pad, size.width, graphH));

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _SpeedGraphPainter oldDelegate) {
    return oldDelegate.points.length != points.length;
  }
}
