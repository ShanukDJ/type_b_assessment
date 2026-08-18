import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/errors/exceptions.dart';
import 'package:type_b/core/storage/secure_storage_service.dart';
import 'package:type_b/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:type_b/features/auth/data/models/user_model.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService mockStorageService;
  late AuthLocalDataSourceImpl dataSource;

  const tUserModel = UserModel(
    id: 1,
    username: 'emilys',
    email: 'emily@example.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    accessToken: 'token-123',
  );

  setUp(() {
    mockStorageService = MockSecureStorageService();
    dataSource = AuthLocalDataSourceImpl(storageService: mockStorageService);
  });

  group('AuthLocalDataSourceImpl', () {
    test('saveToken_delegatesToStorageService', () async {
      when(
        () => mockStorageService.saveToken('token-123'),
      ).thenAnswer((_) async {});

      await dataSource.saveToken('token-123');

      verify(() => mockStorageService.saveToken('token-123')).called(1);
    });

    test('getToken_delegatesToStorageService', () async {
      when(
        () => mockStorageService.getToken(),
      ).thenAnswer((_) async => 'token-123');

      final token = await dataSource.getToken();

      expect(token, equals('token-123'));
      verify(() => mockStorageService.getToken()).called(1);
    });

    test('deleteToken_delegatesToStorageService', () async {
      when(() => mockStorageService.deleteToken()).thenAnswer((_) async {});

      await dataSource.deleteToken();

      verify(() => mockStorageService.deleteToken()).called(1);
    });

    test('saveUser_delegatesToStorageService', () async {
      when(
        () => mockStorageService.saveUserData(any()),
      ).thenAnswer((_) async {});

      await dataSource.saveUser(tUserModel);

      verify(() => mockStorageService.saveUserData(any())).called(1);
    });

    test('getUser_whenDataExists_returnsUserModel', () async {
      when(
        () => mockStorageService.getUserData(),
      ).thenAnswer((_) async => tUserModel.toJson());

      final result = await dataSource.getUser();

      expect(result, equals(tUserModel));
    });

    test('getUser_whenNull_returnsNull', () async {
      when(
        () => mockStorageService.getUserData(),
      ).thenAnswer((_) async => null);

      final result = await dataSource.getUser();

      expect(result, isNull);
    });

    test('clearSession_delegatesToStorageService', () async {
      when(() => mockStorageService.clearSession()).thenAnswer((_) async {});

      await dataSource.clearSession();

      verify(() => mockStorageService.clearSession()).called(1);
    });

    test('saveToken_onException_throwsCacheException', () async {
      when(
        () => mockStorageService.saveToken(any()),
      ).thenThrow(const CacheException(message: 'Storage error'));

      expect(
        () => dataSource.saveToken('token-123'),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
