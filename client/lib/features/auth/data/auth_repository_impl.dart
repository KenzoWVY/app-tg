import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/dio_provider.dart';
import '../../../core/secure_storage_provider.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._dio, this._storage);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final accessToken = response.data['token']?.toString();
      final refreshToken = response.data['refreshToken']?.toString();
      final userData = response.data['user'];

      await _storage.write(key: 'access_token', value: accessToken);
      await _storage.write(key: 'refresh_token', value: refreshToken);

      return User.fromJson(userData);
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.response?.data}');
    }
  }

  @override
  Future<User> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'email': email, 'password': password},
      );

      final userData = response.data['newUser'];
      if (userData == null) {
        throw Exception('Registration failed: No user data returned');
      }

      return User.fromJson(userData);
    } on DioException catch (e) {
      throw Exception('Registration failed: ${e.response?.data}');
    }
  }

  @override
  Future<void> recoverPassword(String email) async {
    try {
      await _dio.post('/auth/recover-password', data: {'email': email});
    } on DioException catch (e) {
      throw Exception('Recovery failed: ${e.response?.data}');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  @override
  Future<User?> getCurrentUser() async {
    final accessToken = await _storage.read(key: 'access_token');
    if (accessToken == null) return null;

    try {
      final response = await _dio.get('/auth/me');
      return User.fromJson(response.data['user']);
    } catch (e) {
      return null;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(dio, storage);
});
