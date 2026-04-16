import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../services/mock_obd_service.dart';

class SensorGridScreen extends StatefulWidget {
  final MockOBDService obdService;
  const SensorGridScreen({super.key, required this.obdService});

  @override
  State<SensorGridScreen> createState() => _SensorGridScreenState();
}

class _SensorGridScreenState extends State<SensorGridScreen> {
  StreamSubscription? _sub;
  Map<String, SensorData> _sensors = {};
  String _searchQuery = '';

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

  List<SensorData> get _sortedSensors {
    var list = _sensors.values.toList();

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      list = list.where((s) =>
        s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.unit.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Sort: active sensors first, then alphabetical
    list.sort((a, b) {
      if (a.hasValue && !b.hasValue) return -1;
      if (!a.hasValue && b.hasValue) return 1;
      return a.name.compareTo(b.name);
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final sensors = _sortedSensors;

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Sensor ara...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
              prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4), size: 20),
              filled: true,
              fillColor: const Color(0xFF1A2A3A),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        // Sensor count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Row(
            children: [
              Text(
                '${sensors.where((s) => s.hasValue).length} aktif / ${sensors.length} toplam',
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
              ),
            ],
          ),
        ),
        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.85,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: sensors.length,
            itemBuilder: (context, index) {
              return _SensorCard(sensor: sensors[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _SensorCard extends StatelessWidget {
  final SensorData sensor;
  const _SensorCard({required this.sensor});

  @override
  Widget build(BuildContext context) {
    final hasVal = sensor.hasValue;
    final borderColor = hasVal
        ? const Color(0xFF00C8AA).withOpacity(0.6)
        : const Color(0xFF2A4A5A).withOpacity(0.3);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sensor name at top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              sensor.name,
              style: TextStyle(
                fontSize: 9,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Value centered and prominent
          Expanded(
            child: Center(
              child: Text(
                sensor.displayValue,
                style: TextStyle(
                  fontSize: hasVal ? 16 : 12,
                  fontWeight: FontWeight.bold,
                  color: hasVal
                      ? const Color(0xFF00E5AA)
                      : Colors.white.withOpacity(0.25),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Unit at bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasVal)
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(right: 3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF00E5AA),
                    ),
                  ),
                Text(
                  sensor.unit,
                  style: TextStyle(
                    fontSize: 9,
                    color: hasVal
                        ? const Color(0xFF00C8AA)
                        : Colors.white.withOpacity(0.3),
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
