import 'package:flutter/material.dart';

void main() {
  runApp(const MobilitySuperApp());
}

class MobilitySuperApp extends StatelessWidget {
  const MobilitySuperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobility Super App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Futuristic look
        useMaterial3: true,
      ),
      home: const PersonaSelectionScreen(),
    );
  }
}

class PersonaSelectionScreen extends StatelessWidget {
  const PersonaSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your AI Companion')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPersonaCard(context, 'The Loyal Butler', 'Polite & Formal', Icons.person),
            const SizedBox(height: 20),
            _buildPersonaCard(context, 'The Fun Buddy', 'Friendly & Joking', Icons.emoji_emotions),
            const SizedBox(height: 20),
            _buildPersonaCard(context, 'The Tough Coach', 'Disciplined', Icons.sports),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonaCard(BuildContext context, String title, String subtitle, IconData icon) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Navigate to main dashboard with selected persona
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 50),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(subtitle),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobility Dashboard')),
      body: const Center(child: Text('Welcome to your New Generation Mobility Ecosystem')),
    );
  }
}
