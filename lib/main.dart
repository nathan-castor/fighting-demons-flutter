/// main.dart
/// Fighting Demons - Gamified Spiritual Wellness App
/// Built with Flutter + Riverpod + Supabase

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fighting_demons/router/app_router.dart';
import 'package:fighting_demons/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode for better UX
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://mknsvbvvclfivzlrrmpw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rbnN2YnZ2Y2xmaXZ6bHJybXB3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgxNTM3ODEsImV4cCI6MjA4MzcyOTc4MX0.SvMdalz3C5-V17zq0HbXru9YaecemqPYkPgiw2JjsfA',
  );

  runApp(
    const ProviderScope(
      child: FightingDemonsApp(),
    ),
  );
}

class FightingDemonsApp extends ConsumerWidget {
  const FightingDemonsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Fighting Demons',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
