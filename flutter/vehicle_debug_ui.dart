import 'package:flutter/material.dart';
import 'pid_router.dart';
import 'package:intl/intl.dart';

/// Araç Debug Paneli - Tam panel
class VehicleDebugPanel extends StatefulWidget {
  final PIDRouter pidRouter;
  final VoidCallback onClose;

  const VehicleDebugPanel({
    Key? key,
    required this.pidRouter,
    required this.onClose,
  }) : super(key: key);

  @override
  State<VehicleDebugPanel> createState() => _VehicleDebugPanelState();
}

class _VehicleDebugPanelState extends State<VehicleDebugPanel> {
  VehicleDetectionResult? _detectionResult;
  bool _isExpanded = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _detectVehicle();
  }

  Future<void> _detectVehicle() async {
    final result = await widget.pidRouter.detectVehicle();
    setState(() {
      _detectionResult = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.build, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Vehicle Detection Debug',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(_isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
              ],
            ),

            if (_isExpanded) ...[
              const SizedBox(height: 12),

              // Content
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                )
              else if (_detectionResult != null) ...[
                _buildBrandDisplay(_detectionResult!),
                const SizedBox(height: 12),
                _buildDetectionMethods(_detectionResult!),
                const SizedBox(height: 12),
                _buildStats(_detectionResult!),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBrandDisplay(VehicleDetectionResult result) {
    final color = _getColorForConfidence(result.confidence);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.directions_car, size: 48, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            result.brand.displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (result.model != null)
            Text(
              'Model: ${result.model}',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          const SizedBox(height: 4),
          Text(
            '${result.confidence}% Confidence',
            style: const TextStyle(fontSize: 12, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionMethods(VehicleDetectionResult result) {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detection Methods',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (result.detectionMethods.isEmpty)
              const Text(
                'No detection methods available',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...result.detectionMethods.map((method) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _buildDetectionMethodItem(method),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectionMethodItem(DetectionMethod method) {
    IconData icon;
    switch (method.source) {
      case 'VIN':
        icon = Icons.info;
        break;
      case 'ECU':
        icon = Icons.settings;
        break;
      case 'PID Test':
        icon = Icons.play_arrow;
        break;
      default:
        icon = Icons.help;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.source,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (method.data != null)
                  Text(
                    method.data!,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
              ],
            ),
          ),
          _buildConfidenceBadge(method.confidence),
        ],
      ),
    );
  }

  Widget _buildConfidenceBadge(int confidence) {
    final color = _getColorForConfidence(confidence);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$confidence%',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStats(VehicleDetectionResult result) {
    final dateFormat = DateFormat('HH:mm:ss');
    final timeStr =
        dateFormat.format(DateTime.fromMillisecondsSinceEpoch(result.timestamp));

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildStatRow('Detection Time', timeStr),
          _buildStatRow('Methods Used', '${result.detectionMethods.length}'),
          _buildStatRow('Brand Code', result.brand.name.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForConfidence(int confidence) {
    if (confidence >= 90) return Colors.green;
    if (confidence >= 70) return Colors.blue;
    if (confidence >= 50) return Colors.amber;
    return Colors.red;
  }
}

/// Araç Debug Rozeti - Kompakt
class VehicleDebugBadge extends StatefulWidget {
  final PIDRouter pidRouter;
  final VoidCallback onClick;

  const VehicleDebugBadge({
    Key? key,
    required this.pidRouter,
    required this.onClick,
  }) : super(key: key);

  @override
  State<VehicleDebugBadge> createState() => _VehicleDebugBadgeState();
}

class _VehicleDebugBadgeState extends State<VehicleDebugBadge> {
  VehicleBrand? _brand;
  int _confidence = 0;

  @override
  void initState() {
    super.initState();
    _loadBrand();
  }

  Future<void> _loadBrand() async {
    final result = await widget.pidRouter.detectVehicle();
    setState(() {
      _brand = result.brand;
      _confidence = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = _brand != null ? _getColorForConfidence(_confidence) : Colors.grey;

    return InkWell(
      onTap: widget.onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_car, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              _brand?.displayName ?? 'Detecting...',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForConfidence(int confidence) {
    if (confidence >= 90) return Colors.green;
    if (confidence >= 70) return Colors.blue;
    if (confidence >= 50) return Colors.amber;
    return Colors.red;
  }
}
