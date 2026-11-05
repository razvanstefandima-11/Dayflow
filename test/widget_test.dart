import 'package:antigravity_todo_test/main.dart';
import 'package:antigravity_todo_test/widgets/empty_state.dart';
import 'package:antigravity_todo_test/widgets/stats_card.dart';
import 'package:antigravity_todo_test/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'services/mock_storage_service.dart';

void main() {
  setUp(() {
    // Standard mobile viewport
  });

  testWidgets('AntigravityTodoApp renders dashboard and task items', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(() => tester.view.resetPhysicalSize());

    final mockStorage = MockStorageService();

    await tester.pumpWidget(AntigravityTodoApp(storageService: mockStorage));
    await tester.pumpAndSettle();

    // Verify AppBar title
    expect(find.text('Tasks'), findsOneWidget);

    // Verify StatsCard is present
    expect(find.byType(StatsCard), findsOneWidget);
    expect(find.text('Task Overview'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    // "Pending" appears in stats card and filter bar
    expect(find.text('Pending'), findsNWidgets(2));

    // Verify task items from mock storage
    expect(find.text('Test Task 1'), findsOneWidget);
    expect(find.text('Test Task 2'), findsOneWidget);
    expect(find.byType(TaskCard), findsNWidgets(2));

    // Verify FAB
    expect(find.text('New Task'), findsOneWidget);
  });

  testWidgets('Tapping New Task opens the creation sheet and adds task', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(() => tester.view.resetPhysicalSize());

    final mockStorage = MockStorageService();

    await tester.pumpWidget(AntigravityTodoApp(storageService: mockStorage));
    await tester.pumpAndSettle();

    // Tap New Task FAB
    await tester.tap(find.text('New Task'));
    await tester.pumpAndSettle();

    // Verify Bottom Sheet appeared
    expect(find.text('New Task'), findsWidgets);
    expect(find.text('Task Title *'), findsOneWidget);
    expect(find.text('Create Task'), findsOneWidget);

    // Enter title
    await tester.enterText(
      find.widgetWithText(TextFormField, 'What needs to be done?'),
      'Ship Flutter Feature',
    );
    await tester.pumpAndSettle();

    // Tap Create Task
    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();

    // Verify task was added to list
    expect(find.text('Ship Flutter Feature'), findsOneWidget);
  });

  testWidgets('Filter tabs switch between All, Pending, and Done', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(() => tester.view.resetPhysicalSize());

    final mockStorage = MockStorageService();

    await tester.pumpWidget(AntigravityTodoApp(storageService: mockStorage));
    await tester.pumpAndSettle();

    // Both tasks visible under 'All'
    expect(find.text('Test Task 1'), findsOneWidget);
    expect(find.text('Test Task 2'), findsOneWidget);

    // Tap 'Pending' tab (the one in the filter bar)
    await tester.tap(find.widgetWithText(GestureDetector, 'Pending'));
    await tester.pumpAndSettle();

    // Only Test Task 1 should be visible (Pending)
    expect(find.text('Test Task 1'), findsOneWidget);
    expect(find.text('Test Task 2'), findsNothing);

    // Tap 'Done' tab
    await tester.tap(find.widgetWithText(GestureDetector, 'Done'));
    await tester.pumpAndSettle();

    // Only Test Task 2 should be visible (Completed)
    expect(find.text('Test Task 1'), findsNothing);
    expect(find.text('Test Task 2'), findsOneWidget);
  });

  testWidgets('AntigravityTodoApp renders empty state when no tasks exist', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(() => tester.view.resetPhysicalSize());

    final mockStorage = MockStorageService(initialTasks: []);

    await tester.pumpWidget(AntigravityTodoApp(storageService: mockStorage));
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('No tasks yet'), findsNWidgets(2));
    expect(
      find.text(
        'Stay organized and boost productivity by adding your first task.',
      ),
      findsOneWidget,
    );
    expect(find.byType(TaskCard), findsNothing);
  });
}
