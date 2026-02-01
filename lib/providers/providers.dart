/// providers.dart
/// Riverpod providers for Fighting Demons app

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fighting_demons/services/supabase_service.dart';
import 'package:fighting_demons/domain/models/user_profile.dart';
import 'package:fighting_demons/domain/models/daily_record.dart';

// ============================================
// SERVICE PROVIDERS
// ============================================

/// Main service provider
final serviceProvider = Provider<FightingDemonsService>((ref) {
  return FightingDemonsService();
});

/// Auth service shortcut
final authServiceProvider = Provider<AuthService>((ref) {
  return ref.watch(serviceProvider).auth;
});

/// Profile service shortcut
final profileServiceProvider = Provider<ProfileService>((ref) {
  return ref.watch(serviceProvider).profile;
});

/// Daily record service shortcut
final dailyRecordServiceProvider = Provider<DailyRecordService>((ref) {
  return ref.watch(serviceProvider).dailyRecord;
});

// ============================================
// AUTH STATE
// ============================================

/// Current auth state stream
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Current user (null if not authenticated)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authServiceProvider).currentUser;
});

/// Is user authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

// ============================================
// PROFILE STATE
// ============================================

/// User profile notifier
class ProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final ProfileService _service;

  ProfileNotifier(this._service) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _service.getProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePoints({
    required int userPointsDelta,
    int demonPointsDelta = 0,
  }) async {
    try {
      final updated = await _service.updatePoints(
        userPointsDelta: userPointsDelta,
        demonPointsDelta: demonPointsDelta,
      );
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markIntroSeen() async {
    try {
      final updated = await _service.markIntroSeen();
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> unlockAchievement(String achievementId) async {
    try {
      final updated = await _service.unlockAchievement(achievementId);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final service = ref.watch(profileServiceProvider);
  return ProfileNotifier(service);
});

// ============================================
// DAILY RECORD STATE
// ============================================

/// Today's record notifier
class TodayRecordNotifier extends StateNotifier<AsyncValue<DailyRecord?>> {
  final DailyRecordService _service;

  TodayRecordNotifier(this._service) : super(const AsyncValue.loading()) {
    loadTodayRecord();
  }

  Future<void> loadTodayRecord() async {
    state = const AsyncValue.loading();
    try {
      final record = await _service.getTodayRecord();
      state = AsyncValue.data(record);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> completeFaceOff({
    required String faceOffType,
    required int pointsEarned,
    double? miles,
    int? reps,
    int meditationMinutes = 0,
  }) async {
    try {
      final updated = await _service.completeFaceOff(
        faceOffType: faceOffType,
        pointsEarned: pointsEarned,
        miles: miles,
        reps: reps,
        meditationMinutes: meditationMinutes,
      );
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deferFaceOff(String faceOffType) async {
    try {
      final updated = await _service.deferFaceOff(faceOffType);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final todayRecordProvider =
    StateNotifierProvider<TodayRecordNotifier, AsyncValue<DailyRecord?>>(
        (ref) {
  final service = ref.watch(dailyRecordServiceProvider);
  return TodayRecordNotifier(service);
});

// ============================================
// DERIVED STATE
// ============================================

/// Next available face-off type (null if all complete)
final nextFaceOffProvider = Provider<String?>((ref) {
  final record = ref.watch(todayRecordProvider).valueOrNull;
  if (record == null) return 'dawn'; // Default to dawn

  if (!record.dawnComplete) return 'dawn';
  if (!record.noonComplete) return 'noon';
  if (!record.duskComplete) return 'dusk';
  return null; // All complete
});

/// Is perfect day achieved
final isPerfectDayProvider = Provider<bool>((ref) {
  final record = ref.watch(todayRecordProvider).valueOrNull;
  return record?.isPerfectDay ?? false;
});
