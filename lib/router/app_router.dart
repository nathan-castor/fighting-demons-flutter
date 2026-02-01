/// app_router.dart
/// GoRouter configuration for Fighting Demons

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fighting_demons/providers/providers.dart';
import 'package:fighting_demons/screens/splash_screen.dart';
import 'package:fighting_demons/screens/intro_screen.dart';
import 'package:fighting_demons/screens/auth/login_screen.dart';
import 'package:fighting_demons/screens/auth/signup_screen.dart';
import 'package:fighting_demons/screens/home/home_screen.dart';
import 'package:fighting_demons/screens/face_off/face_off_screen.dart';
import 'package:fighting_demons/screens/profile/profile_screen.dart';
import 'package:fighting_demons/screens/lore/lore_screen.dart';
import 'package:fighting_demons/screens/achievements/achievements_screen.dart';

/// Route paths
abstract class AppRoutes {
  static const splash = '/';
  static const intro = '/intro';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const faceOff = '/face-off';
  static const profile = '/profile';
  static const lore = '/lore';
  static const achievements = '/achievements';
}

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Add auth redirect logic here
      return null;
    },
    routes: [
      // Splash / Loading
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Intro / Onboarding
      GoRoute(
        path: AppRoutes.intro,
        builder: (context, state) => const IntroScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // Main app routes
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.faceOff,
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'dawn';
          return FaceOffScreen(faceOffType: type);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.lore,
        builder: (context, state) => const LoreScreen(),
      ),
      GoRoute(
        path: AppRoutes.achievements,
        builder: (context, state) => const AchievementsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
});
