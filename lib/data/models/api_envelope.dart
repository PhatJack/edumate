class ApiError {
  final String? type;
  final String? title;
  final int? status;
  final String? detail;
  final String? code;
  final Object? details;

  const ApiError({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.code,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      type: json['type'] as String?,
      title: json['title'] as String?,
      status: json['status'] as int?,
      detail: json['detail'] as String?,
      code: json['code'] as String?,
      details: json['details'],
    );
  }

  String get message => detail ?? title ?? 'Request failed.';
}

class ApiEnvelope<T> {
  final bool success;
  final T? data;
  final ApiError? error;

  const ApiEnvelope({
    required this.success,
    this.data,
    this.error,
  });

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Object? raw) fromData,
  ) {
    final success = json['success'] == true;
    final rawError = json['error'];

    ApiError? parsedError;
    if (rawError is Map<String, dynamic>) {
      parsedError = ApiError.fromJson(rawError);
    } else if (rawError is String) {
      parsedError = ApiError(detail: rawError);
    }

    return ApiEnvelope<T>(
      success: success,
      data: success ? fromData(json['data']) : null,
      error: parsedError,
    );
  }
}
