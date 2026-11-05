import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

/// Abstract storage interface to enable testing & loose coupling.
abstract class StorageService {
  Future<List<Task>> loadTasks();
  Future<void> saveTasks(List<Task> tasks);
  Future<void> clearTasks();
}

/// SharedPreferences implementation of [StorageService]
class SharedPreferencesStorageService implements StorageService {
  static const String _tasksKey = 'antigravity_todo_tasks_v1';

  final SharedPreferences? _prefs;

  SharedPreferencesStorageService([this._prefs]);

  Future<SharedPreferences> get _instance async =>
      _prefs ?? await SharedPreferences.getInstance();

  @override
  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await _instance;
      final jsonString = prefs.getString(_tasksKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('Error loading tasks from storage: $e\n$stackTrace');
      return [];
    }
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await _instance;
      final encoded = jsonEncode(tasks.map((task) => task.toJson()).toList());
      await prefs.setString(_tasksKey, encoded);
    } catch (e, stackTrace) {
      debugPrint('Error saving tasks to storage: $e\n$stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearTasks() async {
    try {
      final prefs = await _instance;
      await prefs.remove(_tasksKey);
    } catch (e, stackTrace) {
      debugPrint('Error clearing tasks: $e\n$stackTrace');
    }
  }
}
