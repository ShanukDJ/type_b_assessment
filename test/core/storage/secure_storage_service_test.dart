import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/errors/exceptions.dart';
import 'package:type_b/core/storage/secure_storage_service.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecureStorageServiceImpl service;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = SecureStorageServiceImpl(storage: mockStorage);
  });

  group('SecureStorageServiceImpl', () {
    test('saveToken_withValidString_delegatesToWrite', () async {
      when(
        () => mockStorage.write(key: 'auth_token', value: 'jwt-123'),
      ).thenAnswer((_) async {});

      await service.saveToken('jwt-123');

      verify(
        () => mockStorage.write(key: 'auth_token', value: 'jwt-123'),
      ).called(1);
    });

    test('getToken_whenTokenExists_returnsTokenString', () async {
      when(
        () => mockStorage.read(key: 'auth_token'),
      ).thenAnswer((_) async => 'jwt-123');

      final token = await service.getToken();

      expect(token, equals('jwt-123'));
      verify(() => mockStorage.read(key: 'auth_token')).called(1);
    });

    test('deleteToken_callsStorageDelete', () async {
      when(
        () => mockStorage.delete(key: 'auth_token'),
      ).thenAnswer((_) async {});

      await service.deleteToken();

      verify(() => mockStorage.delete(key: 'auth_token')).called(1);
    });

    test('saveUserData_withValidMap_writesJsonStringToStorage', () async {
      final userMap = {'id': 1, 'username': 'emilys'};
      when(
        () => mockStorage.write(
          key: 'cached_user',
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await service.saveUserData(userMap);

      verify(
        () => mockStorage.write(
          key: 'cached_user',
          value: any(named: 'value'),
        ),
      ).called(1);
    });

    test('getUserData_whenValidJson_returnsDecodedMap', () async {
      when(
        () => mockStorage.read(key: 'cached_user'),
      ).thenAnswer((_) async => '{"id":1,"username":"emilys"}');

      final result = await service.getUserData();

      expect(result, isNotNull);
      expect(result!['id'], equals(1));
      expect(result['username'], equals('emilys'));
    });

    test('getUserData_whenNull_returnsNull', () async {
      when(
        () => mockStorage.read(key: 'cached_user'),
      ).thenAnswer((_) async => null);

      final result = await service.getUserData();

      expect(result, isNull);
    });

    test('clearSession_deletesTokenAndUserData', () async {
      when(
        () => mockStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      await service.clearSession();

      verify(() => mockStorage.delete(key: 'auth_token')).called(1);
      verify(() => mockStorage.delete(key: 'cached_user')).called(1);
    });

    test('write_onStorageException_throwsCacheException', () async {
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(Exception('Storage write failure'));

      expect(
        () => service.write(key: 'key', value: 'val'),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
