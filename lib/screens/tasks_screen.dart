import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../data/local_storage.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController controller = TextEditingController();

  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;

  int get completedTasks =>
      tasks.where((task) => task['done'] == true).length;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final savedTasks = await LocalStorage.loadTasks();

    if (!mounted) return;

    setState(() {
      if (savedTasks != null && savedTasks.isNotEmpty) {
        tasks = savedTasks;
      } else {
        tasks = [
          {'title': 'Apprendre Flutter', 'done': false},
          {'title': 'Lire 10 pages', 'done': false},
          {'title': 'Faire du sport', 'done': true},
          {'title': 'Réviser mes cours', 'done': false},
        ];
      }

      isLoading = false;
    });

    await LocalStorage.saveTasks(tasks);
  }

  Future<void> addTask() async {
    final title = controller.text.trim();

    if (title.isEmpty) return;

    setState(() {
      tasks.insert(0, {
        'title': title,
        'done': false,
      });
    });

    await LocalStorage.saveTasks(tasks);

    controller.clear();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void showAddTaskDialog() {
    controller.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nouvelle tâche'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Exemple : apprendre Dart',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onSubmitted: (_) => addTask(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: addTask,
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteTask(int index) async {
    setState(() {
      tasks.removeAt(index);
    });

    await LocalStorage.saveTasks(tasks);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TON ORGANISATION',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$completedTasks / ${tasks.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Tâches accomplies',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 18),
                    LinearProgressIndicator(
                      value: tasks.isEmpty
                          ? 0
                          : completedTasks / tasks.length,
                      minHeight: 8,
                      backgroundColor: Colors.white30,
                      valueColor:
                          const AlwaysStoppedAnimation(Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Toutes mes tâches',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : tasks.isEmpty
                        ? const Center(
                            child: Text(
                              'Aucune tâche pour le moment.\n'
                              'Ajoute ta première tâche !',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                height: 1.6,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              final isDone = task['done'] as bool;

                              return Container(
                                margin:
                                    const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 5,
                                  ),
                                  leading: Checkbox(
                                    value: isDone,
                                    activeColor: AppTheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    onChanged: (value) async {
                                      setState(() {
                                        task['done'] = value ?? false;
                                      });

                                      await LocalStorage.saveTasks(
                                        tasks,
                                      );
                                    },
                                  ),
                                  title: Text(
                                    task['title'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      decoration: isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: isDone
                                          ? AppTheme.textMuted
                                          : AppTheme.textDark,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () =>
                                        deleteTask(index),
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}