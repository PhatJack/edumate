# Edumate Flutter App

Ung dung Flutter cho Edumate.

## 1. Cai Flutter

1. Cai Flutter SDK theo huong dan chinh thuc:
	https://docs.flutter.dev/get-started/install
2. Kiem tra moi truong:

```bash
flutter --version
flutter doctor -v
```

Neu flutter doctor bao thieu Android SDK, Chrome, hoac Visual Studio Build Tools thi cai bo sung theo huong dan cua flutter doctor.

## 2. Chuan bi project

Trong folder edumate:

```bash
flutter pub get
```

## 3. Cau hinh .env

Project nay doc config runtime tu file .env (khong dung dart-define nua).

Tao hoac cap nhat file .env trong root cua app Flutter voi cac key toi thieu:

```env
API_BASE_URL=http://127.0.0.1:8000/api/v1
API_BASE_URL_WEB=http://127.0.0.1:8000/api/v1
API_BASE_URL_ANDROID=http://10.0.2.2:8000/api/v1

FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_STORAGE_BUCKET=your_project.firebasestorage.app
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id
```

Luu y:
- FIREBASE_PROJECT_ID phai trung voi project ma backend dang verify Firebase ID token.
- Neu chay Android emulator, dung 10.0.2.2 de goi ve backend local.

## 4. Chay backend local (khuyen nghi)

Trong folder edumate-api:

```bash
uv sync
uv run uvicorn src.main:app --reload
```

Mac dinh backend chay tai http://127.0.0.1:8000.

## 5. Chay Flutter app

### Web (Chrome)

```bash
flutter run -d chrome --web-port 7001
```

### Android Emulator

```bash
flutter run -d RF8R10K1NGX
```

### Kiem tra danh sach thiet bi

```bash
flutter devices
```

## 6. Cac lenh thuong dung

```bash
flutter pub get
flutter analyze
flutter test
flutter clean
```

Neu can reset dependency:

```bash
flutter clean
flutter pub get
```

## 7. Troubleshooting nhanh

- Loi CORS khi login web: kiem tra CORS_ORIGINS hoac CORS_ORIGINS_REGEX ben backend.
- Loi audience Firebase ID token: kiem tra FIREBASE_PROJECT_ID ben FE va service account ben BE phai cung project.
- Loi ket noi backend tren Android emulator: dam bao API_BASE_URL_ANDROID dung 10.0.2.2.
- Loi `JSObject`/`JSAny` khi build Android: tranh import truc tiep thu vien web-only (vi du `package:dio/browser.dart`) trong code dung chung; dung conditional import theo platform.
