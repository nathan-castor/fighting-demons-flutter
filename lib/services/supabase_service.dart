/// supabase_service.dart
/// Handles all Supabase operations: auth, profiles, daily records, activities

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fighting_demons/domain/models/user_profile.dart';
import 'package:fighting_demons/domain/models/daily_record.dart';

/// Singleton access to Supabase client
SupabaseClient get supabase => Supabase.instance.client;

// ============================================
// AUTH SERVICE
// ============================================

class AuthService {
  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: name != null ? {'name': name} : null,
    );
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  /// Get current session
  Session? get currentSession => supabase.auth.currentSession;

  /// Get current user
  User? get currentUser => supabase.auth.currentUser;

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }
}

// ============================================
// PROFILE SERVICE
// ============================================

class ProfileService {
  final AuthService _auth;

  ProfileService(this._auth);

  /// Get current user's profile
  Future<UserProfile?> getProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) return null;
    return UserProfile.fromJson(response);
  }

  /// Update profile
  Future<UserProfile?> updateProfile(Map<String, dynamic> updates) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    updates['updated_at'] = DateTime.now().toIso8601String();

    final response = await supabase
        .from('profiles')
        .update(updates)
        .eq('id', user.id)
        .select()
        .single();

    return UserProfile.fromJson(response);
  }

  /// Update points
  Future<UserProfile?> updatePoints({
    required int userPointsDelta,
    int demonPointsDelta = 0,
  }) async {
    final profile = await getProfile();
    if (profile == null) throw Exception('Profile not found');

    final updates = <String, dynamic>{
      'total_points': profile.totalPoints + userPointsDelta,
      'demon_points': profile.demonPoints + demonPointsDelta,
    };

    // Also update life_force if gaining points
    if (userPointsDelta > 0) {
      updates['life_force'] =
          (profile.lifeForce + userPointsDelta).clamp(0, 200);
    }

    return updateProfile(updates);
  }

  /// Mark intro as seen
  Future<UserProfile?> markIntroSeen() async {
    return updateProfile({'intro_seen': true});
  }

  /// Unlock an achievement
  Future<UserProfile?> unlockAchievement(String achievementId) async {
    final profile = await getProfile();
    if (profile == null) throw Exception('Profile not found');

    if (profile.hasAchievement(achievementId)) return profile;

    final updated = [...profile.unlockedAchievements, achievementId];
    return updateProfile({'unlocked_achievements': updated});
  }

  /// Unlock lore
  Future<UserProfile?> unlockLore(String loreId) async {
    final profile = await getProfile();
    if (profile == null) throw Exception('Profile not found');

    if (profile.hasLore(loreId)) return profile;

    final updated = [...profile.unlockedLore, loreId];
    return updateProfile({'unlocked_lore': updated});
  }
}

// ============================================
// DAILY RECORD SERVICE
// ============================================

class DailyRecordService {
  final AuthService _auth;

  DailyRecordService(this._auth);

  /// Get today's date string (YYYY-MM-DD)
  String getTodayDateString() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  /// Get or create today's record
  Future<DailyRecord?> getTodayRecord() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final today = getTodayDateString();

    // Try to get existing record
    var response = await supabase
        .from('daily_records')
        .select()
        .eq('user_id', user.id)
        .eq('date', today)
        .maybeSingle();

    // If no record exists, create one
    if (response == null) {
      response = await supabase
          .from('daily_records')
          .insert({
            'user_id': user.id,
            'date': today,
          })
          .select()
          .single();
    }

    return DailyRecord.fromJson(response);
  }

  /// Update today's record
  Future<DailyRecord?> updateTodayRecord(Map<String, dynamic> updates) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final today = getTodayDateString();
    updates['updated_at'] = DateTime.now().toIso8601String();

    final response = await supabase
        .from('daily_records')
        .update(updates)
        .eq('user_id', user.id)
        .eq('date', today)
        .select()
        .single();

    return DailyRecord.fromJson(response);
  }

  /// Get all daily records
  Future<List<DailyRecord>> getAllRecords() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('daily_records')
        .select()
        .eq('user_id', user.id)
        .order('date', ascending: false);

    return (response as List)
        .map((r) => DailyRecord.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Complete a face-off
  Future<DailyRecord?> completeFaceOff({
    required String faceOffType, // 'dawn', 'noon', 'dusk'
    required int pointsEarned,
    double? miles,
    int? reps,
    int meditationMinutes = 0,
  }) async {
    final today = await getTodayRecord();
    if (today == null) throw Exception('Could not get today record');

    final updates = <String, dynamic>{
      '${faceOffType}_complete': true,
      'points_earned': today.pointsEarned + pointsEarned,
      'meditation_minutes': today.meditationMinutes + meditationMinutes,
    };

    if (miles != null) {
      updates['miles_walked'] = (today.milesWalked ?? 0) + miles;
    }

    if (faceOffType == 'noon' && reps != null) {
      updates['pushups_count'] = reps;
    } else if (faceOffType == 'dusk' && reps != null) {
      updates['pullups_count'] = reps;
    }

    // Check for perfect day
    final willDawnComplete =
        faceOffType == 'dawn' ? true : today.dawnComplete;
    final willNoonComplete =
        faceOffType == 'noon' ? true : today.noonComplete;
    final willDuskComplete =
        faceOffType == 'dusk' ? true : today.duskComplete;

    if (willDawnComplete && willNoonComplete && willDuskComplete) {
      updates['is_perfect_day'] = true;
    }

    return updateTodayRecord(updates);
  }

  /// Defer a face-off
  Future<DailyRecord?> deferFaceOff(String faceOffType) async {
    final today = await getTodayRecord();
    if (today == null) throw Exception('Could not get today record');

    int currentDefers;
    switch (faceOffType) {
      case 'dawn':
        currentDefers = today.dawnDefers;
        break;
      case 'noon':
        currentDefers = today.noonDefers;
        break;
      case 'dusk':
        currentDefers = today.duskDefers;
        break;
      default:
        throw Exception('Invalid face-off type');
    }

    return updateTodayRecord({
      '${faceOffType}_defers': currentDefers + 1,
    });
  }
}

// ============================================
// COMBINED SERVICE (convenience)
// ============================================

class FightingDemonsService {
  late final AuthService auth;
  late final ProfileService profile;
  late final DailyRecordService dailyRecord;

  FightingDemonsService() {
    auth = AuthService();
    profile = ProfileService(auth);
    dailyRecord = DailyRecordService(auth);
  }
}
