import 'package:edumate/core/config/app_config.dart';
import 'package:dio/dio.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  String? _bearerToken;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_bearerToken != null && _bearerToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_bearerToken';
          }
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

  String get baseUrl => _dio.options.baseUrl;

  void setBearerToken(String token) {
    _bearerToken = token;
  }

  void clearBearerToken() {
    _bearerToken = null;
  }

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

  /// POST request with FormData (file upload)
  Future<Response> postFormData(
    String url,
    FormData formData, {
    Map<String, dynamic>? headers,
  }) async {
    return _dio.post(
      url,
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data', ...?headers},
      ),
    );
  }

  /// PATCH request (JSON)
  Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.patch(
      url,
      data: data,
      options: headers != null ? Options(headers: headers) : null,
    );
  }

  /// DELETE request
  Future<Response> delete(
    String url, {
    Map<String, dynamic>? headers,
  }) async {
    return _dio.delete(
      url,
      options: headers != null ? Options(headers: headers) : null,
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
