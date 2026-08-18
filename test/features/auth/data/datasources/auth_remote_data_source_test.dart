import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/errors/exceptions.dart';
import 'package:type_b/core/network/api_client.dart';
import 'package:type_b/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:type_b/features/auth/data/models/user_model.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late AuthRemoteDataSourceImpl dataSource;

  const tUserJson = {
    'id': 1,
    'username': 'emilys',
    'email': 'emily@example.com',
    'firstName': 'Emily',
    'lastName': 'Johnson',
    'accessToken': 'jwt-token-123',
  };

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = AuthRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  group('AuthRemoteDataSourceImpl', () {
    test('login_withValidCredentials_returnsUserModel', () async {
      when(
        () => mockApiClient.post<Map<String, dynamic>>(
          '/auth/login',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          data: tUserJson,
          statusCode: 200,
        ),
      );

      final result = await dataSource.login(
        username: 'emilys',
        password: 'emilyspass',
      );

      expect(result, isA<UserModel>());
      expect(result.username, equals('emilys'));
      expect(result.accessToken, equals('jwt-token-123'));
    });

    test('login_whenEmptyResponse_throwsServerException', () async {
      when(
        () => mockApiClient.post<Map<String, dynamic>>(
          '/auth/login',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          data: null,
          statusCode: 200,
        ),
      );

      expect(
        () => dataSource.login(username: 'emilys', password: 'emilyspass'),
        throwsA(isA<ServerException>()),
      );
    });

    test('register_withValidData_returnsUserModel', () async {
      when(
        () => mockApiClient.post<Map<String, dynamic>>(
          '/users/add',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/add'),
          data: tUserJson,
          statusCode: 200,
        ),
      );

      final result = await dataSource.register(
        firstName: 'Emily',
        lastName: 'Johnson',
        username: 'emilys',
        email: 'emily@example.com',
        password: 'password123',
      );

      expect(result, isA<UserModel>());
      expect(result.username, equals('emilys'));
    });

    test('getCurrentUser_returnsUserModel', () async {
      when(
        () => mockApiClient.get<Map<String, dynamic>>('/auth/me'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/me'),
          data: tUserJson,
          statusCode: 200,
        ),
      );

      final result = await dataSource.getCurrentUser();

      expect(result, isA<UserModel>());
      expect(result.username, equals('emilys'));
    });

    test('getCurrentUser_onAuthException_rethrowsAuthException', () async {
      when(() => mockApiClient.get<Map<String, dynamic>>('/auth/me')).thenThrow(
        const AuthException(message: 'Invalid token', statusCode: 401),
      );

      expect(() => dataSource.getCurrentUser(), throwsA(isA<AuthException>()));
    });
  });
}
