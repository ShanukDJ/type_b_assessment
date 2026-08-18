import 'dart:io';
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../errors/exceptions.dart';
import '../storage/secure_storage_service.dart';

class ApiClient {
  final Dio _dio;
  final SecureStorageService storageService;
  final String _baseUrl;
  bool _isRefreshing = false;

  ApiClient({
    required AppConfig appConfig,
    required this.storageService,
    Dio? dio,
  }) : _baseUrl = appConfig.apiBaseUrl,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: appConfig.apiBaseUrl,
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 15),
               headers: {
                 'Content-Type': 'application/json',
                 'Accept': 'application/json',
               },
             ),
           ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.headers.containsKey('Authorization')) {
            try {
              final token = await storageService.getToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            } catch (_) {}
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Transparent Token Refresh Interceptor
          if (error.response?.statusCode == 401 && !_isRefreshing) {
            final isRefreshRequest =
                error.requestOptions.path.contains('/auth/refresh') ||
                error.requestOptions.path.contains('/auth/login');

            if (!isRefreshRequest) {
              final refreshToken = await storageService.getRefreshToken();
              if (refreshToken != null && refreshToken.isNotEmpty) {
                _isRefreshing = true;
                try {
                  final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
                  final refreshResponse = await refreshDio.post(
                    '/auth/refresh',
                    data: {'refreshToken': refreshToken, 'expiresInMins': 30},
                  );

                  if (refreshResponse.statusCode == 200 &&
                      refreshResponse.data != null) {
                    final data = refreshResponse.data;
                    final newToken = data['accessToken'] ?? data['token'];
                    final newRefreshToken = data['refreshToken'];

                    if (newToken != null) {
                      await storageService.saveToken(newToken.toString());
                    }
                    if (newRefreshToken != null) {
                      await storageService.saveRefreshToken(
                        newRefreshToken.toString(),
                      );
                    }

                    // Retry original request with new token
                    final retryOptions = error.requestOptions;
                    retryOptions.headers['Authorization'] = 'Bearer $newToken';
                    final response = await _dio.fetch(retryOptions);
                    _isRefreshing = false;
                    return handler.resolve(response);
                  }
                } catch (_) {
                  await storageService.clearSession();
                } finally {
                  _isRefreshing = false;
                }
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is AuthException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is AuthException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException(
          message:
              'Connection timed out. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final dynamic data = e.response?.data;
        String errorMessage = 'Server error occurred.';

        if (data is Map<String, dynamic> && data.containsKey('message')) {
          errorMessage = data['message'].toString();
        } else if (e.message != null && e.message!.isNotEmpty) {
          errorMessage = e.message!;
        }

        if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
          return AuthException(
            message: errorMessage.isNotEmpty
                ? errorMessage
                : 'Invalid credentials or unauthorized.',
            statusCode: statusCode,
          );
        }

        return ServerException(message: errorMessage, statusCode: statusCode);
      case DioExceptionType.cancel:
        return const ServerException(message: 'Request was cancelled.');
      case DioExceptionType.badCertificate:
        return const NetworkException(message: 'Invalid SSL certificate.');
      case DioExceptionType.unknown:
      default:
        if (e.error is SocketException) {
          return const NetworkException(
            message: 'No internet connection. Please verify your connection.',
          );
        }
        return ServerException(
          message: e.message ?? 'An unknown network error occurred.',
        );
    }
  }
}
