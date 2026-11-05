import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../providers/task_provider.dart';

/// Clean and friendly empty state widget for various filter contexts
class EmptyState extends StatelessWidget {
  final TaskFilter activeFilter;
  final String searchQuery;
  final bool hasCategoryFilter;
  final VoidCallback onAddTask;
  final VoidCallback onClearFilters;

  const EmptyState({
    super.key,
    required this.activeFilter,
    required this.searchQuery,
    required this.hasCategoryFilter,
    required this.onAddTask,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    IconData icon;
    String title;
    String subtitle;
    bool showAddButton = false;
    bool showClearFilters = false;

    if (searchQuery.isNotEmpty || hasCategoryFilter) {
      icon = Icons.search_off_rounded;
      title = 'No tasks match criteria';
      subtitle = 'Try refining your search terms or clearing selected filters.';
      showClearFilters = true;
    } else {
      switch (activeFilter) {
        case TaskFilter.all:
          icon = Icons.task_alt_rounded;
          title = 'No tasks yet';
          subtitle = 'Stay organized and boost productivity by adding your first task.';
          showAddButton = true;
          break;
        case TaskFilter.pending:
          icon = Icons.celebration_rounded;
          title = 'All tasks completed!';
          subtitle = 'Outstanding work! You have no pending items right now. Enjoy your day!';
          showAddButton = true;
          break;
        case TaskFilter.completed:
          icon = Icons.done_all_rounded;
          title = 'No completed tasks';
          subtitle =
              'Check off tasks as you finish them to see your progress here.';
          break;
      }
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryLight.withValues(alpha: 0.15)
                    : AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 42,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            if (showAddButton)
              ElevatedButton.icon(
                onPressed: onAddTask,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Create New Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            if (showClearFilters)
              OutlinedButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                label: const Text('Clear Filters'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
