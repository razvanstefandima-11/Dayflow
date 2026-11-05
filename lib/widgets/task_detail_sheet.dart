import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/date_formatter.dart';
import '../models/task.dart';

/// Modal bottom sheet showing full task details and quick management actions
class TaskDetailSheet extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskDetailSheet({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  static Future<void> show({
    required BuildContext context,
    required Task task,
    required VoidCallback onToggle,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailSheet(
        task: task,
        onToggle: onToggle,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isOverdue =
        !task.isCompleted && DateFormatter.isOverdue(task.dueDate);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top action bar
            Row(
              children: [
                // Category Chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: task.category.color.withValues(
                      alpha: isDark ? 0.25 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        task.category.icon,
                        size: 14,
                        color: task.category.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        task.category.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: task.category.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Priority Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: task.priority.color.withValues(
                      alpha: isDark ? 0.25 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        task.priority.icon,
                        size: 13,
                        color: task.priority.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.priority.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: task.priority.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Close Button
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Completion Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? AppColors.success.withValues(alpha: isDark ? 0.2 : 0.1)
                    : (isOverdue
                          ? AppColors.error.withValues(
                              alpha: isDark ? 0.2 : 0.08,
                            )
                          : AppColors.primary.withValues(
                              alpha: isDark ? 0.15 : 0.06,
                            )),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    task.isCompleted
                        ? Icons.check_circle_rounded
                        : (isOverdue
                              ? Icons.warning_amber_rounded
                              : Icons.schedule_rounded),
                    size: 18,
                    color: task.isCompleted
                        ? AppColors.success
                        : (isOverdue ? AppColors.error : AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    task.isCompleted
                        ? 'Completed'
                        : (isOverdue ? 'Overdue Task' : 'Pending Completion'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: task.isCompleted
                          ? AppColors.success
                          : (isOverdue ? AppColors.error : AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              task.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
                color: task.isCompleted
                    ? (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textTertiary)
                    : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 12),

            // Description
            if (task.description.trim().isNotEmpty) ...[
              Text(
                task.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Meta Info (Due Date & Created At)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
                    : AppColors.surfaceVariant.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.event_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Due:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${DateFormat('EEEE, MMM d, y').format(task.dueDate)} at ${DateFormatter.formatTimeOfDay(TimeOfDay.fromDateTime(task.dueDate))}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isOverdue ? AppColors.error : null,
                          fontWeight: isOverdue ? FontWeight.bold : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Created:',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('MMM d, y • h:mm a').format(task.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                // Toggle Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onToggle();
                    },
                    icon: Icon(
                      task.isCompleted
                          ? Icons.undo_rounded
                          : Icons.check_circle_rounded,
                      size: 20,
                    ),
                    label: Text(
                      task.isCompleted ? 'Mark Pending' : 'Mark Completed',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task.isCompleted
                          ? (isDark
                                ? AppColors.darkSurfaceVariant
                                : AppColors.surfaceVariant)
                          : AppColors.primary,
                      foregroundColor: task.isCompleted
                          ? (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary)
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Edit Button
                IconButton.filledTonal(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onEdit();
                  },
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Edit task',
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Delete Button
                IconButton.filledTonal(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _confirmDelete(context);
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: AppColors.error,
                  ),
                  tooltip: 'Delete task',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(
                      alpha: isDark ? 0.2 : 0.1,
                    ),
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text(
          'Are you sure you want to delete "${task.title}"? You can undo this immediately from the snackbar notification.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
