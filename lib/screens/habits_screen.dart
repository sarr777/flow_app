
import 'package:flutter/material.dart';

import '../data/local_storage.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<Map<String, dynamic>> _habits = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _defaultHabits = [
    {
      'title': 'Lire 20 minutes',
      'subtitle': 'Développer ses connaissances',
      'done': false,
    },
    {
      'title': 'Faire du sport',
      'subtitle': 'Prendre soin de son corps',
      'done': false,
    },
    {
      'title': 'Apprendre quelque chose',
      'subtitle': 'Progresser chaque jour',
      'done': false,
    },
    {
      'title': 'Se réveiller tôt',
      'subtitle': 'Commencer la journée avec énergie',
      'done': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final savedHabits = await LocalStorage.loadHabits();

    if (!mounted) return;

    setState(() {
      if (savedHabits != null && savedHabits.isNotEmpty) {
        _habits = savedHabits
            .map((habit) => Map<String, dynamic>.from(habit))
            .toList();
      } else {
        _habits = _defaultHabits
            .map((habit) => Map<String, dynamic>.from(habit))
            .toList();
      }

      _isLoading = false;
    });

    await LocalStorage.saveHabits(_habits);
  }

  Future<void> _toggleHabit(int index, bool value) async {
    setState(() {
      _habits[index]['done'] = value;
    });

    await LocalStorage.saveHabits(_habits);
  }

  @override
  Widget build(BuildContext context) {
    final completedHabits =
        _habits.where((habit) => habit['done'] == true).length;

    final totalHabits = _habits.length;

    final progress = totalHabits == 0
        ? 0.0
        : completedHabits / totalHabits;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FC),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7657F6),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  const Text(
                    'Mes habitudes',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25213D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Les petites actions répétées créent de grands changements.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF89869D),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Carte de progression
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7657F6),
                          Color(0xFF9B7BFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ta progression du jour',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              '$completedHabits/$totalHabits',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.local_fire_department_rounded,
                              color: Color(0xFFFFD166),
                              size: 32,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 9,
                            backgroundColor: Colors.white30,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          progress == 1
                              ? 'Bravo ! Toutes tes habitudes sont accomplies.'
                              : 'Continue, chaque effort compte !',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Routine quotidienne',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25213D),
                    ),
                  ),
                  const SizedBox(height: 15),

                  ...List.generate(_habits.length, (index) {
                    final habit = _habits[index];
                    final isDone = habit['done'] == true;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 13),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDone
                              ? const Color(0xFF7657F6)
                                  .withValues(alpha: 0.25)
                              : const Color(0xFFEDEAF6),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? const Color(0xFFEDE7FF)
                                  : const Color(0xFFF5F3FC),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              _habitIcon(index),
                              color: const Color(0xFF7657F6),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  habit['title'] ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDone
                                        ? const Color(0xFF7657F6)
                                        : const Color(0xFF25213D),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  habit['subtitle'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF89869D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Checkbox(
                            value: isDone,
                            activeColor: const Color(0xFF7657F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onChanged: (value) {
                              _toggleHabit(index, value ?? false);
                            },
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE7FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: Color(0xFF7657F6),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'La régularité est plus importante que la perfection.',
                            style: TextStyle(
                              color: Color(0xFF5D48B5),
                              fontSize: 13,
                              height: 1.5,
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

  IconData _habitIcon(int index) {
    switch (index) {
      case 0:
        return Icons.menu_book_rounded;
      case 1:
        return Icons.fitness_center_rounded;
      case 2:
        return Icons.school_rounded;
      case 3:
        return Icons.wb_sunny_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }
}
