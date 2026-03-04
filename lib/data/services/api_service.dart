import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 60), // AI response cần lâu hơn
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // TODO: Gắn API key hoặc token ở đây nếu cần
          // options.queryParameters['key'] = AppConstants.geminiApiKey;
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioException error, handler) {
          _handleError(error);
          handler.next(error);
        },
      ),
    );
  }

  Dio get client => _dio;

  /// GET request
  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.get(
      url,
      queryParameters: params,
      options: headers != null ? Options(headers: headers) : null,
    );
  }

  /// POST request (JSON)
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.post(
      url,
      data: data,
      options: headers != null ? Options(headers: headers) : null,
    );
  }

  /// POST request với file (upload ảnh, PDF)
  Future<Response> uploadFile(
    String url,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? extraFields,
    Map<String, dynamic>? headers,
  }) async {
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      ...?extraFields,
    });
    return _dio.post(
      url,
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data', ...?headers},
      ),
    );
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        // TODO: Hiển thị thông báo timeout cho người dùng
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          // TODO: Xử lý hết hạn token / sai API key
        } else if (statusCode == 429) {
          // TODO: Xử lý rate limit (Gemini API)
        }
        break;
      case DioExceptionType.connectionError:
        // TODO: Hiển thị thông báo mất kết nối mạng
        break;
      default:
        break;
    }
  }
}
