import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const BMWi8DashboardApp());
}

class BMWi8DashboardApp extends StatelessWidget {
  const BMWi8DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMW i8 Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const DashboardScreen(),
    );
  }
}
