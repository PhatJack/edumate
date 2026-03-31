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

## 3. Cau hinh bien moi truong

Du an dung 2 bien the pubspec:
- pubspec.mobile.yaml: co asset .env cho Android/iOS.
- pubspec.web.yaml: khong dua .env vao web build.

### File .env cho local mobile

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
GOOGLE_WEB_CLIENT_ID=your_google_web_client_id
```

### Chon bien the pubspec khi build local

PowerShell:

```powershell
Copy-Item pubspec.mobile.yaml pubspec.yaml -Force
flutter pub get
```

Web local (neu can test khong dung .env):

```powershell
Copy-Item pubspec.web.yaml pubspec.yaml -Force
flutter pub get
```

Luu y:
- FIREBASE_PROJECT_ID phai trung voi project ma backend dang verify Firebase ID token.
- Neu chay Android emulator, dung 10.0.2.2 de goi ve backend local.

## 4. Cau hinh Vercel (web)

Da co san script build web cho Vercel: scripts/build_web_vercel.sh

Script nay se:
1. Chuyen sang pubspec.web.yaml (khong co .env asset).
2. Chay flutter pub get.
3. Build web voi --dart-define lay tu Environment Variables tren Vercel.

vercel.json da duoc cap nhat voi buildCommand:

```json
{
  "buildCommand": "bash ./scripts/build_web_vercel.sh",
  "outputDirectory": "build/web"
}
```

Trong Vercel Dashboard, vao Project Settings > Environment Variables va dam bao co cac key:
- API_BASE_URL
- API_BASE_URL_WEB
- FIREBASE_API_KEY
- FIREBASE_AUTH_DOMAIN
- FIREBASE_PROJECT_ID
- FIREBASE_STORAGE_BUCKET
- FIREBASE_MESSAGING_SENDER_ID
- FIREBASE_APP_ID
- GOOGLE_WEB_CLIENT_ID

Sau do redeploy.

## 5. Chay backend local (khuyen nghi)

Trong folder edumate-api:

```bash
uv sync
uv run uvicorn src.main:app --reload
```

Mac dinh backend chay tai http://127.0.0.1:8000.

## 6. Chay Flutter app

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

## 7. Cac lenh thuong dung

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

## 8. Troubleshooting nhanh

- Loi CORS khi login web: kiem tra CORS_ORIGINS hoac CORS_ORIGINS_REGEX ben backend.
- Loi audience Firebase ID token: kiem tra FIREBASE_PROJECT_ID ben FE va service account ben BE phai cung project.
- Loi ket noi backend tren Android emulator: dam bao API_BASE_URL_ANDROID dung 10.0.2.2.
- Loi JSObject/JSAny khi build Android: tranh import truc tiep thu vien web-only (vi du package:dio/browser.dart) trong code dung chung; dung conditional import theo platform.
