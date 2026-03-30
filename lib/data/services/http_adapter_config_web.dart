import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

void configureHttpAdapterImpl(Dio dio) {
  (dio.httpClientAdapter as BrowserHttpClientAdapter).withCredentials = true;
}
