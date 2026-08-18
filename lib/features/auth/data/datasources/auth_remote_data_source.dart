import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String username,
    required String password,
    int expiresInMins = 30,
  });

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  });

  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login({
    required String username,
    required String password,
    int expiresInMins = 30,
  }) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
          'expiresInMins': expiresInMins,
        },
      );

      if (response.data != null) {
        return UserModel.fromJson(response.data!);
      } else {
        throw const ServerException(message: 'Empty response from server');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is AuthException) {
        rethrow;
      }
      throw ServerException(message: 'Authentication failed: $e');
    }
  }

  @override
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        '/users/add',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.data != null) {
        return UserModel.fromJson(response.data!);
      } else {
        throw const ServerException(message: 'Empty registration response');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is AuthException) {
        rethrow;
      }
      throw ServerException(message: 'Registration failed: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get<Map<String, dynamic>>('/auth/me');

      if (response.data != null) {
        return UserModel.fromJson(response.data!);
      } else {
        throw const ServerException(message: 'Empty user profile response');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is AuthException) {
        rethrow;
      }
      throw ServerException(message: 'Failed to fetch user profile: $e');
    }
  }
}
