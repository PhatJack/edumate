# AGENTS.md

## Project Overview
Edumate is a comprehensive educational platform designed to connect students with expert teachers for live classes, doubt clearing, and course enrollment. The platform features a dual-interface system, allowing users to seamlessly switch between a student and teacher role, each with distinct dashboards and functionalities.

## Tech Stack
- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod
- **Icons**: Material Icons
- **Architecture**: MVVM (Model-View-ViewModel)

## Project Primary Structure
```
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── images.dart
│   │   │   └── sizes.dart
│   │   ├── extensions/
│   │   │   └── theme_extension.dart
│   │   ├── providers/
│   │   │   └── documents_provider.dart
│   │   ├── screens/
│   │   │   ├── chat_screen.dart
│   │   │   ├── details_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── intro_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── profile_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── theme/
│   │   │   └── theme.dart
│   │   └── widgets/
│   │       ├── app_header.dart
│   │       ├── app_layout.dart
│   │       └── app_safearea.dart
│   ├── data/
│   │   └── services/
│   │       └── api_service.dart
│   ├── routes/
│   │   └── app_routes.dart
│   └── main.dart

```

## Key Features
- **Dual Role System**: Seamless switching between Student and Teacher roles.
- **Course Management**: Teachers can create and manage courses; students can enroll and attend.
- **Authentication**: Secure login, registration, and password recovery flows.
- **Responsive Design**: Optimized for both Mobile (Overlay) and Desktop (3-Column) layouts.

## Design System
- **Colors**: Strictly adhere to the color palette defined in `lib/core/theme/theme.dart`. Use the `context.colors` extension for all color references.
- **Typography**: Maintain a professional, minimal font hierarchy. Use system fonts or Google Fonts as specified in the theme.
- **Layout**: Follow the 3-column layout for Desktop and Sidebar/Overlay for Mobile as defined in `EDUMMATE_FSD_en.md`.

## Development Guidelines
- **State Management**: Use `Provider` for state management. Keep logic in ViewModels and UI in Widgets.
- **Imports**: Use package imports (e.g., `import 'package:edumate/...'`) instead of relative imports.
- **Performance**: Use `const` constructors wherever possible and optimize rebuilds using `Consumer` or `Selector`.

## Important Files
- **`EDUMMATE_FSD_en.md`**: Comprehensive Functional Specification Document.
- **`lib/core/theme/theme.dart`**: Centralized theme and color definitions.
- **`lib/core/extensions/theme_extension.dart`**: Theme extension for easy access to colors and typography.
- **`lib/core/screens/`**: List of all screens inside the app
- **`lib/core/widgets/`**: Reusable widgets.
- **`lib/core/constants/`**: Constants for colors, sizes, and other values.
- **`lib/core/providers/`**: Global state management providers.
- **`lib/core/helpers/`**: Helper functions.
- **`lib/routes/`**: App routes.
- **`lib/main.dart`**: App entry point.

