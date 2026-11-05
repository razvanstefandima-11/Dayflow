# Antigravity To-Do App

A modern, polished, and full-featured productivity To-Do application built with Flutter & Dart following Material 3 design guidelines.

## Features

- **Dashboard Header**: Time-aware personalized greeting with formatted current date.
- **Productivity Statistics**: Gradient hero card with radial completion progress and live counters for Total, Completed, and Pending tasks.
- **Material 3 Design**: Clean typography, rounded surfaces, subtle drop shadows, and responsive layout.
- **Task Organization**:
  - Add tasks with Title, Description, Category, Priority, and Due Date/Time.
  - 7 task categories with distinct iconography and themed colors (Work, Personal, Shopping, Health, Study, Finance, Other).
  - 4 priority tiers (Low, Medium, High, Urgent).
  - Smart due date tags with overdue highlighting.
- **Interactions**:
  - Swipe right to toggle completion.
  - Swipe left to delete with instant undo option.
  - Quick action menu & modal detail inspection sheet.
- **Search & Filtering**:
  - Instant live search matching title, description, and category.
  - Filter by status tabs: All, Pending, Completed.
  - Filter by category chips.
  - Sort by Due Date, Priority, Creation Date, or Alphabetical.
- **Local Persistence**: Tasks persist across app restarts using local storage (`shared_preferences`).
- **Cross-Platform**: Supports Android, Linux Desktop, and other Flutter platforms.

## Architecture & Code Structure

The project follows a layered architecture separating UI, business logic, models, and data persistence:

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart         # Material 3 color system & semantic tokens
│   │   └── app_theme.dart          # Light and dark ThemeData configurations
│   └── utils/
│       └── date_formatter.dart     # Contextual date & time formatting helpers
├── models/
│   ├── task.dart                   # Core task entity with serialization & copyWith
│   ├── task_category.dart          # Category enum, icons, and colors
│   └── task_priority.dart          # Priority levels and weights
├── services/
│   └── storage_service.dart        # Abstract storage interface & SharedPreferences implementation
├── providers/
│   └── task_provider.dart          # State management via ChangeNotifier
├── widgets/
│   ├── dashboard_header.dart       # Greeting and date display
│   ├── stats_card.dart             # Productivity overview and progress ring
│   ├── filter_bar.dart             # Search bar, status tabs, category chips, sort menu
│   ├── task_card.dart              # Interactive card with swipe gestures
│   ├── empty_state.dart            # Contextual empty state illustrations
│   ├── task_form_sheet.dart        # Task creation and editing bottom sheet
│   └── task_detail_sheet.dart      # Task inspection and action modal
├── screens/
│   └── home_screen.dart            # Main dashboard coordinator
└── main.dart                       # App entrypoint and dependency injection
```

## Getting Started

### Prerequisites

- Flutter SDK 3.13.0+
- Android SDK (for mobile) or Linux build tools (for desktop)

### Installation

```bash
# Clone the repository
git clone https://github.com/razvanstefandima-11/antigravity-todo-app.git
cd antigravity-todo-app

# Get dependencies
flutter pub get

# Run tests
flutter test

# Run static analysis
flutter analyze

# Run on connected device / emulator
flutter run
```

## Running Tests

The test suite covers unit tests for models and providers as well as widget tests for UI interactions:

```bash
flutter test
```

## Changelog

### v1.1.0 - Clean Initial State
- **Empty Task List by Default**: Removed hardcoded sample/example tasks from initial application launch. The application now starts completely clean with an intuitive empty state ready for user-created tasks.
- **Persistence Optimization**: Streamlined `SharedPreferencesStorageService` to load strictly user-persisted tasks with no initialization overhead or unnecessary seed payloads.
- **Test Coverage Expansion**: Added widget test verifying clean dashboard and empty state rendering when no tasks exist.
