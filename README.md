# flutter_application

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Local API config

Frontend reads API base URL from compile-time defines:

- Web:

```bash
flutter run -d chrome --dart-define=API_BASE_URL_WEB=http://127.0.0.1:8000 --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

- Android emulator:

```bash
flutter run -d emulator-5554 --dart-define=API_BASE_URL_ANDROID=http://10.0.2.2:8000
```

If no define is passed, app falls back to:

- Web: `http://127.0.0.1:8000`
- Mobile/Android emulator: `http://10.0.2.2:8000`
