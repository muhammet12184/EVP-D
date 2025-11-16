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

class _BatterySOCMeter extends StatefulWidget {
  final double soc;
  final double health;

  const _BatterySOCMeter({
    required this.soc,
    required this.health,
  });

  @override
  State<_BatterySOCMeter> createState() => _BatterySOCMeterState();
}

class _BatterySOCMeterState extends State<_BatterySOCMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  double _animatedSOC = 0;

  @override
  void initState() {
    super.initState();
    _animatedSOC = widget.soc;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void didUpdateWidget(_BatterySOCMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.soc != widget.soc) {
      _animateSOC();
    }
  }

  void _animateSOC() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    final animation = Tween<double>(
      begin: _animatedSOC,
      end: widget.soc,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));

    animation.addListener(() {
      setState(() {
        _animatedSOC = animation.value;
      });
    });

    controller.forward().then((_) => controller.dispose());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Color _getSOCColor(double soc) {
    if (soc > 70) return Colors.green.shade400;
    if (soc > 40) return Colors.yellow.shade400;
    if (soc > 20) return Colors.orange.shade400;
    return Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final socColor = _getSOCColor(_animatedSOC);
    final isLow = _animatedSOC < 30;
    final pulseGlow = 0.4 + (math.sin(_pulseController.value * 2 * math.pi) * 0.3);
    final glowIntensity = 0.5 + (math.sin(_glowController.value * 2 * math.pi) * 0.3);

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _glowController]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.2,
              colors: [
                Colors.grey.shade900.withOpacity(0.8),
                Colors.black,
                Colors.grey.shade900.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: socColor.withOpacity(glowIntensity),
              width: isLow ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: socColor.withOpacity(pulseGlow),
                blurRadius: isLow ? 30 : 20,
                spreadRadius: isLow ? 5 : 3,
              ),
              BoxShadow(
                color: socColor.withOpacity(0.3),
                blurRadius: 50,
                spreadRadius: 10,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BATARYA',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: socColor.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: socColor,
                      shadows: [
                        Shadow(
                          color: socColor.withOpacity(0.9),
                          blurRadius: 30,
                        ),
                        Shadow(
                          color: socColor.withOpacity(0.6),
                          blurRadius: 50,
                        ),
                      ],
                    ),
                    child: Text(
                      _animatedSOC.toStringAsFixed(0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                    child: Text(
                      '%',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white.withOpacity(0.7),
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
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade700.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: (_animatedSOC / 100).clamp(0.0, 1.0),
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              socColor,
                              socColor.withOpacity(0.8),
                              socColor,
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: socColor.withOpacity(0.9),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: isLow
                            ? Container(
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
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Sağlık: ${widget.health.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  shadows: [
                    Shadow(
                      color: Colors.blue.withOpacity(0.6),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricCard extends StatefulWidget {
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
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  double _animatedValue = 0;

  @override
  void initState() {
    super.initState();
    _animatedValue = widget.value;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void didUpdateWidget(_MetricCard oldWidget) {
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
    
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              colors: [
                Colors.grey.shade900.withOpacity(0.8),
                Colors.black,
                Colors.grey.shade900.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.color.withOpacity(isHighValue ? 0.7 : 0.4),
              width: isHighValue ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(pulseGlow * (isHighValue ? 1.2 : 0.8)),
                blurRadius: isHighValue ? 20 : 12,
                spreadRadius: isHighValue ? 4 : 2,
              ),
              if (isHighValue)
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 6,
                ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 1,
                  shadows: [
                    Shadow(
                      color: widget.color.withOpacity(0.6),
                      blurRadius: 5,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                        shadows: [
                          Shadow(
                            color: widget.color.withOpacity(0.8),
                            blurRadius: 15,
                          ),
                          Shadow(
                            color: widget.color.withOpacity(0.4),
                            blurRadius: 25,
                          ),
                        ],
                      ),
                      child: Text(
                        _animatedValue.toStringAsFixed(1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: Text(
                      widget.unit,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
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
                                widget.color.withOpacity(0.7),
                                widget.color,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: widget.color.withOpacity(0.9),
                                blurRadius: 10,
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

class _PowerFlowIndicator extends StatefulWidget {
  final double regenPower;
  final double batterySOC;

  const _PowerFlowIndicator({
    required this.regenPower,
    required this.batterySOC,
  });

  @override
  State<_PowerFlowIndicator> createState() => _PowerFlowIndicatorState();
}

class _PowerFlowIndicatorState extends State<_PowerFlowIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _flowController;

  @override
  void initState() {
    super.initState();
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCharging = widget.regenPower > 0;
    final flowColor = isCharging ? Colors.green.shade400 : Colors.blue.shade400;
    final pulseGlow = 0.5 + (math.sin(_flowController.value * 2 * math.pi) * 0.3);
    
    return AnimatedBuilder(
      animation: _flowController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.grey.shade900.withOpacity(0.8),
                Colors.black,
                Colors.grey.shade900.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: flowColor.withOpacity(pulseGlow),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: flowColor.withOpacity(pulseGlow * 0.8),
                blurRadius: 20,
                spreadRadius: 3,
              ),
              BoxShadow(
                color: flowColor.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GÜÇ AKIŞI',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: flowColor.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Motor
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withOpacity(pulseGlow),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.electric_bolt,
                          color: Colors.yellow.shade400,
                          size: 35,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'MOTOR',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  
                  // Animasyonlu Ok
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Transform.translate(
                      offset: Offset(
                        isCharging
                            ? math.sin(_flowController.value * 2 * math.pi) * 5
                            : -math.sin(_flowController.value * 2 * math.pi) * 5,
                        0,
                      ),
                      child: Icon(
                        isCharging ? Icons.arrow_back : Icons.arrow_forward,
                        color: flowColor,
                        size: 45,
                      ),
                    ),
                  ),
                  
                  // Batarya
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: flowColor.withOpacity(pulseGlow),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.battery_charging_full,
                          color: flowColor,
                          size: 35,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'BATARYA',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: flowColor,
                  shadows: [
                    Shadow(
                      color: flowColor.withOpacity(0.8),
                      blurRadius: 15,
                    ),
                    Shadow(
                      color: flowColor.withOpacity(0.4),
                      blurRadius: 25,
                    ),
                  ],
                ),
                child: Text(
                  isCharging
                      ? '${widget.regenPower.toStringAsFixed(1)} kW Rejeneratif'
                      : 'Güç Çıkışı',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
