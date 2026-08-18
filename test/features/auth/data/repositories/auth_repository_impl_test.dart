import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/errors/exceptions.dart';
import 'package:type_b/core/errors/failures.dart';
import 'package:type_b/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:type_b/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:type_b/features/auth/data/models/user_model.dart';
import 'package:type_b/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late AuthRepositoryImpl repository;

  const tUserModel = UserModel(
    id: 1,
    username: 'emilys',
    email: 'emily@example.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    accessToken: 'jwt-123',
  );

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('AuthRepositoryImpl', () {
    test('login_withValidCredentials_returnsUserAndStoresToken', () async {
      when(
        () => mockRemoteDataSource.login(
          username: 'emilys',
          password: 'emilyspass',
          expiresInMins: 30,
        ),
      ).thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.saveToken(any())).thenAnswer((_) async {});
      when(() => mockLocalDataSource.saveUser(any())).thenAnswer((_) async {});

      final result = await repository.login(
        username: 'emilys',
        password: 'emilyspass',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(tUserModel));
      verify(() => mockLocalDataSource.saveToken('jwt-123')).called(1);
      verify(() => mockLocalDataSource.saveUser(tUserModel)).called(1);
    });

    test('login_withEmptyCredentials_returnsValidationFailure', () async {
      final result = await repository.login(username: '', password: '');

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('login_onAuthException_returnsAuthFailure', () async {
      when(
        () => mockRemoteDataSource.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
          expiresInMins: any(named: 'expiresInMins'),
        ),
      ).thenThrow(
        const AuthException(message: 'Invalid credentials', statusCode: 400),
      );

      final result = await repository.login(
        username: 'emilys',
        password: 'wrongpassword',
      );

      expect(result.isFailure, isTrue);
      expect(
        result.failureOrNull,
        equals(const AuthFailure('Invalid credentials', statusCode: 400)),
      );
    });

    test('login_onNetworkException_returnsNetworkFailure', () async {
      when(
        () => mockRemoteDataSource.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
          expiresInMins: any(named: 'expiresInMins'),
        ),
      ).thenThrow(const NetworkException(message: 'No internet connection'));

      final result = await repository.login(
        username: 'emilys',
        password: 'emilyspass',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });

    test('login_onServerException_returnsServerFailure', () async {
      when(
        () => mockRemoteDataSource.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
          expiresInMins: any(named: 'expiresInMins'),
        ),
      ).thenThrow(
        const ServerException(message: 'Server error 500', statusCode: 500),
      );

      final result = await repository.login(
        username: 'emilys',
        password: 'emilyspass',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });

    test('login_onCacheException_returnsCacheFailure', () async {
      when(
        () => mockRemoteDataSource.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
          expiresInMins: any(named: 'expiresInMins'),
        ),
      ).thenAnswer((_) async => tUserModel);
      when(
        () => mockLocalDataSource.saveToken(any()),
      ).thenThrow(const CacheException(message: 'Storage failure'));

      final result = await repository.login(
        username: 'emilys',
        password: 'emilyspass',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<CacheFailure>());
    });

    test('register_withValidData_returnsUser', () async {
      when(
        () => mockRemoteDataSource.register(
          firstName: 'Emily',
          lastName: 'Johnson',
          username: 'emilys',
          email: 'emily@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.register(
        firstName: 'Emily',
        lastName: 'Johnson',
        username: 'emilys',
        email: 'emily@example.com',
        password: 'password123',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(tUserModel));
    });

    test('register_withEmptyFields_returnsValidationFailure', () async {
      final result = await repository.register(
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        password: '',
      );

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
    });

    test('getCurrentUser_whenNoToken_returnsAuthFailure', () async {
      when(() => mockLocalDataSource.getToken()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });

    test('getCurrentUser_whenRemoteSucceeds_cachesAndReturnsUser', () async {
      when(
        () => mockLocalDataSource.getToken(),
      ).thenAnswer((_) async => 'jwt-123');
      when(
        () => mockRemoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.saveUser(any())).thenAnswer((_) async {});

      final result = await repository.getCurrentUser();

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(tUserModel));
      verify(() => mockLocalDataSource.saveUser(tUserModel)).called(1);
    });

    test(
      'getCurrentUser_whenRemoteFailsWithNetwork_fallbacksToCachedUser',
      () async {
        when(
          () => mockLocalDataSource.getToken(),
        ).thenAnswer((_) async => 'jwt-123');
        when(
          () => mockRemoteDataSource.getCurrentUser(),
        ).thenThrow(const NetworkException(message: 'Network down'));
        when(
          () => mockLocalDataSource.getUser(),
        ).thenAnswer((_) async => tUserModel);

        final result = await repository.getCurrentUser();

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, equals(tUserModel));
      },
    );

    test(
      'getCurrentUser_whenRemoteFailsWithAuth_clearsSessionAndReturnsAuthFailure',
      () async {
        when(
          () => mockLocalDataSource.getToken(),
        ).thenAnswer((_) async => 'jwt-123');
        when(() => mockRemoteDataSource.getCurrentUser()).thenThrow(
          const AuthException(message: 'Token expired', statusCode: 401),
        );
        when(() => mockLocalDataSource.getUser()).thenAnswer((_) async => null);
        when(() => mockLocalDataSource.clearSession()).thenAnswer((_) async {});

        final result = await repository.getCurrentUser();

        expect(result.isFailure, isTrue);
        expect(result.failureOrNull, isA<AuthFailure>());
        verify(() => mockLocalDataSource.clearSession()).called(1);
      },
    );

    test('getCurrentUser_whenCacheException_returnsCacheFailure', () async {
      when(
        () => mockLocalDataSource.getToken(),
      ).thenThrow(const CacheException(message: 'Storage corrupt'));

      final result = await repository.getCurrentUser();

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<CacheFailure>());
    });

    test('checkAuthStatus_whenTokenExists_returnsTrue', () async {
      when(
        () => mockLocalDataSource.getToken(),
      ).thenAnswer((_) async => 'jwt-123');

      final result = await repository.checkAuthStatus();

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isTrue);
    });

    test('checkAuthStatus_whenNoToken_returnsFalse', () async {
      when(() => mockLocalDataSource.getToken()).thenAnswer((_) async => null);

      final result = await repository.checkAuthStatus();

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isFalse);
    });

    test('logout_clearsSessionAndReturnsSuccess', () async {
      when(() => mockLocalDataSource.clearSession()).thenAnswer((_) async {});

      final result = await repository.logout();

      expect(result.isSuccess, isTrue);
      verify(() => mockLocalDataSource.clearSession()).called(1);
    });
  });
}
