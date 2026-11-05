import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/date_formatter.dart';
import '../models/task.dart';

/// Interactive task card displaying task status, priority, category, and due date
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isOverdue =
        !task.isCompleted && DateFormatter.isOverdue(task.dueDate);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(
        alignment: Alignment.centerLeft,
        color: AppColors.success,
        icon: task.isCompleted
            ? Icons.undo_rounded
            : Icons.check_circle_rounded,
        label: task.isCompleted ? 'Pending' : 'Complete',
      ),
      secondaryBackground: _buildSwipeBackground(
        alignment: Alignment.centerRight,
        color: AppColors.error,
        icon: Icons.delete_outline_rounded,
        label: 'Delete',
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onToggle();
          return false; // Don't remove dismissible, toggle in-place
        } else {
          return true; // Dismiss and trigger onDelete
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: task.isCompleted
                ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))
                : (isDark ? const Color(0xFF334155) : AppColors.outlineVariant),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.2 : (task.isCompleted ? 0.01 : 0.03),
              ),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated completion checkbox
                  GestureDetector(
                    onTap: onToggle,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, right: 12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: task.isCompleted
                              ? AppColors.success
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: task.isCompleted
                                ? AppColors.success
                                : (isDark
                                      ? AppColors.darkOutline
                                      : AppColors.outline),
                            width: 2,
                          ),
                        ),
                        child: task.isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),

                  // Task Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category, Priority, and Menu
                        Row(
                          children: [
                            // Category Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: task.category.color.withValues(
                                  alpha: isDark ? 0.25 : 0.12,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    task.category.icon,
                                    size: 12,
                                    color: task.category.color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    task.category.label,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: task.category.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Priority Indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: task.priority.color.withValues(
                                  alpha: isDark ? 0.25 : 0.12,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    task.priority.icon,
                                    size: 11,
                                    color: task.priority.color,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    task.priority.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: task.priority.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),

                            // Options menu
                            PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                Icons.more_horiz_rounded,
                                size: 20,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textTertiary,
                              ),
                              onSelected: (value) {
                                if (value == 'edit') onEdit();
                                if (value == 'delete') onDelete();
                                if (value == 'toggle') onToggle();
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'toggle',
                                  child: Row(
                                    children: [
                                      Icon(
                                        task.isCompleted
                                            ? Icons.undo_rounded
                                            : Icons
                                                  .check_circle_outline_rounded,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        task.isCompleted
                                            ? 'Mark as Pending'
                                            : 'Mark as Completed',
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                        color: AppColors.secondary,
                                      ),
                                      SizedBox(width: 10),
                                      Text('Edit Task'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18,
                                        color: AppColors.error,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Title
                        Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
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

                        // Description (if present)
                        if (task.description.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ],

                        const SizedBox(height: 10),

                        // Due Date Badge
                        Row(
                          children: [
                            Icon(
                              isOverdue
                                  ? Icons.error_outline_rounded
                                  : Icons.access_time_rounded,
                              size: 14,
                              color: isOverdue
                                  ? AppColors.error
                                  : (task.isCompleted
                                        ? (isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.textTertiary)
                                        : (isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.textSecondary)),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isOverdue
                                  ? 'Overdue (${DateFormatter.formatDueDate(task.dueDate)})'
                                  : DateFormatter.formatDueDate(task.dueDate),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isOverdue
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isOverdue
                                    ? AppColors.error
                                    : (task.isCompleted
                                          ? (isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.textTertiary)
                                          : (isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.textSecondary)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Alignment alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
