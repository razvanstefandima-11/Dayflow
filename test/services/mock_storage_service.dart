import 'package:antigravity_todo_test/models/task.dart';
import 'package:antigravity_todo_test/models/task_category.dart';
import 'package:antigravity_todo_test/models/task_priority.dart';
import 'package:antigravity_todo_test/services/storage_service.dart';

/// In-memory implementation of [StorageService] for automated testing
class MockStorageService implements StorageService {
  List<Task> tasks;

  MockStorageService({List<Task>? initialTasks})
    : tasks =
          initialTasks ??
          [
            Task(
              id: '1',
              title: 'Test Task 1',
              description: 'Description 1',
              category: TaskCategory.work,
              priority: TaskPriority.high,
              dueDate: DateTime(2026, 11, 10, 10, 0),
              isCompleted: false,
              createdAt: DateTime(2026, 11, 1),
            ),
            Task(
              id: '2',
              title: 'Test Task 2',
              description: 'Description 2',
              category: TaskCategory.personal,
              priority: TaskPriority.low,
              dueDate: DateTime(2026, 11, 12, 14, 0),
              isCompleted: true,
              createdAt: DateTime(2026, 11, 2),
            ),
          ];

  @override
  Future<List<Task>> loadTasks() async {
    return List.of(tasks);
  }

  @override
  Future<void> saveTasks(List<Task> updatedTasks) async {
    tasks = List.of(updatedTasks);
  }

  @override
  Future<void> clearTasks() async {
    tasks.clear();
  }
}
