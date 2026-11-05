import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Categories for organizing tasks
enum TaskCategory {
  work('Work', Icons.work_outline_rounded, AppColors.categoryWork),
  personal(
    'Personal',
    Icons.person_outline_rounded,
    AppColors.categoryPersonal,
  ),
  shopping('Shopping', Icons.shopping_bag_outlined, AppColors.categoryShopping),
  health('Health', Icons.favorite_outline_rounded, AppColors.categoryHealth),
  study('Study', Icons.school_outlined, AppColors.categoryStudy),
  finance(
    'Finance',
    Icons.account_balance_wallet_outlined,
    AppColors.categoryFinance,
  ),
  other('Other', Icons.label_outline_rounded, AppColors.categoryOther);

  final String label;
  final IconData icon;
  final Color color;

  const TaskCategory(this.label, this.icon, this.color);

  static TaskCategory fromString(String? value) {
    if (value == null) return TaskCategory.other;
    return TaskCategory.values.firstWhere(
      (cat) => cat.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TaskCategory.other,
    );
  }
}
