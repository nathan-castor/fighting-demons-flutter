/// game_config.dart
/// Central configuration for all game progression systems
/// Ported from React version with full parity

import 'package:flutter/material.dart';

/// POINT MATH:
/// - Dawn (mile + meditation): 10 points
/// - Noon (pushups + meditation): 6 points
/// - Dusk (pullups + meditation): 6 points
/// - Perfect day: 22 points
/// - PR bonus: +5 points
///
/// Day 1: 22 points | Day 2: 44 | Day 7: 154 | Day 30: 660

// ============================================
// SPIRIT GUIDE EVOLUTION STAGES
// ============================================

class SpiritGuideStage {
  final String id;
  final String name;
  final int minPoints;
  final String icon;
  final String description;
  final String? evolveMessage;

  const SpiritGuideStage({
    required this.id,
    required this.name,
    required this.minPoints,
    required this.icon,
    required this.description,
    this.evolveMessage,
  });
}

const spiritGuideStages = [
  SpiritGuideStage(
    id: 'ember',
    name: 'Ember',
    minPoints: 0,
    icon: '🕯️',
    description: 'A faint flicker, barely holding on',
    evolveMessage: null,
  ),
  SpiritGuideStage(
    id: 'shade',
    name: 'Shade',
    minPoints: 44, // Day 2!
    icon: '👻',
    description: 'Growing more defined, gaining form',
    evolveMessage:
        'Your dedication has given me form. I am no longer just an ember... I am becoming something more.',
  ),
  SpiritGuideStage(
    id: 'specter',
    name: 'Specter',
    minPoints: 100, // ~Day 5
    icon: '✨',
    description: 'Radiant and strong, a true presence',
    evolveMessage:
        'I can feel the light coursing through me! The demons... they notice now. They fear what we are becoming.',
  ),
  SpiritGuideStage(
    id: 'wraith',
    name: 'Wraith',
    minPoints: 200, // ~Day 9
    icon: '🌟',
    description: 'A force of ethereal power',
    evolveMessage:
        'I remember now... fragments of who I was before. Your strength is restoring my memories.',
  ),
  SpiritGuideStage(
    id: 'guardian',
    name: 'Guardian',
    minPoints: 400, // ~Day 18
    icon: '🛡️',
    description: 'A powerful protector, shield of light',
    evolveMessage:
        'I can protect you now. Not just guide — PROTECT. The demons will not touch you while I stand.',
  ),
  SpiritGuideStage(
    id: 'sentinel',
    name: 'Sentinel',
    minPoints: 700, // ~Day 32 (1 month!)
    icon: '⚔️',
    description: 'Warrior of the light, blade drawn',
    evolveMessage:
        'A full cycle of the moon, and look what we have become. I am no longer your guide — I am your sword.',
  ),
  SpiritGuideStage(
    id: 'seraph',
    name: 'Seraph',
    minPoints: 1200, // ~Day 55
    icon: '👼',
    description: 'Transcendent being of pure radiance',
    evolveMessage:
        'The transformation is nearly complete. I ascend... and you ascend with me. We are bound eternal.',
  ),
  SpiritGuideStage(
    id: 'radiant',
    name: 'Radiant',
    minPoints: 2000, // ~Day 91 (3 months!)
    icon: '☀️',
    description: 'Blazing with divine light',
    evolveMessage:
        'Three moons of battle. Three moons of victory. I AM the light now. And so are you.',
  ),
  SpiritGuideStage(
    id: 'ascendant',
    name: 'Ascendant',
    minPoints: 3500, // ~Day 159 (5+ months)
    icon: '🔱',
    description: 'Beyond mortal comprehension',
    evolveMessage:
        'There are no more stages. We have transcended. The demons speak of us in whispers. We are legend.',
  ),
];

// ============================================
// USER TITLES / RANKS
// ============================================

class UserTitle {
  final String id;
  final String name;
  final int minPoints;
  final String description;

  const UserTitle({
    required this.id,
    required this.name,
    required this.minPoints,
    required this.description,
  });
}

const userTitles = [
  UserTitle(
    id: 'initiate',
    name: 'Initiate',
    minPoints: 0,
    description: 'Beginning the journey',
  ),
  UserTitle(
    id: 'acolyte',
    name: 'Acolyte',
    minPoints: 50, // ~Day 3
    description: 'Learning the ways of light',
  ),
  UserTitle(
    id: 'warrior',
    name: 'Warrior',
    minPoints: 150, // ~Day 7 (1 week!)
    description: 'Proven in battle',
  ),
  UserTitle(
    id: 'knight',
    name: 'Knight of Light',
    minPoints: 350, // ~Day 16
    description: 'Sworn defender against darkness',
  ),
  UserTitle(
    id: 'champion',
    name: 'Champion',
    minPoints: 600, // ~Day 27
    description: 'Victor of countless face-offs',
  ),
  UserTitle(
    id: 'crusader',
    name: 'Crusader',
    minPoints: 1000, // ~Day 45
    description: 'Marching ever forward in holy purpose',
  ),
  UserTitle(
    id: 'paladin',
    name: 'Paladin',
    minPoints: 1800, // ~Day 82 (nearly 3 months)
    description: 'Master of body and spirit',
  ),
  UserTitle(
    id: 'lightbringer',
    name: 'Lightbringer',
    minPoints: 3000, // ~Day 136
    description: 'Bearer of the sacred flame',
  ),
  UserTitle(
    id: 'ascended',
    name: 'Ascended',
    minPoints: 5000, // ~Day 227 (7+ months)
    description: 'Beyond mortal limits',
  ),
];

// ============================================
// ACHIEVEMENTS
// ============================================

enum AchievementCategory { milestones, streaks, strength, endurance, mindfulness, evolution, secret }

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementCategory category;
  final bool secret;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    this.secret = false,
  });
}

const achievements = <String, Achievement>{
  // First steps
  'first_light': Achievement(
    id: 'first_light',
    name: 'First Light',
    description: 'Complete your first face-off',
    icon: '🌅',
    category: AchievementCategory.milestones,
  ),
  'perfect_day': Achievement(
    id: 'perfect_day',
    name: 'Perfect Day',
    description: 'Complete all 3 face-offs in one day',
    icon: '⭐',
    category: AchievementCategory.milestones,
  ),

  // Streaks
  'streak_3': Achievement(
    id: 'streak_3',
    name: 'Kindling',
    description: '3-day streak',
    icon: '🔥',
    category: AchievementCategory.streaks,
  ),
  'streak_7': Achievement(
    id: 'streak_7',
    name: 'Week Warrior',
    description: '7-day streak',
    icon: '💪',
    category: AchievementCategory.streaks,
  ),
  'streak_14': Achievement(
    id: 'streak_14',
    name: 'Fortnight Fighter',
    description: '14-day streak',
    icon: '⚡',
    category: AchievementCategory.streaks,
  ),
  'streak_30': Achievement(
    id: 'streak_30',
    name: 'Monthly Master',
    description: '30-day streak',
    icon: '🏆',
    category: AchievementCategory.streaks,
  ),
  'streak_100': Achievement(
    id: 'streak_100',
    name: 'Centurion',
    description: '100-day streak',
    icon: '👑',
    category: AchievementCategory.streaks,
  ),

  // Strength
  'first_pr': Achievement(
    id: 'first_pr',
    name: 'Iron Will',
    description: 'Beat a personal record',
    icon: '🎯',
    category: AchievementCategory.strength,
  ),
  'pushup_50': Achievement(
    id: 'pushup_50',
    name: 'Push It',
    description: '50 pushups in a single set',
    icon: '💥',
    category: AchievementCategory.strength,
  ),
  'pushup_100': Achievement(
    id: 'pushup_100',
    name: 'Century Club',
    description: '100 pushups in a single set',
    icon: '💯',
    category: AchievementCategory.strength,
  ),
  'pullup_20': Achievement(
    id: 'pullup_20',
    name: 'Rising Up',
    description: '20 pullups in a single set',
    icon: '🧗',
    category: AchievementCategory.strength,
  ),
  'pullup_50': Achievement(
    id: 'pullup_50',
    name: 'Gravity Defier',
    description: '50 pullups in a single set',
    icon: '🦅',
    category: AchievementCategory.strength,
  ),

  // Endurance
  'miles_10': Achievement(
    id: 'miles_10',
    name: 'Trailblazer',
    description: 'Walk/run 10 total miles',
    icon: '🚶',
    category: AchievementCategory.endurance,
  ),
  'miles_50': Achievement(
    id: 'miles_50',
    name: 'Road Warrior',
    description: 'Walk/run 50 total miles',
    icon: '🏃',
    category: AchievementCategory.endurance,
  ),
  'miles_100': Achievement(
    id: 'miles_100',
    name: 'Marathon Mind',
    description: 'Walk/run 100 total miles',
    icon: '🏅',
    category: AchievementCategory.endurance,
  ),
  'miles_500': Achievement(
    id: 'miles_500',
    name: 'Pilgrim',
    description: 'Walk/run 500 total miles',
    icon: '🗺️',
    category: AchievementCategory.endurance,
    secret: true,
  ),

  // Mindfulness
  'meditation_100': Achievement(
    id: 'meditation_100',
    name: 'Still Mind',
    description: '100 total minutes of meditation',
    icon: '🧘',
    category: AchievementCategory.mindfulness,
  ),
  'meditation_500': Achievement(
    id: 'meditation_500',
    name: 'Inner Peace',
    description: '500 total minutes of meditation',
    icon: '☯️',
    category: AchievementCategory.mindfulness,
  ),
  'meditation_1000': Achievement(
    id: 'meditation_1000',
    name: 'Enlightened',
    description: '1000 total minutes of meditation',
    icon: '🕉️',
    category: AchievementCategory.mindfulness,
  ),

  // Evolution
  'first_evolution': Achievement(
    id: 'first_evolution',
    name: 'Awakening',
    description: 'Spirit Guide evolves for the first time',
    icon: '🦋',
    category: AchievementCategory.evolution,
  ),
  'guardian_reached': Achievement(
    id: 'guardian_reached',
    name: 'Guardian Bond',
    description: 'Spirit Guide reaches Guardian stage',
    icon: '🛡️',
    category: AchievementCategory.evolution,
  ),
  'seraph_reached': Achievement(
    id: 'seraph_reached',
    name: 'Seraphic Bond',
    description: 'Spirit Guide reaches Seraph stage',
    icon: '👼',
    category: AchievementCategory.evolution,
  ),

  // Secret
  'early_bird': Achievement(
    id: 'early_bird',
    name: 'Early Bird',
    description: 'Complete Dawn face-off before 5 AM',
    icon: '🐦',
    category: AchievementCategory.secret,
    secret: true,
  ),
  'night_owl': Achievement(
    id: 'night_owl',
    name: 'Night Owl',
    description: 'Complete Dusk face-off after 11 PM',
    icon: '🦉',
    category: AchievementCategory.secret,
    secret: true,
  ),
  'comeback': Achievement(
    id: 'comeback',
    name: 'The Comeback',
    description: 'Complete a face-off after deferring 3 times',
    icon: '🔄',
    category: AchievementCategory.secret,
    secret: true,
  ),
};

// ============================================
// HELPER FUNCTIONS
// ============================================

/// Get Spirit Guide stage based on total points
SpiritGuideStage getSpiritGuideStage(int totalPoints) {
  for (int i = spiritGuideStages.length - 1; i >= 0; i--) {
    if (totalPoints >= spiritGuideStages[i].minPoints) {
      return spiritGuideStages[i];
    }
  }
  return spiritGuideStages[0];
}

/// Get User Title based on total points
UserTitle getUserTitle(int totalPoints) {
  for (int i = userTitles.length - 1; i >= 0; i--) {
    if (totalPoints >= userTitles[i].minPoints) {
      return userTitles[i];
    }
  }
  return userTitles[0];
}

/// Evolution check result
class EvolutionResult {
  final bool evolved;
  final SpiritGuideStage? fromStage;
  final SpiritGuideStage? toStage;

  const EvolutionResult({
    required this.evolved,
    this.fromStage,
    this.toStage,
  });
}

/// Check if user just evolved
EvolutionResult checkEvolution(int oldPoints, int newPoints) {
  final oldStage = getSpiritGuideStage(oldPoints);
  final newStage = getSpiritGuideStage(newPoints);

  if (newStage.id != oldStage.id) {
    return EvolutionResult(
      evolved: true,
      fromStage: oldStage,
      toStage: newStage,
    );
  }
  return const EvolutionResult(evolved: false);
}

/// Title up result
class TitleUpResult {
  final bool titleUp;
  final UserTitle? fromTitle;
  final UserTitle? toTitle;

  const TitleUpResult({
    required this.titleUp,
    this.fromTitle,
    this.toTitle,
  });
}

/// Check if user earned a new title
TitleUpResult checkTitleUp(int oldPoints, int newPoints) {
  final oldTitle = getUserTitle(oldPoints);
  final newTitle = getUserTitle(newPoints);

  if (newTitle.id != oldTitle.id) {
    return TitleUpResult(
      titleUp: true,
      fromTitle: oldTitle,
      toTitle: newTitle,
    );
  }
  return const TitleUpResult(titleUp: false);
}

/// Next evolution info
class NextEvolution {
  final SpiritGuideStage stage;
  final int pointsNeeded;

  const NextEvolution({required this.stage, required this.pointsNeeded});
}

/// Get next evolution milestone
NextEvolution? getNextEvolution(int totalPoints) {
  for (int i = 0; i < spiritGuideStages.length; i++) {
    if (spiritGuideStages[i].minPoints > totalPoints) {
      return NextEvolution(
        stage: spiritGuideStages[i],
        pointsNeeded: spiritGuideStages[i].minPoints - totalPoints,
      );
    }
  }
  return null; // Max stage reached
}

/// Get progress to next evolution (0-100)
int getEvolutionProgress(int totalPoints) {
  final currentStage = getSpiritGuideStage(totalPoints);
  final currentIndex = spiritGuideStages.indexWhere((s) => s.id == currentStage.id);

  if (currentIndex == spiritGuideStages.length - 1) {
    return 100; // Max stage
  }

  final nextStage = spiritGuideStages[currentIndex + 1];
  final pointsInCurrentStage = totalPoints - currentStage.minPoints;
  final pointsNeededForNext = nextStage.minPoints - currentStage.minPoints;

  return ((pointsInCurrentStage / pointsNeededForNext) * 100).round().clamp(0, 100);
}
