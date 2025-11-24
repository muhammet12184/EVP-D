import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/vehicle/presentation/pages/vehicle_dashboard_page.dart';
import '../../features/ai_assistant/presentation/pages/ai_assistant_page.dart';
import '../../features/finance/presentation/pages/wallet_page.dart';
import '../../features/community/presentation/pages/imece_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/vehicle',
        builder: (context, state) => const VehicleDashboardPage(),
      ),
      GoRoute(
        path: '/ai-assistant',
        builder: (context, state) => const AIAssistantPage(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const WalletPage(),
      ),
      GoRoute(
        path: '/imece',
        builder: (context, state) => const ImecePage(),
      ),
    ],
  );
}
