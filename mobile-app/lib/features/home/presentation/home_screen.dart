import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          DashboardView(),
          EVManagementView(),
          FinanceView(),
          GamificationView(),
          SettingsView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.electric_car_outlined),
            selectedIcon: Icon(Icons.electric_car),
            label: 'Araç',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Cüzdan',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Ligler',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}

// Placeholder views - will be implemented in respective feature modules
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Dashboard - Coming Soon'),
    );
  }
}

class EVManagementView extends StatelessWidget {
  const EVManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('EV Management - Coming Soon'),
    );
  }
}

class FinanceView extends StatelessWidget {
  const FinanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Finance - Coming Soon'),
    );
  }
}

class GamificationView extends StatelessWidget {
  const GamificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Gamification - Coming Soon'),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings - Coming Soon'),
    );
  }
}
