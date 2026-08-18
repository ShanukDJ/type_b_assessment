import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/features/auth/data/models/user_model.dart';
import 'package:type_b/features/auth/domain/entities/user_entity.dart';

void main() {
  const tUserModel = UserModel(
    id: 1,
    username: 'emilys',
    email: 'emily.johnson@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    gender: 'female',
    image: 'https://dummyjson.com/icon/emilys/128',
    accessToken: 'jwt-access-token',
    refreshToken: 'jwt-refresh-token',
  );

  group('UserModel', () {
    test('userModel_isSubclassOfUserEntity', () {
      expect(tUserModel, isA<UserEntity>());
    });

    test('fromJson_validJson_returnsValidModel', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'username': 'emilys',
        'email': 'emily.johnson@x.dummyjson.com',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'gender': 'female',
        'image': 'https://dummyjson.com/icon/emilys/128',
        'accessToken': 'jwt-access-token',
        'refreshToken': 'jwt-refresh-token',
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result, equals(tUserModel));
      expect(result.fullName, equals('Emily Johnson'));
      expect(result.initials, equals('EJ'));
    });

    test('fromJson_fallbackTokenField_parsesTokenCorrectly', () {
      final Map<String, dynamic> jsonMap = {
        'id': '2',
        'username': 'michaelw',
        'email': 'michael.w@x.dummyjson.com',
        'firstName': 'Michael',
        'lastName': 'Williams',
        'token': 'jwt-fallback-token',
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.id, equals(2));
      expect(result.accessToken, equals('jwt-fallback-token'));
    });

    test('toJson_returnsExpectedMap', () {
      final jsonMap = tUserModel.toJson();

      expect(jsonMap['id'], equals(1));
      expect(jsonMap['username'], equals('emilys'));
      expect(jsonMap['email'], equals('emily.johnson@x.dummyjson.com'));
      expect(jsonMap['accessToken'], equals('jwt-access-token'));
    });

    test('copyWith_updatesPropertiesCorrectly', () {
      final updated = tUserModel.copyWith(firstName: 'Emma');

      expect(updated.firstName, equals('Emma'));
      expect(updated.lastName, equals('Johnson'));
      expect(updated.id, equals(1));
    });
  });
}
