import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService storageService;

  AuthLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> saveToken(String token) async {
    try {
      await storageService.saveToken(token);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save token to secure storage: $e',
      );
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await storageService.getToken();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get token from secure storage: $e',
      );
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await storageService.deleteToken();
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete token from secure storage: $e',
      );
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await storageService.saveUserData(user.toJson());
    } catch (e) {
      throw CacheException(
        message: 'Failed to save user data to secure storage: $e',
      );
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final data = await storageService.getUserData();
      if (data == null) return null;
      return UserModel.fromJson(data);
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve user data from secure storage: $e',
      );
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await storageService.deleteUserData();
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete user data from secure storage: $e',
      );
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await storageService.clearSession();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear session from secure storage: $e',
      );
    }
  }
}
