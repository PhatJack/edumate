# Hướng dẫn Routing và Chạy Ứng dụng Flutter

## Các câu lệnh để chạy ứng dụng Flutter

```sh
# Chạy ứng dụng trên thiết bị mặc định
flutter run

# Chạy ứng dụng trên thiết bị cụ thể (ví dụ: emulator-5554)
flutter run -d emulator-5554

# Chạy ứng dụng trên web
flutter run -d chrome

# Build release cho Android
flutter build apk

# Build release cho iOS (chỉ trên macOS)
flutter build ios
```

## Hướng dẫn Routing trong Flutter

- Định nghĩa routes trong `MaterialApp`:
  - Sử dụng `routes` map (đơn giản)
  - Sử dụng `onGenerateRoute` (linh hoạt, cho route động)

- Các lệnh điều hướng phổ biến:

```dart
// Đẩy màn hình mới lên stack
Navigator.push(context, MaterialPageRoute(builder: (context) => NewScreen()));

// Đẩy màn hình mới bằng tên route
Navigator.pushNamed(context, '/profile');

// Quay lại màn hình trước
Navigator.pop(context);

// Thay thế màn hình hiện tại
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewScreen()));

// Thay thế bằng named route
Navigator.pushReplacementNamed(context, '/home');

// Xóa tất cả màn hình cho đến một điều kiện
Navigator.pushAndRemoveUntil(context, 
  MaterialPageRoute(builder: (context) => HomeScreen()),
  (route) => false
);

// Đẩy màn hình mới với arguments
Navigator.pushNamed(context, '/details', arguments: {'id': 123});
```

> Xem thêm ví dụ chi tiết trong thư mục `lib/core/screens/`.
