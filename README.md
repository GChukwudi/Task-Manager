# Task Manager - Flutter App

A simple mobile task management application with time tracking.

## Features

- Create, edit, and delete tasks
- Track time spent when completing tasks
- Material Design 3 UI
- Persistent local storage
- Filter by status (All/Active/Completed)
- Responsive design

## Setup

### Prerequisites
- Flutter SDK 3.0.0+
- Dart SDK

### Installation

1. Clone repository:
```bash
git clone https://github.com/GChukwudi/Task-Manager.git
cd task_manager
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run:
```bash
flutter run
```

## Architecture

- **Models**: Task data structure
- **Screens**: Main UI screen
- **Widgets**: Reusable components
- **Utils**: Storage service

## Design Decisions

- **State Management**: StatefulWidget for simplicity
- **Storage**: SharedPreferences for lightweight persistence
- **UI**: Material Design 3 with indigo accent
- **Validation**: Title (required, max 100 chars), Description (optional, max 500 chars)

## Testing
```bash
flutter test
```

## Time Spent

- Planning: 30 min
- Development: 3 hours
- Testing: 45 min
- Documentation: 30 min
- **Total: ~5 hours**

## License

Skill's evaluation purposes