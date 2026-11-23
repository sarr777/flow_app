import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final List<IconData> icons = const [
    Icons.grid_view_rounded,
    Icons.check_circle_outline_rounded,
    Icons.track_changes_rounded,
    Icons.timer_outlined,
    Icons.person_outline_rounded,
  ];

  final List<String> labels = const [
    'Accueil',
    'Tâches',
    'Habitudes',
    'Focus',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final selected = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icons[index],
                  size: 24,
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.textMuted,
                ),
                const SizedBox(height: 5),
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? AppTheme.primary
                        : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}