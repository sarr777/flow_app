import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dart:ui' show FontFeature;

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const int sessionDuration = 25 * 60;

  int remainingSeconds = sessionDuration;
  Timer? timer;
  bool isRunning = false;

  double get progress =>
      1 - (remainingSeconds / sessionDuration);

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    if (isRunning) return;

    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();

        setState(() {
          isRunning = false;
        });

        showSessionCompleted();
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();

    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();

    setState(() {
      remainingSeconds = sessionDuration;
      isRunning = false;
    });
  }

  void showSessionCompleted() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Session terminée 🎉'),
          content: const Text(
            'Bravo ! Tu viens de terminer une session de concentration.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MODE CONCENTRATION',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Une chose à la fois.',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Éloigne les distractions et concentre-toi '
                    'sur ce qui compte vraiment.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 260,
                  height: 260,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: const Color(0xFFEAE5FF),
                    valueColor:
                        const AlwaysStoppedAnimation(AppTheme.primary),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.self_improvement_rounded,
                      color: AppTheme.primary,
                      size: 38,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      formattedTime,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                        fontFeatures: [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isRunning ? 'Concentration en cours' : 'Session Focus',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 35),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TimerButton(
                  icon: Icons.refresh_rounded,
                  onTap: resetTimer,
                  background: Colors.white,
                  color: AppTheme.textDark,
                ),
                const SizedBox(width: 20),
                _TimerButton(
                  icon: isRunning
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  onTap: isRunning ? pauseTimer : startTimer,
                  background: AppTheme.primary,
                  color: Colors.white,
                  size: 72,
                ),
                const SizedBox(width: 20),
                _TimerButton(
                  icon: Icons.stop_rounded,
                  onTap: pauseTimer,
                  background: Colors.white,
                  color: AppTheme.textDark,
                ),
              ],
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE8FF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.tips_and_updates_rounded,
                    color: AppTheme.primary,
                    size: 26,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Conseil : désactive les notifications '
                      'pendant ta session pour rester concentré.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color color;
  final double size;

  const _TimerButton({
    required this.icon,
    required this.onTap,
    required this.background,
    required this.color,
    this.size = 58,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: color,
          padding: EdgeInsets.zero,
          elevation: 0,
          shape: const CircleBorder(),
        ),
        child: Icon(icon, size: size == 72 ? 34 : 24),
      ),
    );
  }
}