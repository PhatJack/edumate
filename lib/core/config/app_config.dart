import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static const String _firebaseApiKeyDefine = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );

  static const String _firebaseApiKeyViteDefine = String.fromEnvironment(
    'VITE_FIREBASE_API_KEY',
    defaultValue: '',
  );

  static const String _firebaseAuthDomainDefine = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
    defaultValue: '',
  );

  static const String _firebaseAuthDomainViteDefine = String.fromEnvironment(
    'VITE_FIREBASE_AUTH_DOMAIN',
    defaultValue: '',
  );

  static const String _firebaseProjectIdDefine = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );

  static const String _firebaseProjectIdViteDefine = String.fromEnvironment(
    'VITE_FIREBASE_PROJECT_ID',
    defaultValue: '',
  );

  static const String _firebaseStorageBucketDefine = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: '',
  );

  static const String _firebaseStorageBucketViteDefine = String.fromEnvironment(
    'VITE_FIREBASE_STORAGE_BUCKET',
    defaultValue: '',
  );

  static const String _firebaseMessagingSenderIdDefine = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '',
  );

  static const String _firebaseMessagingSenderIdViteDefine = String.fromEnvironment(
    'VITE_FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '',
  );

  static const String _firebaseAppIdDefine = String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: '',
  );

  static const String _firebaseAppIdViteDefine = String.fromEnvironment(
    'VITE_FIREBASE_APP_ID',
    defaultValue: '',
  );

  static String _fromEnv(String key) {
    final value = dotenv.env[key]?.trim() ?? '';
    return value;
  }

  static String _pick2(String envValue, String defineValue) {
    if (envValue.isNotEmpty) {
      return envValue;
    }
    return defineValue;
  }

  static String _pick3(String envValue, String defineValue, String fallbackDefine) {
    if (envValue.isNotEmpty) {
      return envValue;
    }
    if (defineValue.isNotEmpty) {
      return defineValue;
    }
    return fallbackDefine;
  }

  static String get apiBaseUrl {
    final envApiBaseUrl = _fromEnv('API_BASE_URL');
    final envApiBaseUrlWeb = _fromEnv('API_BASE_URL_WEB');
    final envApiBaseUrlAndroid = _fromEnv('API_BASE_URL_ANDROID');
    final envViteApiBaseUrl = _fromEnv('VITE_API_BASE_URL');

    if (kIsWeb) {
      if (envApiBaseUrlWeb.isNotEmpty) {
        return envApiBaseUrlWeb;
      }
      if (envApiBaseUrl.isNotEmpty) {
        return envApiBaseUrl;
      }
      if (envViteApiBaseUrl.isNotEmpty) {
        return envViteApiBaseUrl;
      }
      if (_apiBaseUrlWebDefine.isNotEmpty) {
        return _apiBaseUrlWebDefine;
      }
      if (_apiBaseUrlDefine.isNotEmpty) {
        return _apiBaseUrlDefine;
      }
      return 'http://127.0.0.1:8000';
    }

    if (envApiBaseUrlAndroid.isNotEmpty) {
      return envApiBaseUrlAndroid;
    }

    if (envApiBaseUrl.isNotEmpty) {
      return envApiBaseUrl;
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
    final envClientId = _fromEnv('GOOGLE_WEB_CLIENT_ID');
    if (envClientId.isNotEmpty) {
      return envClientId;
    }

    if (_googleWebClientIdDefine.isEmpty) {
      return null;
    }
    return _googleWebClientIdDefine;
  }

  static FirebaseOptions? get firebaseWebOptions {
    final apiKey = _pick3(
      _pick2(_fromEnv('FIREBASE_API_KEY'), _fromEnv('VITE_FIREBASE_API_KEY')),
      _firebaseApiKeyDefine,
      _firebaseApiKeyViteDefine,
    );
    final authDomain = _pick3(
      _pick2(_fromEnv('FIREBASE_AUTH_DOMAIN'), _fromEnv('VITE_FIREBASE_AUTH_DOMAIN')),
      _firebaseAuthDomainDefine,
      _firebaseAuthDomainViteDefine,
    );
    final projectId = _pick3(
      _pick2(_fromEnv('FIREBASE_PROJECT_ID'), _fromEnv('VITE_FIREBASE_PROJECT_ID')),
      _firebaseProjectIdDefine,
      _firebaseProjectIdViteDefine,
    );
    final storageBucket = _pick3(
      _pick2(_fromEnv('FIREBASE_STORAGE_BUCKET'), _fromEnv('VITE_FIREBASE_STORAGE_BUCKET')),
      _firebaseStorageBucketDefine,
      _firebaseStorageBucketViteDefine,
    );
    final messagingSenderId = _pick3(
      _pick2(
        _fromEnv('FIREBASE_MESSAGING_SENDER_ID'),
        _fromEnv('VITE_FIREBASE_MESSAGING_SENDER_ID'),
      ),
      _firebaseMessagingSenderIdDefine,
      _firebaseMessagingSenderIdViteDefine,
    );
    final appId = _pick3(
      _pick2(_fromEnv('FIREBASE_APP_ID'), _fromEnv('VITE_FIREBASE_APP_ID')),
      _firebaseAppIdDefine,
      _firebaseAppIdViteDefine,
    );

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
