import 'package:flutter/material.dart';
import 'motor_analyzer.dart';
import 'data_analyzer.dart';
import 'pid_router.dart';
import 'pid_reader.dart';
import 'vehicle_debug_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBD Diagnostics - Enhanced',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PIDReader pidReader;
  late final PIDRouter pidRouter;
  late final MotorAnalyzer motorAnalyzer;
  late final DataAnalyzer dataAnalyzer;

  bool _showDebugPanel = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    pidReader = MockPIDReader();
    pidRouter = PIDRouter(pidReader);
    motorAnalyzer = MotorAnalyzer(pidReader);

    // Marka tespit et
    _initializeDetection();
  }

  Future<void> _initializeDetection() async {
    final result = await pidRouter.detectVehicle();
    dataAnalyzer = DataAnalyzer(
      pidReader,
      vehicleBrand: result.brand.displayName,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OBD Diagnostics - Enhanced'),
        actions: [
          // ✅ Kompakt debug rozeti
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: VehicleDebugBadge(
              pidRouter: pidRouter,
              onClick: () {
                setState(() {
                  _showDebugPanel = !_showDebugPanel;
                });
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Tab bar
              Container(
                color: Colors.blue.shade50,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTab('Motor Analysis', 0),
                    ),
                    Expanded(
                      child: _buildTab('EV Analysis', 1),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _selectedTab == 0
                    ? MotorAnalysisScreen(motorAnalyzer: motorAnalyzer)
                    : EVAnalysisScreen(dataAnalyzer: dataAnalyzer),
              ),
            ],
          ),

          // ✅ Floating debug panel
          if (_showDebugPanel)
            Positioned(
              bottom: 16,
              right: 16,
              child: VehicleDebugPanel(
                pidRouter: pidRouter,
                onClose: () {
                  setState(() {
                    _showDebugPanel = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black54,
          ),
        ),
      ),
    );
  }
}

/// Motor Analiz Ekranı
class MotorAnalysisScreen extends StatelessWidget {
  final MotorAnalyzer motorAnalyzer;

  const MotorAnalysisScreen({Key? key, required this.motorAnalyzer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Motor / ICE Analysis',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          // Stream builder
          StreamBuilder<MotorData>(
            stream: motorAnalyzer.monitorMotorData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!;

              return Column(
                children: [
                  _buildDataCard('Engine RPM', '${data.rpm.toInt()}', 'rpm'),
                  _buildDataCard('Speed', '${data.speed.toInt()}', 'km/h'),
                  _buildDataCard('Throttle', '${data.throttlePosition.toInt()}', '%'),

                  // ✅ GERÇEK YAKIT TÜKETİMİ KARTI
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.local_gas_station, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'REAL-TIME FUEL CONSUMPTION',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${data.fuelConsumption.toStringAsFixed(2)} L/h',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Instantaneous: ${data.instantFuelRate.toStringAsFixed(2)} L/100km',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'MAF: ${data.maf.toStringAsFixed(1)} g/s',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(String label, String value, String unit) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text(
              '$value $unit',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/// EV Analiz Ekranı
class EVAnalysisScreen extends StatelessWidget {
  final DataAnalyzer dataAnalyzer;

  const EVAnalysisScreen({Key? key, required this.dataAnalyzer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EV Analysis (${dataAnalyzer.vehicleBrand})',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          // Stream builder
          StreamBuilder<EVData>(
            stream: dataAnalyzer.monitorEVData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!;

              return Column(
                children: [
                  _buildDataCard('State of Charge', '${data.soc.toInt()}', '%'),
                  _buildDataCard('Battery Voltage', data.voltage.toStringAsFixed(1), 'V'),
                  _buildDataCard('Power', data.power.toStringAsFixed(1), 'kW'),

                  // ✅ REJENERATİF FREN KARTI
                  Card(
                    color: data.isRegenerating
                        ? Colors.purple.shade50
                        : Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.bolt,
                                color: data.isRegenerating
                                    ? Colors.purple
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'REGENERATIVE BRAKING ${data.isRegenerating ? "ACTIVE" : "IDLE"}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: data.isRegenerating
                                      ? Colors.purple.shade700
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${data.regenPower.toStringAsFixed(1)} kW',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Current: ${data.regenCurrent.toStringAsFixed(1)} A',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Total Recovered: ${data.regenEnergyTotal.toStringAsFixed(2)} kWh',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'Motor Torque: ${data.motorTorque.toStringAsFixed(0)} Nm',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(String label, String value, String unit) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text(
              '$value $unit',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
