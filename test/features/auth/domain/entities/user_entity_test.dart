import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    test('initials_withFirstAndLastName_returnsTwoLetters', () {
      const user = UserEntity(
        id: 1,
        username: 'emilys',
        email: 'emily@example.com',
        firstName: 'Emily',
        lastName: 'Johnson',
      );

      expect(user.initials, equals('EJ'));
    });

    test('initials_withSingleName_returnsFirstTwoLetters', () {
      const user = UserEntity(
        id: 2,
        username: 'michael',
        email: 'michael@example.com',
        firstName: 'Michael',
        lastName: '',
      );

      expect(user.initials, equals('MI'));
    });

    test('initials_withOnlyUsername_returnsFirstTwoLetters', () {
      const user = UserEntity(
        id: 3,
        username: 'adminuser',
        email: 'admin@example.com',
        firstName: '',
        lastName: '',
      );

      expect(user.initials, equals('AD'));
    });

    test('fullName_combinesFirstAndLastName', () {
      const user = UserEntity(
        id: 1,
        username: 'emilys',
        email: 'emily@example.com',
        firstName: 'Emily',
        lastName: 'Johnson',
      );

      expect(user.fullName, equals('Emily Johnson'));
    });
  });
}
