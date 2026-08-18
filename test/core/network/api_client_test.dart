import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/config/app_config.dart';
import 'package:type_b/core/errors/exceptions.dart';
import 'package:type_b/core/network/api_client.dart';
import 'package:type_b/core/storage/secure_storage_service.dart';

class MockDio extends Mock implements Dio {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockDio mockDio;
  late MockSecureStorageService mockStorageService;
  late ApiClient apiClient;

  setUp(() {
    mockDio = MockDio();
    mockStorageService = MockSecureStorageService();
    when(() => mockDio.interceptors).thenReturn(Interceptors());

    apiClient = ApiClient(
      appConfig: AppConfig.dev(),
      storageService: mockStorageService,
      dio: mockDio,
    );
  });

  group('ApiClient', () {
    test('get_onSuccess_returnsResponse', () async {
      final responseData = {'id': 1, 'title': 'Test Post'};
      final response = Response(
        requestOptions: RequestOptions(path: '/posts/1'),
        data: responseData,
        statusCode: 200,
      );

      when(
        () => mockDio.get<Map<String, dynamic>>(
          '/posts/1',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiClient.get<Map<String, dynamic>>('/posts/1');

      expect(result.data, equals(responseData));
      expect(result.statusCode, equals(200));
    });

    test('post_onSuccess_returnsResponse', () async {
      final responseData = {'token': 'jwt-abc'};
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/login'),
        data: responseData,
        statusCode: 200,
      );

      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/auth/login',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'username': 'emilys'},
      );

      expect(result.data, equals(responseData));
    });

    test('get_on400AuthError_throwsAuthException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/me'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/me'),
          statusCode: 401,
          data: {'message': 'Invalid token'},
        ),
        type: DioExceptionType.badResponse,
      );

      when(
        () => mockDio.get<Map<String, dynamic>>(
          '/auth/me',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenThrow(dioException);

      expect(
        () => apiClient.get<Map<String, dynamic>>('/auth/me'),
        throwsA(isA<AuthException>()),
      );
    });

    test('get_onConnectionTimeout_throwsNetworkException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/posts'),
        type: DioExceptionType.connectionTimeout,
      );

      when(
        () => mockDio.get<Map<String, dynamic>>(
          '/posts',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenThrow(dioException);

      expect(
        () => apiClient.get<Map<String, dynamic>>('/posts'),
        throwsA(isA<NetworkException>()),
      );
    });

    test('get_on500ServerError_throwsServerException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/posts'),
        response: Response(
          requestOptions: RequestOptions(path: '/posts'),
          statusCode: 500,
          data: {'message': 'Internal error'},
        ),
        type: DioExceptionType.badResponse,
      );

      when(
        () => mockDio.get<Map<String, dynamic>>(
          '/posts',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenThrow(dioException);

      expect(
        () => apiClient.get<Map<String, dynamic>>('/posts'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
