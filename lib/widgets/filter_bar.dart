import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../models/task_category.dart';
import '../providers/task_provider.dart';

/// Interactive filter bar with search, status tabs, category chips, and sort menu
class FilterBar extends StatelessWidget {
  final TextEditingController searchController;

  const FilterBar({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: TextField(
                controller: searchController,
                onChanged: provider.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search tasks, descriptions, categories...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 22),
                  suffixIcon: provider.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () {
                            searchController.clear();
                            provider.setSearchQuery('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
                      : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDark
                          ? const Color(0xFF334155)
                          : AppColors.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            // Status Tabs (All, Pending, Completed) & Sort Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceVariant.withValues(
                                alpha: 0.6,
                              )
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          _buildFilterTab(
                            context: context,
                            title: 'All',
                            count: provider.totalCount,
                            isSelected: provider.activeFilter == TaskFilter.all,
                            onTap: () => provider.setFilter(TaskFilter.all),
                          ),
                          _buildFilterTab(
                            context: context,
                            title: 'Pending',
                            count: provider.pendingCount,
                            isSelected:
                                provider.activeFilter == TaskFilter.pending,
                            onTap: () => provider.setFilter(TaskFilter.pending),
                          ),
                          _buildFilterTab(
                            context: context,
                            title: 'Done',
                            count: provider.completedCount,
                            isSelected:
                                provider.activeFilter == TaskFilter.completed,
                            onTap: () =>
                                provider.setFilter(TaskFilter.completed),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Sort Popup Menu
                  PopupMenuButton<TaskSort>(
                    icon: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurfaceVariant.withValues(
                                alpha: 0.6,
                              )
                            : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : AppColors.outlineVariant,
                        ),
                      ),
                      child: const Icon(
                        Icons.sort_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    tooltip: 'Sort tasks',
                    initialValue: provider.activeSort,
                    onSelected: provider.setSort,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: TaskSort.dueDate,
                        child: Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 18),
                            SizedBox(width: 10),
                            Text('Due Date'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: TaskSort.priority,
                        child: Row(
                          children: [
                            Icon(Icons.flag_outlined, size: 18),
                            SizedBox(width: 10),
                            Text('Priority'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: TaskSort.createdAt,
                        child: Row(
                          children: [
                            Icon(Icons.history_rounded, size: 18),
                            SizedBox(width: 10),
                            Text('Creation Date'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: TaskSort.alphabetical,
                        child: Row(
                          children: [
                            Icon(Icons.sort_by_alpha_rounded, size: 18),
                            SizedBox(width: 10),
                            Text('Alphabetical'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Category Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _buildCategoryChip(
                    label: 'All Categories',
                    icon: Icons.apps_rounded,
                    color: AppColors.primary,
                    isSelected: provider.selectedCategory == null,
                    onTap: () => provider.setCategoryFilter(null),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  ...TaskCategory.values.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildCategoryChip(
                        label: cat.label,
                        icon: cat.icon,
                        color: cat.color,
                        isSelected: provider.selectedCategory == cat,
                        onTap: () {
                          if (provider.selectedCategory == cat) {
                            provider.setCategoryFilter(null);
                          } else {
                            provider.setCategoryFilter(cat);
                          }
                        },
                        isDark: isDark,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterTab({
    required BuildContext context,
    required String title,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.primaryDark : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.white : AppColors.primary)
                        : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.05)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? (isDark ? Colors.white : AppColors.primary)
                          : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: isDark ? 0.35 : 0.15)
              : (isDark
                    ? AppColors.darkSurfaceVariant.withValues(alpha: 0.4)
                    : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? const Color(0xFF334155) : AppColors.outlineVariant),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected
                  ? color
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : color)
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
