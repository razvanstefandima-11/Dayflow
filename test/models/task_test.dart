import 'package:antigravity_todo_test/models/task.dart';
import 'package:antigravity_todo_test/models/task_category.dart';
import 'package:antigravity_todo_test/models/task_priority.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Task Model Tests', () {
    final testDate = DateTime(2026, 11, 5, 12, 0);
    final createdDate = DateTime(2026, 11, 1, 9, 0);

    final task = Task(
      id: 'task-123',
      title: 'Complete Flutter Project',
      description: 'Implement modern M3 design and tests',
      category: TaskCategory.work,
      priority: TaskPriority.urgent,
      dueDate: testDate,
      isCompleted: false,
      createdAt: createdDate,
    );

    test('toJson and fromJson produce identical object', () {
      final json = task.toJson();
      final restored = Task.fromJson(json);

      expect(restored.id, equals(task.id));
      expect(restored.title, equals(task.title));
      expect(restored.description, equals(task.description));
      expect(restored.category, equals(task.category));
      expect(restored.priority, equals(task.priority));
      expect(restored.dueDate, equals(task.dueDate));
      expect(restored.isCompleted, equals(task.isCompleted));
      expect(restored.createdAt, equals(task.createdAt));
      expect(restored, equals(task));
    });

    test('copyWith updates specified fields only', () {
      final updated = task.copyWith(
        title: 'Updated Title',
        isCompleted: true,
        priority: TaskPriority.low,
      );

      expect(updated.id, equals(task.id));
      expect(updated.title, equals('Updated Title'));
      expect(updated.isCompleted, isTrue);
      expect(updated.priority, equals(TaskPriority.low));
      expect(updated.description, equals(task.description));
      expect(updated.category, equals(task.category));
    });

    test('TaskCategory parses case-insensitively with default fallback', () {
      expect(TaskCategory.fromString('WORK'), equals(TaskCategory.work));
      expect(
        TaskCategory.fromString('Personal'),
        equals(TaskCategory.personal),
      );
      expect(
        TaskCategory.fromString('shopping'),
        equals(TaskCategory.shopping),
      );
      expect(
        TaskCategory.fromString('unknown_val'),
        equals(TaskCategory.other),
      );
      expect(TaskCategory.fromString(null), equals(TaskCategory.other));
    });

    test('TaskPriority parses case-insensitively with default fallback', () {
      expect(TaskPriority.fromString('URGENT'), equals(TaskPriority.urgent));
      expect(TaskPriority.fromString('Low'), equals(TaskPriority.low));
      expect(TaskPriority.fromString('high'), equals(TaskPriority.high));
      expect(TaskPriority.fromString('unknown'), equals(TaskPriority.medium));
      expect(TaskPriority.fromString(null), equals(TaskPriority.medium));
    });
  });
}
