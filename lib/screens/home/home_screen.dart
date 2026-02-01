/// home_screen.dart
/// Main dashboard - Spirit Guide, stats, face-off triggers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fighting_demons/providers/providers.dart';
import 'package:fighting_demons/router/app_router.dart';
import 'package:fighting_demons/theme/app_theme.dart';
import 'package:fighting_demons/config/game_config.dart';
import 'package:fighting_demons/config/lore_data.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final todayAsync = ref.watch(todayRecordProvider);
    final nextFaceOff = ref.watch(nextFaceOffProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('FIGHTING DEMONS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          final stage = profile.spiritGuideStage;
          final title = profile.title;
          final evolutionProgress = profile.evolutionProgress;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Spirit Guide Card
                _SpiritGuideCard(
                  stage: stage,
                  evolutionProgress: evolutionProgress,
                ),
                const SizedBox(height: 24),

                // User Stats Row
                _StatsRow(
                  points: profile.totalPoints,
                  streak: profile.currentStreak,
                  title: title.name,
                ),
                const SizedBox(height: 24),

                // Today's Progress
                todayAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, st) => Text('Error: $e'),
                  data: (today) => _TodayProgress(
                    dawnComplete: today?.dawnComplete ?? false,
                    noonComplete: today?.noonComplete ?? false,
                    duskComplete: today?.duskComplete ?? false,
                  ),
                ),
                const SizedBox(height: 24),

                // Face Off Button
                if (nextFaceOff != null)
                  _FaceOffButton(faceOffType: nextFaceOff)
                else
                  _AllCompleteCard(),

                const SizedBox(height: 24),

                // Random Lore
                _LoreCard(lore: getRandomLore()),

                const SizedBox(height: 24),

                // Quick Nav
                Row(
                  children: [
                    Expanded(
                      child: _NavButton(
                        icon: '📖',
                        label: 'Lore',
                        onTap: () => context.push(AppRoutes.lore),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _NavButton(
                        icon: '🏆',
                        label: 'Achievements',
                        onTap: () => context.push(AppRoutes.achievements),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SpiritGuideCard extends StatelessWidget {
  final SpiritGuideStage stage;
  final int evolutionProgress;

  const _SpiritGuideCard({
    required this.stage,
    required this.evolutionProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Stage icon with glow
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Text(
              stage.icon,
              style: const TextStyle(fontSize: 64),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            stage.name.toUpperCase(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  letterSpacing: 3,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            stage.description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Evolution progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: evolutionProgress / 100,
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$evolutionProgress% to next evolution',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int points;
  final int streak;
  final String title;

  const _StatsRow({
    required this.points,
    required this.streak,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: '⚡',
            value: points.toString(),
            label: 'Points',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: '🔥',
            value: streak.toString(),
            label: 'Streak',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: '🎖️',
            value: title,
            label: 'Rank',
            small: true,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final bool small;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: small ? 14 : 20,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}

class _TodayProgress extends StatelessWidget {
  final bool dawnComplete;
  final bool noonComplete;
  final bool duskComplete;

  const _TodayProgress({
    required this.dawnComplete,
    required this.noonComplete,
    required this.duskComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _FaceOffIcon(
            emoji: '🌅',
            label: 'Dawn',
            complete: dawnComplete,
          ),
          _FaceOffIcon(
            emoji: '☀️',
            label: 'Noon',
            complete: noonComplete,
          ),
          _FaceOffIcon(
            emoji: '🌙',
            label: 'Dusk',
            complete: duskComplete,
          ),
        ],
      ),
    );
  }
}

class _FaceOffIcon extends StatelessWidget {
  final String emoji;
  final String label;
  final bool complete;

  const _FaceOffIcon({
    required this.emoji,
    required this.label,
    required this.complete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: 32,
                color: complete ? null : Colors.grey,
              ),
            ),
            if (complete)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: complete ? AppColors.textPrimary : AppColors.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _FaceOffButton extends StatelessWidget {
  final String faceOffType;

  const _FaceOffButton({required this.faceOffType});

  String get _emoji {
    switch (faceOffType) {
      case 'dawn':
        return '🌅';
      case 'noon':
        return '☀️';
      case 'dusk':
        return '🌙';
      default:
        return '⚔️';
    }
  }

  String get _label {
    return '${faceOffType.toUpperCase()} FACE-OFF';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 72,
      child: ElevatedButton(
        onPressed: () =>
            context.push('${AppRoutes.faceOff}?type=$faceOffType'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Text(
              _label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllCompleteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text('⭐', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'PERFECT DAY',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.success,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'All face-offs complete. The demons retreat. Rest well, warrior.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LoreCard extends StatelessWidget {
  final String lore;

  const _LoreCard({required this.lore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          const Text('🕯️', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 12),
          Text(
            '"$lore"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
