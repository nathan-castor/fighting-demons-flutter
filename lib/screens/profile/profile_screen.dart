/// profile_screen.dart
/// User profile, stats, and settings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fighting_demons/providers/providers.dart';
import 'package:fighting_demons/router/app_router.dart';
import 'package:fighting_demons/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('PROFILE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Avatar & Name
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                        child: Text(
                          profile.spiritGuideStage.icon,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.name ?? 'Warrior',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.title.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Grid
                _StatGrid(profile: profile),
                const SizedBox(height: 24),

                // Personal Records
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PERSONAL RECORDS',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.accent,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _PRRow(
                        icon: '💪',
                        label: 'Pushups',
                        value: profile.pushupPr.toString(),
                      ),
                      const SizedBox(height: 12),
                      _PRRow(
                        icon: '🧗',
                        label: 'Pullups',
                        value: profile.pullupPr.toString(),
                      ),
                      const SizedBox(height: 12),
                      _PRRow(
                        icon: '🏃',
                        label: 'Total Miles',
                        value: profile.totalMiles.toString(),
                      ),
                      const SizedBox(height: 12),
                      _PRRow(
                        icon: '🧘',
                        label: 'Meditation (min)',
                        value: profile.totalMeditationMinutes.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final dynamic profile;

  const _StatGrid({required this.profile});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatTile(
          icon: '⚡',
          value: profile.totalPoints.toString(),
          label: 'Total Points',
        ),
        _StatTile(
          icon: '👹',
          value: profile.demonPoints.toString(),
          label: 'Demon Points',
        ),
        _StatTile(
          icon: '🔥',
          value: profile.currentStreak.toString(),
          label: 'Current Streak',
        ),
        _StatTile(
          icon: '🏆',
          value: profile.longestStreak.toString(),
          label: 'Longest Streak',
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
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

class _PRRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _PRRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.accent,
              ),
        ),
      ],
    );
  }
}
