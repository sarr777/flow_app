
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _tasksKey = 'flow_tasks';
  static const String _habitsKey = 'flow_habits';
  static const String _nameKey = 'flow_user_name';

  // Enregistrer les tâches
  static Future<void> saveTasks(
    List<Map<String, dynamic>> tasks,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _tasksKey,
      jsonEncode(tasks),
    );
  }

  // Charger les tâches
  static Future<List<Map<String, dynamic>>?> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_tasksKey);

    if (data == null) return null;

    final decoded = jsonDecode(data) as List;

    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  // Enregistrer les habitudes
  static Future<void> saveHabits(
    List<Map<String, dynamic>> habits,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _habitsKey,
      jsonEncode(habits),
    );
  }

  // Charger les habitudes
  static Future<List<Map<String, dynamic>>?> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_habitsKey);

    if (data == null) return null;

    final decoded = jsonDecode(data) as List;

    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  // Enregistrer le nom
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_nameKey, name);
  }

  // Charger le nom
  static Future<String?> loadName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_nameKey);
  }
}
