import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const Map<String, String> _defineValues = {
    'API_BASE_URL': String.fromEnvironment('API_BASE_URL'),
    'API_BASE_URL_WEB': String.fromEnvironment('API_BASE_URL_WEB'),
    'API_BASE_URL_ANDROID': String.fromEnvironment('API_BASE_URL_ANDROID'),
    'GOOGLE_WEB_CLIENT_ID': String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
    'FIREBASE_API_KEY': String.fromEnvironment('FIREBASE_API_KEY'),
    'FIREBASE_AUTH_DOMAIN': String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
    'FIREBASE_PROJECT_ID': String.fromEnvironment('FIREBASE_PROJECT_ID'),
    'FIREBASE_STORAGE_BUCKET': String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
    'VITE_FIREBASE_STORAGE_BUCKET':
        String.fromEnvironment('VITE_FIREBASE_STORAGE_BUCKET'),
    'FIREBASE_MESSAGING_SENDER_ID':
        String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    'FIREBASE_APP_ID': String.fromEnvironment('FIREBASE_APP_ID'),
  };

  static String _fromEnv(String key) {
    final value = dotenv.env[key]?.trim() ?? '';
    return value;
  }

  static String _fromDefine(String key) {
    return (_defineValues[key] ?? '').trim();
  }

  static String _pickConfig(List<String> keys) {
    for (final key in keys) {
      final envValue = _fromEnv(key);
      if (envValue.isNotEmpty) {
        return envValue;
      }

      final defineValue = _fromDefine(key);
      if (defineValue.isNotEmpty) {
        return defineValue;
      }
    }
    return '';
  }

  static String get apiBaseUrl {
    final envApiBaseUrl = _pickConfig(['API_BASE_URL']);
    final envApiBaseUrlWeb = _pickConfig(['API_BASE_URL_WEB']);
    final envApiBaseUrlAndroid = _pickConfig(['API_BASE_URL_ANDROID']);

    if (kIsWeb) {
      if (envApiBaseUrlWeb.isNotEmpty) {
        return envApiBaseUrlWeb;
      }
      if (envApiBaseUrl.isNotEmpty) {
        return envApiBaseUrl;
      }
      return 'http://127.0.0.1:8000';
    }

    if (envApiBaseUrlAndroid.isNotEmpty) {
      return envApiBaseUrlAndroid;
    }

    if (envApiBaseUrl.isNotEmpty) {
      return envApiBaseUrl;
    }

    return 'http://10.0.2.2:8000';
  }

  static String? get googleWebClientId {
    final envClientId = _pickConfig(['GOOGLE_WEB_CLIENT_ID']);
    if (envClientId.isNotEmpty) {
      return envClientId;
    }
    return null;
  }

  static String? get firebaseProjectId {
    final projectId = _pickConfig(['FIREBASE_PROJECT_ID']);
    if (projectId.isNotEmpty) {
      return projectId;
    }
    return null;
  }

  static FirebaseOptions? get firebaseWebOptions {
    final apiKey = _pickConfig(['FIREBASE_API_KEY']);
    final authDomain = _pickConfig(['FIREBASE_AUTH_DOMAIN']);
    final projectId = firebaseProjectId ?? '';
    final storageBucket = _pickConfig([
      'FIREBASE_STORAGE_BUCKET',
      'VITE_FIREBASE_STORAGE_BUCKET',
    ]);
    final messagingSenderId = _pickConfig([
      'FIREBASE_MESSAGING_SENDER_ID',
    ]);
    final appId = _pickConfig(['FIREBASE_APP_ID']);

    if (apiKey.isEmpty ||
        authDomain.isEmpty ||
        projectId.isEmpty ||
        storageBucket.isEmpty ||
        messagingSenderId.isEmpty ||
        appId.isEmpty) {
      return null;
    }

    return FirebaseOptions(
      apiKey: apiKey,
      authDomain: authDomain,
      projectId: projectId,
      storageBucket: storageBucket,
      messagingSenderId: messagingSenderId,
      appId: appId,
    );
  }

  static bool get hasFirebaseWebConfig => firebaseWebOptions != null;
}
