import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../models/task_category.dart';
import '../services/storage_service.dart';

enum TaskFilter { all, pending, completed }

enum TaskSort { dueDate, priority, createdAt, alphabetical }

/// Main state management provider for tasks
class TaskProvider extends ChangeNotifier {
  final StorageService _storageService;

  List<Task> _tasks = [];
  bool _isLoading = true;
  String? _errorMessage;

  TaskFilter _activeFilter = TaskFilter.all;
  TaskCategory? _selectedCategory;
  String _searchQuery = '';
  TaskSort _activeSort = TaskSort.dueDate;

  // Undo support
  Task? _lastDeletedTask;
  int? _lastDeletedIndex;

  TaskProvider({StorageService? storageService})
    : _storageService = storageService ?? SharedPreferencesStorageService() {
    loadTasks();
  }

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TaskFilter get activeFilter => _activeFilter;
  TaskCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  TaskSort get activeSort => _activeSort;
  bool get canUndo => _lastDeletedTask != null;

  // Stats
  int get totalCount => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;

  double get completionRate {
    if (_tasks.isEmpty) return 0.0;
    return completedCount / totalCount;
  }

  int get completionPercentage {
    return (completionRate * 100).round();
  }

  /// Returns tasks filtered by status, category, search query, and sorted
  List<Task> get filteredTasks {
    List<Task> list = List.of(_tasks);

    // 1. Filter by completion status
    switch (_activeFilter) {
      case TaskFilter.pending:
        list = list.where((t) => !t.isCompleted).toList();
        break;
      case TaskFilter.completed:
        list = list.where((t) => t.isCompleted).toList();
        break;
      case TaskFilter.all:
        break;
    }

    // 2. Filter by category
    if (_selectedCategory != null) {
      list = list.where((t) => t.category == _selectedCategory).toList();
    }

    // 3. Filter by search query
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      list = list.where((t) {
        final titleMatch = t.title.toLowerCase().contains(query);
        final descMatch = t.description.toLowerCase().contains(query);
        final categoryMatch = t.category.label.toLowerCase().contains(query);
        return titleMatch || descMatch || categoryMatch;
      }).toList();
    }

    // 4. Sort tasks
    list.sort((a, b) {
      // Completed items always sink to the bottom if sorting by due date or priority
      if (_activeSort == TaskSort.dueDate || _activeSort == TaskSort.priority) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
      }

      switch (_activeSort) {
        case TaskSort.dueDate:
          return a.dueDate.compareTo(b.dueDate);
        case TaskSort.priority:
          return b.priority.value.compareTo(a.priority.value);
        case TaskSort.createdAt:
          return b.createdAt.compareTo(a.createdAt);
        case TaskSort.alphabetical:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });

    return list;
  }

  // Actions
  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _storageService.loadTasks();
    } catch (e) {
      _errorMessage = 'Failed to load tasks. Please try again.';
      debugPrint('TaskProvider.loadTasks error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.insert(0, task);
    notifyListeners();
    await _persist();
  }

  Future<void> updateTask(Task updated) async {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final current = _tasks[index];
      _tasks[index] = current.copyWith(isCompleted: !current.isCompleted);
      notifyListeners();
      await _persist();
    }
  }

  Future<Task?> deleteTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final removed = _tasks.removeAt(index);
      _lastDeletedTask = removed;
      _lastDeletedIndex = index;
      notifyListeners();
      await _persist();
      return removed;
    }
    return null;
  }

  Future<void> undoDelete() async {
    if (_lastDeletedTask != null) {
      final insertIndex =
          (_lastDeletedIndex != null && _lastDeletedIndex! <= _tasks.length)
          ? _lastDeletedIndex!
          : 0;
      _tasks.insert(insertIndex, _lastDeletedTask!);
      _lastDeletedTask = null;
      _lastDeletedIndex = null;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> clearCompleted() async {
    _tasks.removeWhere((t) => t.isCompleted);
    notifyListeners();
    await _persist();
  }

  void setFilter(TaskFilter filter) {
    if (_activeFilter != filter) {
      _activeFilter = filter;
      notifyListeners();
    }
  }

  void setCategoryFilter(TaskCategory? category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  void setSort(TaskSort sort) {
    if (_activeSort != sort) {
      _activeSort = sort;
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    try {
      await _storageService.saveTasks(_tasks);
    } catch (e) {
      _errorMessage = 'Failed to save changes.';
      debugPrint('TaskProvider._persist error: $e');
      notifyListeners();
    }
  }
}
