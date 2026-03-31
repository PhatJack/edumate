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
│   │   ├── config/
│   │   │   └── app_config.dart
│   │   ├── constants/
│   │   │   ├── images.dart
│   │   │   └── sizes.dart
│   │   ├── exceptions/
│   │   │   └── api_exception.dart
│   │   ├── extensions/
│   │   │   └── theme_extension.dart
│   │   ├── helpers/
│   │   ├── providers/
│   │   │   ├── documents_provider.dart
│   │   │   ├── documents_state_provider.dart
│   │   │   └── profile_provider.dart
│   │   ├── screens/
│   │   │   ├── chat_screen.dart
│   │   │   ├── details_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── intro_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── theme/
│   │   │   └── theme.dart
│   │   ├── utils/
│   │   └── widgets/
│   │       ├── app_header.dart
│   │       ├── app_layout.dart
│   │       ├── app_safearea.dart
│   │       ├── chat/
│   │       ├── confirm_action_modal.dart
│   │       └── guided_tour_modal.dart
│   ├── data/
│   │   ├── constants/
│   │   │   └── api_endpoints.dart
│   │   ├── models/
│   │   │   ├── api_envelope.dart
│   │   │   ├── auth_models.dart
│   │   │   ├── chat_models.dart
│   │   │   ├── document_models.dart
│   │   │   ├── paginated_response.dart
│   │   │   ├── profile_models.dart
│   │   │   ├── upload_models.dart
│   │   │   └── user_models.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── base_repository.dart
│   │   │   ├── chat_repository.dart
│   │   │   ├── documents_repository.dart
│   │   │   ├── profile_repository.dart
│   │   │   ├── uploads_repository.dart
│   │   │   └── users_repository.dart
│   │   └── services/
│   │       ├── api_service.dart
│   │       ├── http_adapter_config.dart
│   │       ├── http_adapter_config_stub.dart
│   │       └── http_adapter_config_web.dart
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
- **Layout**: Follow the 3-column layout for Desktop and Sidebar/Overlay for Mobile as defined in `EDUMATE_FSD_en.md`.

## Development Guidelines

- **State Management**: Use `Provider` for state management. Keep logic in ViewModels and UI in Widgets.
- **Imports**: Use package imports (e.g., `import 'package:edumate/...'`) instead of relative imports.
- **Performance**: Use `const` constructors wherever possible and optimize rebuilds using `Consumer` or `Selector`.

## Important Files

- **`EDUMATE_FSD_en.md`**: Comprehensive Functional Specification Document.
- **`lib/core/theme/theme.dart`**: Centralized theme and color definitions.
- **`lib/core/extensions/theme_extension.dart`**: Theme extension for easy access to colors and typography.
- **`lib/core/config/`**: Application configuration files.
- **`lib/core/constants/`**: Constants for colors, sizes, images, and other static values.
- **`lib/core/exceptions/`**: Custom exception definitions for error handling.
- **`lib/core/screens/`**: All screen/page components.
- **`lib/core/providers/`**: Global state management providers using Riverpod.
- **`lib/core/widgets/`**: Reusable UI widgets and components.
- **`lib/core/helpers/`**: Helper functions and utilities.
- **`lib/core/utils/`**: Utility functions and tools.
- **`lib/data/constants/`**: Data layer constants (e.g., API endpoints).
- **`lib/data/models/`**: Data models and DTOs for API responses.
- **`lib/data/repositories/`**: Repository pattern implementation for data access.
- **`lib/data/services/`**: API service and HTTP configuration.
- **`lib/routes/`**: App routing and navigation configuration.
- **`lib/main.dart`**: App entry point.
