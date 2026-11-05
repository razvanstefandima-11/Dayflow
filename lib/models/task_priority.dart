import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Priority levels for tasks
enum TaskPriority {
  low('Low', AppColors.priorityLow, Icons.arrow_downward_rounded, 1),
  medium('Medium', AppColors.priorityMedium, Icons.remove_rounded, 2),
  high('High', AppColors.priorityHigh, Icons.arrow_upward_rounded, 3),
  urgent('Urgent', AppColors.priorityUrgent, Icons.priority_high_rounded, 4);

  final String label;
  final Color color;
  final IconData icon;
  final int value;

  const TaskPriority(this.label, this.color, this.icon, this.value);

  static TaskPriority fromString(String? value) {
    if (value == null) return TaskPriority.medium;
    return TaskPriority.values.firstWhere(
      (p) => p.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TaskPriority.medium,
    );
  }
}
