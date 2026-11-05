import 'package:flutter/material.dart';

/// App color palette with consistent Material 3 tokens
class AppColors {
  // Primary & Accent
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800
  static const Color primaryContainer = Color(0xFFEEF2FF); // Indigo 50

  static const Color secondary = Color(0xFF0EA5E9); // Sky 500
  static const Color secondaryContainer = Color(0xFFE0F2FE); // Sky 100

  static const Color accent = Color(0xFF8B5CF6); // Purple 500

  // Semantic
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successContainer = Color(0xFFD1FAE5); // Emerald 100
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningContainer = Color(0xFFFEF3C7); // Amber 100
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorContainer = Color(0xFFFEE2E2); // Red 100

  // Neutrals (Light)
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate 100
  static const Color outline = Color(0xFFCBD5E1); // Slate 300
  static const Color outlineVariant = Color(0xFFE2E8F0); // Slate 200

  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400

  // Dark Mode Neutrals
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate 700
  static const Color darkOutline = Color(0xFF475569); // Slate 600
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400

  // Category Colors
  static const Color categoryWork = Color(0xFF3B82F6); // Blue
  static const Color categoryPersonal = Color(0xFF8B5CF6); // Purple
  static const Color categoryShopping = Color(0xFFEC4899); // Pink
  static const Color categoryHealth = Color(0xFF10B981); // Emerald
  static const Color categoryStudy = Color(0xFFF59E0B); // Amber
  static const Color categoryFinance = Color(0xFF14B8A6); // Teal
  static const Color categoryOther = Color(0xFF64748B); // Slate

  // Priority Colors
  static const Color priorityLow = Color(0xFF10B981); // Emerald
  static const Color priorityMedium = Color(0xFFF59E0B); // Amber
  static const Color priorityHigh = Color(0xFFF97316); // Orange
  static const Color priorityUrgent = Color(0xFFEF4444); // Red
}
