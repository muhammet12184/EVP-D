import 'package:flutter/material.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/vehicle/screens/vehicle_dashboard_screen.dart';
import '../../features/ai_assistant/screens/ai_persona_selection_screen.dart';
import '../../features/imece/screens/imece_map_screen.dart';
import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/gamification/screens/leagues_screen.dart';

/// App Router - Simple navigation without go_router dependency
/// For production, consider adding go_router package
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/vehicle':
        return MaterialPageRoute(builder: (_) => const VehicleDashboardScreen());
      case '/ai-persona':
        return MaterialPageRoute(builder: (_) => const AIPersonaSelectionScreen());
      case '/imece':
        return MaterialPageRoute(builder: (_) => const ImeceMapScreen());
      case '/wallet':
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case '/leagues':
        return MaterialPageRoute(builder: (_) => const LeaguesScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
