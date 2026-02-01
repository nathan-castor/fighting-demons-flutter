/// face_off_screen.dart
/// The core face-off experience - branching dialog with Spirit Guide

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fighting_demons/providers/providers.dart';
import 'package:fighting_demons/router/app_router.dart';
import 'package:fighting_demons/theme/app_theme.dart';
import 'package:fighting_demons/config/lore_data.dart';

enum FaceOffState {
  greeting,
  challenge,
  activity,
  meditation,
  complete,
  deferred,
}

class FaceOffScreen extends ConsumerStatefulWidget {
  final String faceOffType;

  const FaceOffScreen({super.key, required this.faceOffType});

  @override
  ConsumerState<FaceOffScreen> createState() => _FaceOffScreenState();
}

class _FaceOffScreenState extends ConsumerState<FaceOffScreen>
    with SingleTickerProviderStateMixin {
  FaceOffState _state = FaceOffState.greeting;
  int? _reps;
  final _repsController = TextEditingController();
  bool _isPr = false;

  late AnimationController _textAnimController;
  late Animation<double> _textFadeAnim;

  FaceOffType get _faceOffType {
    switch (widget.faceOffType) {
      case 'dawn':
        return FaceOffType.dawn;
      case 'noon':
        return FaceOffType.noon;
      case 'dusk':
        return FaceOffType.dusk;
      default:
        return FaceOffType.dawn;
    }
  }

  String get _greeting => greetings[_faceOffType]!;
  String get _instruction => activityInstructions[_faceOffType]!;
  String get _deferMessage => deferMessages[_faceOffType]!;
  String get _completionMessage => completionMessages[_faceOffType]!;

  int get _basePoints {
    switch (_faceOffType) {
      case FaceOffType.dawn:
        return 10; // Mile + meditation
      case FaceOffType.noon:
      case FaceOffType.dusk:
        return 6; // Reps + meditation
    }
  }

  @override
  void initState() {
    super.initState();
    _textAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _textFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimController, curve: Curves.easeIn),
    );
    _textAnimController.forward();
  }

  @override
  void dispose() {
    _textAnimController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _transitionTo(FaceOffState newState) {
    _textAnimController.reverse().then((_) {
      setState(() {
        _state = newState;
      });
      _textAnimController.forward();
    });
  }

  void _acceptChallenge() {
    _transitionTo(FaceOffState.activity);
  }

  void _deferChallenge() async {
    await ref.read(todayRecordProvider.notifier).deferFaceOff(widget.faceOffType);
    _transitionTo(FaceOffState.deferred);
  }

  void _completeActivity() {
    // For noon/dusk, get reps
    if (_faceOffType == FaceOffType.noon || _faceOffType == FaceOffType.dusk) {
      final reps = int.tryParse(_repsController.text);
      if (reps == null || reps <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid number')),
        );
        return;
      }
      _reps = reps;
      
      // Check for PR
      final profile = ref.read(profileProvider).valueOrNull;
      if (profile != null) {
        if (_faceOffType == FaceOffType.noon && reps > profile.pushupPr) {
          _isPr = true;
        } else if (_faceOffType == FaceOffType.dusk && reps > profile.pullupPr) {
          _isPr = true;
        }
      }
    }
    _transitionTo(FaceOffState.meditation);
  }

  void _completeMeditation() async {
    final points = _basePoints + (_isPr ? 5 : 0);
    
    await ref.read(todayRecordProvider.notifier).completeFaceOff(
      faceOffType: widget.faceOffType,
      pointsEarned: points,
      miles: _faceOffType == FaceOffType.dawn ? 1.0 : null,
      reps: _reps,
      meditationMinutes: 10,
    );

    await ref.read(profileProvider.notifier).updatePoints(
      userPointsDelta: points,
    );

    _transitionTo(FaceOffState.complete);
  }

  void _goHome() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: Text('${widget.faceOffType.toUpperCase()} FACE-OFF'),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _textFadeAnim,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case FaceOffState.greeting:
        return _buildGreeting();
      case FaceOffState.activity:
        return _buildActivity();
      case FaceOffState.meditation:
        return _buildMeditation();
      case FaceOffState.complete:
        return _buildComplete();
      case FaceOffState.deferred:
        return _buildDeferred();
      default:
        return _buildGreeting();
    }
  }

  Widget _buildGreeting() {
    final profile = ref.watch(profileProvider).valueOrNull;
    final stageEmoji = profile?.spiritGuideStage.icon ?? '🕯️';

    return _DialogScreen(
      emoji: stageEmoji,
      message: _greeting,
      actions: [
        _DialogButton(
          label: 'I am ready',
          isPrimary: true,
          onPressed: _acceptChallenge,
        ),
        _DialogButton(
          label: 'Not yet...',
          onPressed: _deferChallenge,
        ),
      ],
    );
  }

  Widget _buildActivity() {
    final profile = ref.watch(profileProvider).valueOrNull;
    final stageEmoji = profile?.spiritGuideStage.icon ?? '🕯️';

    return _DialogScreen(
      emoji: stageEmoji,
      message: _instruction,
      child: _faceOffType == FaceOffType.dawn
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              child: TextField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
                decoration: InputDecoration(
                  hintText: _faceOffType == FaceOffType.noon
                      ? 'Pushups'
                      : 'Pullups',
                ),
              ),
            ),
      actions: [
        _DialogButton(
          label: 'Done',
          isPrimary: true,
          onPressed: _completeActivity,
        ),
      ],
    );
  }

  Widget _buildMeditation() {
    final profile = ref.watch(profileProvider).valueOrNull;
    final stageEmoji = profile?.spiritGuideStage.icon ?? '🕯️';

    return _DialogScreen(
      emoji: stageEmoji,
      message: meditationPrompt,
      child: Column(
        children: [
          const SizedBox(height: 24),
          // TODO: Add actual meditation timer here
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('🧘', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text(
                  '10 Minutes',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Close your eyes. Breathe. Be still.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        _DialogButton(
          label: 'Meditation Complete',
          isPrimary: true,
          onPressed: _completeMeditation,
        ),
      ],
    );
  }

  Widget _buildComplete() {
    final profile = ref.watch(profileProvider).valueOrNull;
    final stageEmoji = profile?.spiritGuideStage.icon ?? '🕯️';
    final points = _basePoints + (_isPr ? 5 : 0);

    return _DialogScreen(
      emoji: stageEmoji,
      message: _isPr ? '$prMessage\n\n$_completionMessage' : _completionMessage,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⚡', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(
                  '+$points points',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.success,
                      ),
                ),
              ],
            ),
          ),
          if (_isPr) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'NEW PR: $_reps',
                    style: TextStyle(color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        _DialogButton(
          label: 'Continue',
          isPrimary: true,
          onPressed: _goHome,
        ),
      ],
    );
  }

  Widget _buildDeferred() {
    final profile = ref.watch(profileProvider).valueOrNull;
    final stageEmoji = profile?.spiritGuideStage.icon ?? '🕯️';

    return _DialogScreen(
      emoji: stageEmoji,
      message: _deferMessage,
      actions: [
        _DialogButton(
          label: 'I understand',
          isPrimary: true,
          onPressed: _goHome,
        ),
      ],
    );
  }
}

class _DialogScreen extends StatelessWidget {
  final String emoji;
  final String message;
  final Widget? child;
  final List<_DialogButton> actions;

  const _DialogScreen({
    required this.emoji,
    required this.message,
    this.child,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Spirit Guide with glow
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Message
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          height: 1.6,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (child != null) child!,
                ],
              ),
            ),
          ),
          // Actions
          Column(
            children: actions.map((action) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: action.isPrimary
                      ? ElevatedButton(
                          onPressed: action.onPressed,
                          child: Text(action.label),
                        )
                      : OutlinedButton(
                          onPressed: action.onPressed,
                          child: Text(action.label),
                        ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _DialogButton {
  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.label,
    this.isPrimary = false,
    required this.onPressed,
  });
}
