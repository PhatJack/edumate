import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String _fromEnv(String key) {
    final value = dotenv.env[key]?.trim() ?? '';
    return value;
  }

  static String _pickEnv(List<String> keys) {
    for (final key in keys) {
      final value = _fromEnv(key);
      if (value.isNotEmpty) {
        return value;
      }
    }
    return '';
  }

  static String get apiBaseUrl {
    final envApiBaseUrl = _pickEnv(['API_BASE_URL']);
    final envApiBaseUrlWeb = _pickEnv(['API_BASE_URL_WEB']);
    final envApiBaseUrlAndroid = _pickEnv(['API_BASE_URL_ANDROID']);

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
    final envClientId = _fromEnv('GOOGLE_WEB_CLIENT_ID');
    if (envClientId.isNotEmpty) {
      return envClientId;
    }
    return null;
  }

  static String? get firebaseProjectId {
    final projectId = _pickEnv(['FIREBASE_PROJECT_ID']);
    if (projectId.isNotEmpty) {
      return projectId;
    }
    return null;
  }

  static FirebaseOptions? get firebaseWebOptions {
    final apiKey = _pickEnv(['FIREBASE_API_KEY']);
    final authDomain = _pickEnv(['FIREBASE_AUTH_DOMAIN']);
    final projectId = firebaseProjectId ?? '';
    final storageBucket =
        _pickEnv(['FIREBASE_STORAGE_BUCKET', 'VITE_FIREBASE_STORAGE_BUCKET']);
    final messagingSenderId = _pickEnv([
      'FIREBASE_MESSAGING_SENDER_ID',
    ]);
    final appId = _pickEnv(['FIREBASE_APP_ID']);

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
