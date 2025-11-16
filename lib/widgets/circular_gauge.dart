import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CircularGauge extends StatelessWidget {
  final String title;
  final double value;
  final double maxValue;
  final String unit;
  final Color color;
  final double size;

  const CircularGauge({
    Key? key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.color,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: size,
            width: size,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: maxValue,
                  showLabels: true,
                  showTicks: true,
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.15,
                    cornerStyle: CornerStyle.bothCurve,
                    color: Colors.white.withOpacity(0.1),
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  labelFormat: '{value}',
                  labelStyle: GaugeTextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  ticksPosition: ElementsPosition.outside,
                  labelsPosition: ElementsPosition.outside,
                  majorTickStyle: MajorTickStyle(
                    length: 8,
                    thickness: 2,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  minorTickStyle: MinorTickStyle(
                    length: 4,
                    thickness: 1,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: value,
                      width: 0.15,
                      sizeUnit: GaugeSizeUnit.factor,
                      cornerStyle: CornerStyle.bothCurve,
                      gradient: SweepGradient(
                        colors: <Color>[
                          color.withOpacity(0.3),
                          color,
                        ],
                        stops: const <double>[0.25, 0.75],
                      ),
                      enableAnimation: true,
                      animationDuration: 100,
                      animationType: AnimationType.ease,
                    ),
                    NeedlePointer(
                      value: value,
                      needleLength: 0.7,
                      needleStartWidth: 1,
                      needleEndWidth: 3,
                      needleColor: color,
                      knobStyle: KnobStyle(
                        knobRadius: 0.08,
                        color: color,
                        borderColor: Colors.white,
                        borderWidth: 0.02,
                      ),
                      enableAnimation: true,
                      animationDuration: 100,
                      animationType: AnimationType.ease,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              value.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: size * 0.12,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            Text(
                              unit,
                              style: TextStyle(
                                fontSize: size * 0.06,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      angle: 90,
                      positionFactor: 0.8,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
