import 'package:dio/dio.dart';
import 'package:edumate/core/exceptions/api_exception.dart';
import 'package:edumate/data/models/api_envelope.dart';
import 'package:edumate/data/services/api_service.dart';

abstract class BaseRepository {
  final ApiService apiService;

  const BaseRepository(this.apiService);

  T parseEnvelopeData<T>(
    Response<dynamic> response,
    T Function(Object? raw) fromData,
  ) {
    final payload = response.data;
    if (payload is! Map<String, dynamic>) {
      throw ApiException(
        message: 'Invalid API response payload.',
        statusCode: response.statusCode,
      );
    }

    final envelope = ApiEnvelope<T>.fromJson(payload, fromData);
    if (envelope.success && envelope.data != null) {
      return envelope.data as T;
    }

    final apiError = envelope.error;
    throw ApiException(
      message: apiError?.message ?? 'Request failed.',
      statusCode: apiError?.status ?? response.statusCode,
      code: apiError?.code,
      details: apiError?.details,
    );
  }
}
