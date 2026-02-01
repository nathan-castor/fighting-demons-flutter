/// lore_screen.dart
/// Unlocked lore entries and world-building

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fighting_demons/providers/providers.dart';
import 'package:fighting_demons/theme/app_theme.dart';
import 'package:fighting_demons/config/lore_data.dart';

class LoreScreen extends ConsumerWidget {
  const LoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('THE LORE'),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          final unlockedLore = profile.unlockedLore;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loreUnlocks.length,
            itemBuilder: (context, index) {
              final lore = loreUnlocks[index];
              final isUnlocked = unlockedLore.contains(lore.id);

              return _LoreCard(
                lore: lore,
                isUnlocked: isUnlocked,
              );
            },
          );
        },
      ),
    );
  }
}

class _LoreCard extends StatelessWidget {
  final LoreUnlock lore;
  final bool isUnlocked;

  const _LoreCard({
    required this.lore,
    required this.isUnlocked,
  });

  String get _unlockHint {
    switch (lore.unlockType) {
      case LoreUnlockType.points:
        return 'Earn ${lore.unlockValue} points';
      case LoreUnlockType.evolution:
        return 'Evolve to ${lore.unlockValue}';
      case LoreUnlockType.streak:
        return '${lore.unlockValue}-day streak';
      case LoreUnlockType.miles:
        return 'Walk ${lore.unlockValue} miles';
      case LoreUnlockType.meditation:
        return '${lore.unlockValue} min meditation';
      case LoreUnlockType.pushups:
        return '${lore.unlockValue} total pushups';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: isUnlocked
            ? Border.all(color: AppColors.primary.withOpacity(0.3))
            : null,
      ),
      child: isUnlocked
          ? _UnlockedContent(lore: lore)
          : _LockedContent(name: lore.name, hint: _unlockHint),
    );
  }
}

class _UnlockedContent extends StatefulWidget {
  final LoreUnlock lore;

  const _UnlockedContent({required this.lore});

  @override
  State<_UnlockedContent> createState() => _UnlockedContentState();
}

class _UnlockedContentState extends State<_UnlockedContent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Text('📜', style: TextStyle(fontSize: 24)),
          title: Text(
            widget.lore.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          trailing: Icon(
            _expanded ? Icons.expand_less : Icons.expand_more,
            color: AppColors.primary,
          ),
          onTap: () => setState(() => _expanded = !_expanded),
        ),
        if (_expanded) ...[
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.lore.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    entry,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

class _LockedContent extends StatelessWidget {
  final String name;
  final String hint;

  const _LockedContent({
    required this.name,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Text('🔒', style: TextStyle(fontSize: 24)),
      title: Text(
        name,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textMuted,
            ),
      ),
      subtitle: Text(
        hint,
        style: const TextStyle(color: AppColors.textMuted),
      ),
    );
  }
}
