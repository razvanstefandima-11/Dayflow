import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/empty_state.dart';
import '../widgets/filter_bar.dart';
import '../widgets/stats_card.dart';
import '../widgets/task_card.dart';
import '../widgets/task_detail_sheet.dart';
import '../widgets/task_form_sheet.dart';

/// Main home dashboard screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddTaskSheet(BuildContext context) {
    TaskFormSheet.show(
      context: context,
      onSave: (newTask) {
        context.read<TaskProvider>().addTask(newTask);
        _showSnackBar(
          context,
          'Task created successfully!',
          icon: Icons.check_circle_rounded,
        );
      },
    );
  }

  void _openEditTaskSheet(BuildContext context, Task task) {
    TaskFormSheet.show(
      context: context,
      taskToEdit: task,
      onSave: (updatedTask) {
        context.read<TaskProvider>().updateTask(updatedTask);
        _showSnackBar(
          context,
          'Task updated successfully!',
          icon: Icons.edit_rounded,
        );
      },
    );
  }

  void _openTaskDetailSheet(BuildContext context, Task task) {
    final provider = context.read<TaskProvider>();
    TaskDetailSheet.show(
      context: context,
      task: task,
      onToggle: () => provider.toggleTaskCompletion(task.id),
      onEdit: () => _openEditTaskSheet(context, task),
      onDelete: () => _deleteTaskWithUndo(context, task),
    );
  }

  void _deleteTaskWithUndo(BuildContext context, Task task) {
    final provider = context.read<TaskProvider>();
    provider.deleteTask(task.id);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${task.title}"'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.primaryLight,
          onPressed: () {
            provider.undoDelete();
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, {IconData? icon}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showClearCompletedDialog(BuildContext context) {
    final provider = context.read<TaskProvider>();
    final completedCount = provider.completedCount;

    if (completedCount == 0) {
      _showSnackBar(context, 'No completed tasks to clear.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed Tasks?'),
        content: Text(
          'This will permanently remove $completedCount completed ${completedCount == 1 ? "task" : "tasks"}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider.clearCompleted();
              _showSnackBar(
                context,
                'Cleared $completedCount completed tasks.',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'More actions',
            onSelected: (value) {
              if (value == 'clear_completed') {
                _showClearCompletedDialog(context);
              } else if (value == 'refresh') {
                context.read<TaskProvider>().loadTasks();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_completed',
                child: Row(
                  children: [
                    Icon(
                      Icons.cleaning_services_rounded,
                      size: 20,
                      color: AppColors.warning,
                    ),
                    SizedBox(width: 12),
                    Text('Clear Completed'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded, size: 20),
                    SizedBox(width: 12),
                    Text('Reload from Storage'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTaskSheet(context),
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'New Task',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final tasks = provider.filteredTasks;

            return RefreshIndicator(
              onRefresh: () => provider.loadTasks(),
              color: AppColors.primary,
              child: CustomScrollView(
                slivers: [
                  // Dashboard Header
                  const SliverToBoxAdapter(child: DashboardHeader()),

                  // Statistics Card
                  const SliverToBoxAdapter(child: StatsCard()),

                  // Filter & Search Controls
                  SliverToBoxAdapter(
                    child: FilterBar(searchController: _searchController),
                  ),

                  // Section Title & Counter
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            provider.activeFilter == TaskFilter.all
                                ? 'All Tasks'
                                : provider.activeFilter == TaskFilter.pending
                                ? 'Pending Tasks'
                                : 'Completed Tasks',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            '${tasks.length} ${tasks.length == 1 ? "item" : "items"}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Task List or Empty State
                  if (tasks.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        activeFilter: provider.activeFilter,
                        searchQuery: provider.searchQuery,
                        hasCategoryFilter: provider.selectedCategory != null,
                        onAddTask: () => _openAddTaskSheet(context),
                        onClearFilters: () {
                          _searchController.clear();
                          provider.setSearchQuery('');
                          provider.setCategoryFilter(null);
                          provider.setFilter(TaskFilter.all);
                        },
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 96),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final task = tasks[index];
                          return TaskCard(
                            key: ValueKey(task.id),
                            task: task,
                            onToggle: () =>
                                provider.toggleTaskCompletion(task.id),
                            onTap: () => _openTaskDetailSheet(context, task),
                            onEdit: () => _openEditTaskSheet(context, task),
                            onDelete: () => _deleteTaskWithUndo(context, task),
                          );
                        }, childCount: tasks.length),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
