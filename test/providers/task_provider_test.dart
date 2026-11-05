import 'package:antigravity_todo_test/models/task.dart';
import 'package:antigravity_todo_test/models/task_category.dart';
import 'package:antigravity_todo_test/models/task_priority.dart';
import 'package:antigravity_todo_test/providers/task_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../services/mock_storage_service.dart';

void main() {
  group('TaskProvider Unit Tests', () {
    late MockStorageService mockStorage;
    late TaskProvider provider;

    setUp(() async {
      mockStorage = MockStorageService();
      provider = TaskProvider(storageService: mockStorage);
      await provider.loadTasks();
    });

    test('Initial tasks are loaded from storage', () {
      expect(provider.totalCount, equals(2));
      expect(provider.pendingCount, equals(1));
      expect(provider.completedCount, equals(1));
      expect(provider.completionPercentage, equals(50));
    });

    test('Adding a task increments total and pending count', () async {
      final newTask = Task(
        id: '3',
        title: 'New Added Task',
        category: TaskCategory.study,
        priority: TaskPriority.urgent,
        dueDate: DateTime(2026, 11, 15),
        createdAt: DateTime.now(),
      );

      await provider.addTask(newTask);

      expect(provider.totalCount, equals(3));
      expect(provider.pendingCount, equals(2));
      expect(
        provider.filteredTasks.any((t) => t.title == 'New Added Task'),
        isTrue,
      );
      expect(mockStorage.tasks.length, equals(3));
    });

    test('Toggling task completion updates stats and status', () async {
      expect(provider.completedCount, equals(1));

      await provider.toggleTaskCompletion('1'); // Task 1 was pending

      expect(provider.completedCount, equals(2));
      expect(provider.pendingCount, equals(0));
      expect(provider.completionPercentage, equals(100));

      final task1 = provider.filteredTasks.firstWhere((t) => t.id == '1');
      expect(task1.isCompleted, isTrue);
    });

    test('Updating task fields persists correctly', () async {
      final task1 = provider.filteredTasks.firstWhere((t) => t.id == '1');
      final updated = task1.copyWith(
        title: 'Updated Task 1 Title',
        priority: TaskPriority.urgent,
      );

      await provider.updateTask(updated);

      final found = provider.filteredTasks.firstWhere((t) => t.id == '1');
      expect(found.title, equals('Updated Task 1 Title'));
      expect(found.priority, equals(TaskPriority.urgent));
    });

    test('Deleting a task and undoing deletion works cleanly', () async {
      expect(provider.totalCount, equals(2));

      final deleted = await provider.deleteTask('1');
      expect(deleted?.id, equals('1'));
      expect(provider.totalCount, equals(1));
      expect(provider.canUndo, isTrue);

      await provider.undoDelete();
      expect(provider.totalCount, equals(2));
      expect(provider.filteredTasks.any((t) => t.id == '1'), isTrue);
    });

    test('Filtering by status returns expected subsets', () {
      // Default: all
      expect(provider.filteredTasks.length, equals(2));

      // Pending
      provider.setFilter(TaskFilter.pending);
      expect(provider.filteredTasks.length, equals(1));
      expect(provider.filteredTasks.first.id, equals('1'));

      // Completed
      provider.setFilter(TaskFilter.completed);
      expect(provider.filteredTasks.length, equals(1));
      expect(provider.filteredTasks.first.id, equals('2'));
    });

    test('Filtering by category returns category matches', () {
      provider.setCategoryFilter(TaskCategory.work);
      expect(provider.filteredTasks.length, equals(1));
      expect(provider.filteredTasks.first.category, equals(TaskCategory.work));

      provider.setCategoryFilter(TaskCategory.shopping);
      expect(provider.filteredTasks.isEmpty, isTrue);
    });

    test('Searching query filters tasks by title and description', () {
      provider.setSearchQuery('Description 2');
      expect(provider.filteredTasks.length, equals(1));
      expect(provider.filteredTasks.first.id, equals('2'));

      provider.setSearchQuery('non-existent');
      expect(provider.filteredTasks.isEmpty, isTrue);
    });

    test('Clear completed removes finished tasks', () async {
      expect(provider.completedCount, equals(1));
      await provider.clearCompleted();

      expect(provider.completedCount, equals(0));
      expect(provider.totalCount, equals(1));
      expect(provider.filteredTasks.first.id, equals('1'));
    });
  });
}
