import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/mock_obd_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/sensor_grid_screen.dart';
import 'screens/performance_screen.dart';
import 'screens/battery_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D1B2A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const EVPDApp());
}

class EVPDApp extends StatelessWidget {
  const EVPDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EVP-D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A1929),
        primaryColor: const Color(0xFF00AAFF),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00AAFF),
          surface: Color(0xFF0D1B2A),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late final MockOBDService _obdService;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _obdService = MockOBDService();
    // Start data updates immediately
    _obdService.start();
  }

  @override
  void dispose() {
    _obdService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            DashboardScreen(obdService: _obdService),
            SensorGridScreen(obdService: _obdService),
            PerformanceScreen(obdService: _obdService),
            BatteryScreen(obdService: _obdService),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0D1B2A),
          border: Border(
            top: BorderSide(color: Color(0xFF1A3A5A), width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0D1B2A),
          selectedItemColor: const Color(0xFF00AAFF),
          unselectedItemColor: Colors.white38,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.speed),
              label: 'Kadran',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Sensorler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Performans',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.battery_full),
              label: 'Batarya',
            ),
          ],
        ),
      ),
    );
  }
}
