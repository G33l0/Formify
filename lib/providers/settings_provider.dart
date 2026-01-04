import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';

// Currency provider
final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier();
});

class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier() : super('USD') {
    _loadCurrency();
  }

  final _settingsBox = Hive.box('settings');

  Future<void> _loadCurrency() async {
    state = _settingsBox.get('currency', defaultValue: 'USD');
  }

  Future<void> setCurrency(String currency) async {
    state = currency;
    await _settingsBox.put('currency', currency);
  }

  String get currencySymbol {
    return AppConstants.currencySymbols[state] ?? state;
  }
}

// Language provider (placeholder for future i18n)
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en') {
    _loadLanguage();
  }

  final _settingsBox = Hive.box('settings');

  Future<void> _loadLanguage() async {
    state = _settingsBox.get('language', defaultValue: 'en');
  }

  Future<void> setLanguage(String language) async {
    state = language;
    await _settingsBox.put('language', language);
  }
}

// Onboarding provider
final hasSeenOnboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadOnboardingStatus();
  }

  final _settingsBox = Hive.box('settings');

  Future<void> _loadOnboardingStatus() async {
    state = _settingsBox.get('hasSeenOnboarding', defaultValue: false);
  }

  Future<void> completeOnboarding() async {
    state = true;
    await _settingsBox.put('hasSeenOnboarding', true);
  }
}
