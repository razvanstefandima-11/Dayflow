import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';
import '../models/task_category.dart';
import '../models/task_priority.dart';

/// Abstract storage interface to enable testing & loose coupling.
abstract class StorageService {
  Future<List<Task>> loadTasks();
  Future<void> saveTasks(List<Task> tasks);
  Future<void> clearTasks();
}

/// SharedPreferences implementation of [StorageService]
class SharedPreferencesStorageService implements StorageService {
  static const String _tasksKey = 'antigravity_todo_tasks_v1';
  static const String _initializedKey = 'antigravity_todo_initialized_v1';

  final SharedPreferences? _prefs;

  SharedPreferencesStorageService([this._prefs]);

  Future<SharedPreferences> get _instance async =>
      _prefs ?? await SharedPreferences.getInstance();

  @override
  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await _instance;
      final isInitialized = prefs.getBool(_initializedKey) ?? false;

      if (!isInitialized) {
        // Seed default sample tasks for a rich initial experience
        final initialTasks = _generateInitialTasks();
        await saveTasks(initialTasks);
        await prefs.setBool(_initializedKey, true);
        return initialTasks;
      }

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

  /// Initial sample tasks to showcase the modern UI on fresh launch
  List<Task> _generateInitialTasks() {
    const uuid = Uuid();
    final now = DateTime.now();

    return [
      Task(
        id: uuid.v4(),
        title: 'Review Flutter Android architecture',
        description: 'Inspect Material 3 theming, state management, and responsive layouts.',
        category: TaskCategory.work,
        priority: TaskPriority.high,
        dueDate: now.add(const Duration(hours: 3)),
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: uuid.v4(),
        title: 'Plan grocery shopping',
        description: 'Milk, organic sourdough, fresh berries, and olive oil.',
        category: TaskCategory.shopping,
        priority: TaskPriority.medium,
        dueDate: now.add(const Duration(hours: 5)),
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      Task(
        id: uuid.v4(),
        title: 'Daily 30-minute cardio workout',
        description: 'Zone 2 running session or cycling.',
        category: TaskCategory.health,
        priority: TaskPriority.urgent,
        dueDate: now.add(const Duration(days: 1, hours: 2)),
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      Task(
        id: uuid.v4(),
        title: 'Read Dart Concurrency & Isolates article',
        description: 'Deep dive into Dart 3 background isolates and actor model patterns.',
        category: TaskCategory.study,
        priority: TaskPriority.low,
        dueDate: now.add(const Duration(days: 2)),
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ];
  }
}
