import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../errors/exceptions.dart';

abstract class SecureStorageService {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();

  // Convenience methods for tokens
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> deleteRefreshToken();

  // User session
  Future<void> saveUserData(Map<String, dynamic> userJson);
  Future<Map<String, dynamic>?> getUserData();
  Future<void> deleteUserData();

  // Offline cache
  Future<void> savePostsCache(Map<String, dynamic> postsJson);
  Future<Map<String, dynamic>?> getPostsCache();
  Future<void> deletePostsCache();

  Future<void> clearSession();
}

class SecureStorageServiceImpl implements SecureStorageService {
  static const String _keyToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUser = 'cached_user';
  static const String _keyPostsCache = 'cached_posts';

  final FlutterSecureStorage _storage;

  SecureStorageServiceImpl({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  @override
  Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw CacheException(message: 'Failed to write to secure storage: $e');
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw CacheException(message: 'Failed to read from secure storage: $e');
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw CacheException(message: 'Failed to delete from secure storage: $e');
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw CacheException(message: 'Failed to clear secure storage: $e');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await write(key: _keyToken, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await read(key: _keyToken);
  }

  @override
  Future<void> deleteToken() async {
    await delete(key: _keyToken);
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await write(key: _keyRefreshToken, value: refreshToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await read(key: _keyRefreshToken);
  }

  @override
  Future<void> deleteRefreshToken() async {
    await delete(key: _keyRefreshToken);
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> userJson) async {
    await write(key: _keyUser, value: jsonEncode(userJson));
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    final raw = await read(key: _keyUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteUserData() async {
    await delete(key: _keyUser);
  }

  @override
  Future<void> savePostsCache(Map<String, dynamic> postsJson) async {
    await write(key: _keyPostsCache, value: jsonEncode(postsJson));
  }

  @override
  Future<Map<String, dynamic>?> getPostsCache() async {
    final raw = await read(key: _keyPostsCache);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deletePostsCache() async {
    await delete(key: _keyPostsCache);
  }

  @override
  Future<void> clearSession() async {
    await deleteToken();
    await deleteRefreshToken();
    await deleteUserData();
  }
}
