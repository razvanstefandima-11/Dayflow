import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utilities for formatting dates, times, and relative greetings.
class DateFormatter {
  static final DateFormat _dayMonthFormat = DateFormat('EEE, MMM d');
  static final DateFormat _fullDateFormat = DateFormat('EEEE, MMMM d, y');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _shortDateWithYear = DateFormat('MMM d, y');

  /// Returns today's formatted date, e.g. "Thursday, November 5, 2026"
  static String formatTodayFull([DateTime? date]) {
    return _fullDateFormat.format(date ?? DateTime.now());
  }

  /// Formats date for dashboard header, e.g. "Thu, Nov 5"
  static String formatHeaderDate([DateTime? date]) {
    return _dayMonthFormat.format(date ?? DateTime.now());
  }

  /// Returns a contextual human-friendly due date string:
  /// e.g. "Today, 5:00 PM", "Tomorrow", "Yesterday (Overdue)", "Nov 12"
  static String formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final difference = taskDate.difference(today).inDays;

    final timeString = _timeFormat.format(dueDate);
    final hasSpecificTime = dueDate.hour != 0 || dueDate.minute != 0;

    if (difference == 0) {
      return hasSpecificTime ? 'Today, $timeString' : 'Today';
    } else if (difference == 1) {
      return hasSpecificTime ? 'Tomorrow, $timeString' : 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference < -1) {
      return _shortDateWithYear.format(dueDate);
    } else if (difference < 7) {
      final weekday = DateFormat('EEEE').format(dueDate);
      return hasSpecificTime ? '$weekday, $timeString' : weekday;
    } else {
      return _shortDateWithYear.format(dueDate);
    }
  }

  /// Check if a date is overdue compared to now
  static bool isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }

  /// Returns appropriate greeting based on hour of day
  static String getGreeting([DateTime? date]) {
    final hour = (date ?? DateTime.now()).hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  /// Format time of day e.g. "3:30 PM"
  static String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return _timeFormat.format(dt);
  }
}
