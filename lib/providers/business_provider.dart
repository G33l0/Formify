import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/business_profile.dart';
import '../core/database/database_helper.dart';

// Business profiles provider
final businessProfilesProvider = StateNotifierProvider<BusinessProfilesNotifier, List<BusinessProfile>>((ref) {
  return BusinessProfilesNotifier();
});

class BusinessProfilesNotifier extends StateNotifier<List<BusinessProfile>> {
  BusinessProfilesNotifier() : super([]) {
    loadProfiles();
  }

  final _db = DatabaseHelper.instance;

  Future<void> loadProfiles() async {
    final maps = await _db.queryAll('business_profiles');
    state = maps.map((map) => BusinessProfile.fromMap(map)).toList();
  }

  Future<void> addProfile(BusinessProfile profile) async {
    await _db.insert('business_profiles', profile.toMap());
    await loadProfiles();
  }

  Future<void> updateProfile(BusinessProfile profile) async {
    await _db.update('business_profiles', profile.toMap());
    await loadProfiles();
  }

  Future<void> deleteProfile(String id) async {
    await _db.delete('business_profiles', id);
    await loadProfiles();
  }

  Future<void> setDefaultProfile(String id) async {
    // Remove default from all profiles
    for (var profile in state) {
      if (profile.isDefault) {
        await _db.update('business_profiles', profile.copyWith(isDefault: false).toMap());
      }
    }

    // Set new default
    final profile = state.firstWhere((p) => p.id == id);
    await _db.update('business_profiles', profile.copyWith(isDefault: true).toMap());
    await loadProfiles();
  }

  BusinessProfile? get defaultProfile {
    try {
      return state.firstWhere((p) => p.isDefault);
    } catch (e) {
      return state.isNotEmpty ? state.first : null;
    }
  }
}
