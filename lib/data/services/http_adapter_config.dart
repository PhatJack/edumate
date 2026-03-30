import 'package:dio/dio.dart';

import 'http_adapter_config_stub.dart'
    if (dart.library.js_interop) 'http_adapter_config_web.dart';

void configureHttpAdapter(Dio dio) => configureHttpAdapterImpl(dio);
