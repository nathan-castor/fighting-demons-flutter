/// meditation_timer.dart
/// Countdown timer for meditation with haptic feedback

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fighting_demons/theme/app_theme.dart';

class MeditationTimer extends StatefulWidget {
  final int durationMinutes;
  final VoidCallback onComplete;
  final VoidCallback? onSkip;

  const MeditationTimer({
    super.key,
    required this.durationMinutes,
    required this.onComplete,
    this.onSkip,
  });

  @override
  State<MeditationTimer> createState() => _MeditationTimerState();
}

class _MeditationTimerState extends State<MeditationTimer>
    with TickerProviderStateMixin {
  late int _secondsRemaining;
  Timer? _timer;
  bool _isRunning = false;
  bool _isComplete = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.durationMinutes * 60;

    _pulseController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    // Haptic feedback on start
    HapticFeedback.mediumImpact();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });

        // Gentle haptic at each minute mark
        if (_secondsRemaining > 0 && _secondsRemaining % 60 == 0) {
          HapticFeedback.lightImpact();
        }

        // Countdown haptics in last 5 seconds
        if (_secondsRemaining <= 5 && _secondsRemaining > 0) {
          HapticFeedback.selectionClick();
        }
      } else {
        _timer?.cancel();
        setState(() {
          _isComplete = true;
        });
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _completeEarly() {
    _timer?.cancel();
    widget.onComplete();
  }

  String get _timeDisplay {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get _progress {
    final total = widget.durationMinutes * 60;
    return 1 - (_secondsRemaining / total);
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) {
      return _buildCompleteState();
    }

    if (!_isRunning) {
      return _buildStartState();
    }

    return _buildTimerState();
  }

  Widget _buildStartState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🧘', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 24),
        Text(
          'MEDITATION',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                letterSpacing: 3,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.durationMinutes} Minutes',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 24),
        Text(
          'Close your eyes. Breathe.\nWatch your thoughts without following them.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _startTimer,
            child: const Text('Begin Stillness'),
          ),
        ),
        if (widget.onSkip != null) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: widget.onSkip,
            child: const Text('Skip meditation'),
          ),
        ],
      ],
    );
  }

  Widget _buildTimerState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Breathing circle with timer
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.3),
                      AppColors.primary.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _timeDisplay,
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 4,
                                ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: AppColors.surfaceLight,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Breathing instruction
        Text(
          _pulseAnimation.value > 0.9 ? 'Breathe out...' : 'Breathe in...',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
        ),
        const SizedBox(height: 32),

        // Complete early option (appears after 1 minute)
        if (_secondsRemaining < (widget.durationMinutes * 60) - 60)
          TextButton(
            onPressed: _completeEarly,
            child: const Text('Complete Early'),
          ),
      ],
    );
  }

  Widget _buildCompleteState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('✨', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 24),
        Text(
          'THE SILENCE HAS BEEN KEPT',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                letterSpacing: 2,
                color: AppColors.accent,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ten minutes of stillness builds a wall\nthe demons cannot cross.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onComplete,
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}
