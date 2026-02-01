/// user_profile.dart
/// Domain model for user profile data

import 'package:fighting_demons/config/game_config.dart';

class UserProfile {
  final String id;
  final String email;
  final String? name;
  final int totalPoints;
  final int demonPoints;
  final int lifeForce;
  final int currentStreak;
  final int longestStreak;
  final int totalMiles;
  final int totalPushups;
  final int totalPullups;
  final int totalMeditationMinutes;
  final int pushupPr;
  final int pullupPr;
  final bool introSeen;
  final List<String> unlockedAchievements;
  final List<String> unlockedLore;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.totalPoints = 0,
    this.demonPoints = 0,
    this.lifeForce = 100,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalMiles = 0,
    this.totalPushups = 0,
    this.totalPullups = 0,
    this.totalMeditationMinutes = 0,
    this.pushupPr = 0,
    this.pullupPr = 0,
    this.introSeen = false,
    this.unlockedAchievements = const [],
    this.unlockedLore = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from Supabase row
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
      totalPoints: json['total_points'] as int? ?? 0,
      demonPoints: json['demon_points'] as int? ?? 0,
      lifeForce: json['life_force'] as int? ?? 100,
      currentStreak: json['current_streak'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
      totalMiles: json['total_miles'] as int? ?? 0,
      totalPushups: json['total_pushups'] as int? ?? 0,
      totalPullups: json['total_pullups'] as int? ?? 0,
      totalMeditationMinutes: json['total_meditation_minutes'] as int? ?? 0,
      pushupPr: json['pushup_pr'] as int? ?? 0,
      pullupPr: json['pullup_pr'] as int? ?? 0,
      introSeen: json['intro_seen'] as bool? ?? false,
      unlockedAchievements: (json['unlocked_achievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      unlockedLore: (json['unlocked_lore'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'total_points': totalPoints,
      'demon_points': demonPoints,
      'life_force': lifeForce,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'total_miles': totalMiles,
      'total_pushups': totalPushups,
      'total_pullups': totalPullups,
      'total_meditation_minutes': totalMeditationMinutes,
      'pushup_pr': pushupPr,
      'pullup_pr': pullupPr,
      'intro_seen': introSeen,
      'unlocked_achievements': unlockedAchievements,
      'unlocked_lore': unlockedLore,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Get current Spirit Guide stage
  SpiritGuideStage get spiritGuideStage => getSpiritGuideStage(totalPoints);

  /// Get current user title
  UserTitle get title => getUserTitle(totalPoints);

  /// Get progress to next evolution (0-100)
  int get evolutionProgress => getEvolutionProgress(totalPoints);

  /// Get next evolution info
  NextEvolution? get nextEvolution => getNextEvolution(totalPoints);

  /// Check if user has a specific achievement
  bool hasAchievement(String achievementId) =>
      unlockedAchievements.contains(achievementId);

  /// Check if user has unlocked specific lore
  bool hasLore(String loreId) => unlockedLore.contains(loreId);

  /// Create copy with updates
  UserProfile copyWith({
    String? id,
    String? email,
    String? name,
    int? totalPoints,
    int? demonPoints,
    int? lifeForce,
    int? currentStreak,
    int? longestStreak,
    int? totalMiles,
    int? totalPushups,
    int? totalPullups,
    int? totalMeditationMinutes,
    int? pushupPr,
    int? pullupPr,
    bool? introSeen,
    List<String>? unlockedAchievements,
    List<String>? unlockedLore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      totalPoints: totalPoints ?? this.totalPoints,
      demonPoints: demonPoints ?? this.demonPoints,
      lifeForce: lifeForce ?? this.lifeForce,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalMiles: totalMiles ?? this.totalMiles,
      totalPushups: totalPushups ?? this.totalPushups,
      totalPullups: totalPullups ?? this.totalPullups,
      totalMeditationMinutes:
          totalMeditationMinutes ?? this.totalMeditationMinutes,
      pushupPr: pushupPr ?? this.pushupPr,
      pullupPr: pullupPr ?? this.pullupPr,
      introSeen: introSeen ?? this.introSeen,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      unlockedLore: unlockedLore ?? this.unlockedLore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
