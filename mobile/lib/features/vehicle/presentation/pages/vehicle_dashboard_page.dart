import 'package:flutter/material.dart';

class VehicleDashboardPage extends StatefulWidget {
  const VehicleDashboardPage({super.key});

  @override
  State<VehicleDashboardPage> createState() => _VehicleDashboardPageState();
}

class _VehicleDashboardPageState extends State<VehicleDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araç Kontrol Paneli'),
      ),
      body: const Center(
        child: Text('Araç Dashboard Sayfası'),
      ),
    );
  }
}
