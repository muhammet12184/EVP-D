import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../services/mock_obd_service.dart';

class BatteryScreen extends StatefulWidget {
  final MockOBDService obdService;
  const BatteryScreen({super.key, required this.obdService});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  StreamSubscription? _sub;
  BatteryData? _battery;
  bool _isLive = true;

  @override
  void initState() {
    super.initState();
    _battery = widget.obdService.currentBattery;
    _sub = widget.obdService.batteryStream.listen((data) {
      if (mounted && _isLive) setState(() => _battery = data);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = _battery;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          color: const Color(0xFF0D1B2A),
          child: Column(
            children: [
              // Total voltage row
              Row(
                children: [
                  const Icon(Icons.battery_charging_full, color: Color(0xFF00AAFF), size: 28),
                  const SizedBox(width: 8),
                  Text(
                    b != null ? '${b.totalVoltage.toStringAsFixed(1)}V' : '---',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  // Live toggle
                  GestureDetector(
                    onTap: () => setState(() => _isLive = !_isLive),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: _isLive
                            ? const Color(0xFF00AAFF).withOpacity(0.2)
                            : const Color(0xFF2A4A5A).withOpacity(0.3),
                        border: Border.all(
                          color: _isLive ? const Color(0xFF00AAFF) : const Color(0xFF2A4A5A),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: _isLive ? const Color(0xFF00E5AA) : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isLive ? 'Canli' : 'Durdur',
                            style: TextStyle(
                              color: _isLive ? const Color(0xFF00AAFF) : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Stats row 1
              Row(
                children: [
                  _statItem('${b?.minVoltage.toStringAsFixed(3) ?? "---"}V', 'Min', const Color(0xFF00AAFF)),
                  _statItem('${b?.avgVoltage.toStringAsFixed(3) ?? "---"}V', 'Ort', Colors.white),
                  _statItem('${b?.maxVoltage.toStringAsFixed(3) ?? "---"}V', 'Max', const Color(0xFF00E5AA)),
                  _statItem('${b?.deltaVoltage.toStringAsFixed(0) ?? "---"}mV', 'Delta', const Color(0xFFFFAA00)),
                ],
              ),
              const SizedBox(height: 4),
              // Stats row 2
              Row(
                children: [
                  _statItem('${b?.temperature.toStringAsFixed(1) ?? "---"}\u00b0C', 'Sicaklik', const Color(0xFF00AAFF)),
                  _statItem('${b?.balancing ?? "---"}', 'Dengeleme', Colors.white),
                  _statItem('${b?.cellCount ?? "---"}', 'Hucre', const Color(0xFF00E5AA)),
                  _statItem('${b?.moduleCount ?? "---"}', 'Modul', const Color(0xFFFFAA00)),
                ],
              ),
            ],
          ),
        ),
        // Cell grid
        Expanded(
          child: b == null
              ? const Center(
                  child: Text(
                    'Batarya verisi bekleniyor...',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                  ),
                  itemCount: b.cells.length,
                  itemBuilder: (context, index) {
                    return _CellTile(
                      cell: b.cells[index],
                      minV: b.minVoltage,
                      maxV: b.maxVoltage,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _statItem(String value, String label, Color valueColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _CellTile extends StatelessWidget {
  final BatteryCell cell;
  final double minV;
  final double maxV;

  const _CellTile({required this.cell, required this.minV, required this.maxV});

  @override
  Widget build(BuildContext context) {
    // Color based on where the cell sits in min-max range
    double range = maxV - minV;
    double normalized = range > 0 ? (cell.voltage - minV) / range : 0.5;

    Color cellColor;
    if (normalized < 0.2) {
      cellColor = const Color(0xFF0044AA);
    } else if (normalized > 0.8) {
      cellColor = const Color(0xFF00AA66);
    } else {
      cellColor = const Color(0xFF1A5A8A);
    }

    return Container(
      decoration: BoxDecoration(
        color: cellColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: cellColor.withOpacity(0.6), width: 0.5),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${cell.cellNumber}',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF00CCFF),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              cell.voltage.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 9,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
