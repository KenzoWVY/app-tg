import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Dio refreshDio;

  AuthInterceptor(this.storage, this.refreshDio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.read(key: 'refresh_token');

      if (refreshToken != null) {
        try {
          final response = await refreshDio.post('/auth/refresh', data: {'refresh_token': refreshToken});

          final newAccessToken = response.data['token'];
          await storage.write(key: 'access_token', value: newAccessToken);

          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await refreshDio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        } catch (e) {
          await storage.deleteAll();
        }
      }
    }
    return handler.next(err);
  }
}