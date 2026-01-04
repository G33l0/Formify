import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// Premium status provider
final isPremiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  return PremiumNotifier();
});

class PremiumNotifier extends StateNotifier<bool> {
  PremiumNotifier() : super(false) {
    _loadPremiumStatus();
  }

  final _premiumBox = Hive.box('premium');

  Future<void> _loadPremiumStatus() async {
    state = _premiumBox.get('isPremium', defaultValue: false);
  }

  Future<void> setPremium(bool isPremium) async {
    state = isPremium;
    await _premiumBox.put('isPremium', isPremium);
    if (isPremium) {
      await _premiumBox.put('purchaseDate', DateTime.now().toIso8601String());
    }
  }

  Future<void> restorePurchase() async {
    // In production, this would verify purchase with in_app_purchase package
    // For now, just load from local storage
    await _loadPremiumStatus();
  }

  bool get canAccessPremiumFeatures => state;
}

// Document count provider (for free plan limits)
final documentCountProvider = StateNotifierProvider<DocumentCountNotifier, int>((ref) {
  return DocumentCountNotifier();
});

class DocumentCountNotifier extends StateNotifier<int> {
  DocumentCountNotifier() : super(0);

  void setCount(int count) {
    state = count;
  }

  void increment() {
    state++;
  }
}
