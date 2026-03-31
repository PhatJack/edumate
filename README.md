# Ứng Dụng Mobile Edumate

## Giới Thiệu

**Edumate** là nền tảng giáo dục toàn diện được thiết kế để kết nối học sinh với các giáo viên chuyên gia cho các lớp học trực tiếp, giải đáp thắc mắc và đăng ký khóa học. Ứng dụng hỗ trợ cơ chế chuyển đổi vai trò kép giữa học sinh và giáo viên, mỗi vai trò có giao diện và chức năng riêng biệt.

### Tính Năng Chính
- **Hệ Thống Vai Trò Kép**: Chuyển đổi liền mạch giữa vai trò học sinh và giáo viên
- **Quản Lý Khóa Học**: Giáo viên tạo và quản lý khóa học; học sinh đăng ký và tham gia
- **Xác Thực**: Luồng đăng nhập, đăng ký và khôi phục mật khẩu an toàn
- **Thiết Kế Đáp Ứng**: Tối ưu hóa cho cả thiết bị di động (giao diện chồng) và máy tính để bàn (bố cục 3 cột)

---

## 1. Cài Đặt Flutter

1. Cài đặt Flutter SDK theo hướng dẫn chính thức:
   https://docs.flutter.dev/get-started/install
2. Kiểm tra môi trường:

```bash
flutter --version
flutter doctor -v
```

Nếu flutter doctor báo thiếu Android SDK, Chrome, hoặc Visual Studio Build Tools thì cài bổ sung theo hướng dẫn của flutter doctor.

## 2. Chuẩn Bị Dự Án

Trong thư mục edumate:

```bash
flutter pub get
```

## 3. Cấu Hình Biến Môi Trường

Dự án sử dụng 2 biến thể pubspec:
- pubspec.mobile.yaml: có tài sản .env cho Android/iOS.
- pubspec.web.yaml: không đưa .env vào web build.

### Tệp .env cho di động cục bộ

Tạo hoặc cập nhật tệp .env trong thư mục gốc của ứng dụng Flutter với các khóa tối thiểu:

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

### Chọn biến thể pubspec khi xây dựng cục bộ

PowerShell:

```powershell
Copy-Item pubspec.mobile.yaml pubspec.yaml -Force
flutter pub get
```

Web cục bộ (nếu cần kiểm tra không sử dụng .env):

```powershell
Copy-Item pubspec.web.yaml pubspec.yaml -Force
flutter pub get
```

Lưu ý:
- FIREBASE_PROJECT_ID phải trùng với dự án mà backend đang xác minh Firebase ID token.
- Nếu chạy trình giả lập Android, dùng 10.0.2.2 để gọi về backend cục bộ.

## 4. Cấu Hình Vercel (Web)

Đã có sẵn tập lệnh xây dựng web cho Vercel: scripts/build_web_vercel.sh

Tập lệnh này sẽ:
1. Chuyển sang pubspec.web.yaml (không có tài sản .env).
2. Chạy flutter pub get.
3. Xây dựng web với --dart-define lấy từ Biến Môi Trường trên Vercel.

vercel.json đã được cập nhật với buildCommand:

```json
{
  "buildCommand": "bash ./scripts/build_web_vercel.sh",
  "outputDirectory": "build/web"
}
```

Trong Bảng Điều Khiển Vercel, vào Project Settings > Environment Variables và đảm bảo có các khóa:
- API_BASE_URL
- API_BASE_URL_WEB
- FIREBASE_API_KEY
- FIREBASE_AUTH_DOMAIN
- FIREBASE_PROJECT_ID
- FIREBASE_STORAGE_BUCKET
- FIREBASE_MESSAGING_SENDER_ID
- FIREBASE_APP_ID
- GOOGLE_WEB_CLIENT_ID

Sau đó triển khai lại.

## 5. Chạy Backend Cục Bộ (được khuyến nghị)

Trong thư mục edumate-api:

```bash
uv sync
uv run uvicorn src.main:app --reload
```

Mặc định backend chạy tại http://127.0.0.1:8000.

## 6. Chạy Ứng Dụng Flutter

### Web (Chrome)

```bash
flutter run -d chrome --web-port 7001
```

### Trình Giả Lập Android

```bash
flutter run -d RF8R10K1NGX
```

### Kiểm Tra Danh Sách Thiết Bị

```bash
flutter devices
```

## 7. Các Lệnh Thường Dùng

```bash
flutter pub get
flutter analyze
flutter test
flutter clean
```

Nếu cần thiết lập lại phụ thuộc:

```bash
flutter clean
flutter pub get
```

## 8. Xử Lý Sự Cố Nhanh

- **Lỗi CORS khi đăng nhập web**: kiểm tra CORS_ORIGINS hoặc CORS_ORIGINS_REGEX ở backend.
- **Lỗi audience Firebase ID token**: kiểm tra FIREBASE_PROJECT_ID ở giao diện người dùng và tài khoản dịch vụ ở backend phải cùng dự án.
- **Lỗi kết nối backend trên trình giả lập Android**: đảm bảo API_BASE_URL_ANDROID dùng 10.0.2.2.
- **Lỗi JSObject/JSAny khi xây dựng Android**: tránh nhập trực tiếp thư viện chỉ dành cho web (ví dụ: package:dio/browser.dart) trong mã dùng chung; dùng nhập có điều kiện theo nền tảng.
