import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/database/database_helper.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/splash_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/premium_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('premium');

  // Initialize SQLite database
  await DatabaseHelper.instance.database;

  // Initialize AdMob
  await MobileAds.instance.initialize();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: FormifyApp(),
    ),
  );
}

class FormifyApp extends ConsumerWidget {
  const FormifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);

    return MaterialApp(
      title: 'Formify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: hasSeenOnboarding ? const HomeScreen() : const SplashScreen(),
    );
  }
}
