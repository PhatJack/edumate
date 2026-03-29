import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _apiBaseUrlDefine = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String _apiBaseUrlWebDefine = String.fromEnvironment(
    'API_BASE_URL_WEB',
    defaultValue: '',
  );

  static const String _apiBaseUrlAndroidDefine = String.fromEnvironment(
    'API_BASE_URL_ANDROID',
    defaultValue: '',
  );

  static const String _googleWebClientIdDefine = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '',
  );

  static String get apiBaseUrl {
    if (kIsWeb) {
      if (_apiBaseUrlWebDefine.isNotEmpty) {
        return _apiBaseUrlWebDefine;
      }
      if (_apiBaseUrlDefine.isNotEmpty) {
        return _apiBaseUrlDefine;
      }
      return 'http://127.0.0.1:8000';
    }

    if (_apiBaseUrlAndroidDefine.isNotEmpty) {
      return _apiBaseUrlAndroidDefine;
    }

    if (_apiBaseUrlDefine.isNotEmpty) {
      return _apiBaseUrlDefine;
    }

    return 'http://10.0.2.2:8000';
  }

  static String? get googleWebClientId {
    if (_googleWebClientIdDefine.isEmpty) {
      return null;
    }
    return _googleWebClientIdDefine;
  }
}
