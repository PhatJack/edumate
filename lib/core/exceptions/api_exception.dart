class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  final Object? details;

  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
    this.details,
  });

  @override
  String toString() {
    final status = statusCode != null ? ' (status: $statusCode)' : '';
    final errCode = code != null ? ' [$code]' : '';
    return 'ApiException$status$errCode: $message';
  }
}
