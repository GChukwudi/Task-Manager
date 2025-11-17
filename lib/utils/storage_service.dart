import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';

  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString(_tasksKey);

      if (tasksJson == null || tasksJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = json.decode(tasksJson);
      return decoded.map((item) => Task.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(
        tasks.map((task) => task.toJson()).toList(),
      );
      return await prefs.setString(_tasksKey, encoded);
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_tasksKey);
    } catch (e) {
      return false;
    }
  }
}
