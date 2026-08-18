import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/core/errors/failures.dart';

void main() {
  group('Failures', () {
    test('serverFailure_props_containMessageAndStatusCode', () {
      const failure1 = ServerFailure('Internal error', statusCode: 500);
      const failure2 = ServerFailure('Internal error', statusCode: 500);
      const failure3 = ServerFailure('Not found', statusCode: 404);

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
      expect(failure1.props, equals(['Internal error', 500]));
    });

    test('networkFailure_defaultMessage_returnsStandardNoInternetMessage', () {
      const failure = NetworkFailure();

      expect(
        failure.message,
        equals('No internet connection. Please check your network.'),
      );
      expect(
        failure.props,
        equals(['No internet connection. Please check your network.']),
      );
    });

    test('authFailure_props_containMessageAndStatusCode', () {
      const failure1 = AuthFailure('Invalid password', statusCode: 400);
      const failure2 = AuthFailure('Invalid password', statusCode: 400);

      expect(failure1, equals(failure2));
      expect(failure1.props, equals(['Invalid password', 400]));
    });

    test('cacheFailure_props_containMessage', () {
      const failure1 = CacheFailure('Storage error');
      const failure2 = CacheFailure('Storage error');

      expect(failure1, equals(failure2));
    });

    test('validationFailure_props_containMessage', () {
      const failure1 = ValidationFailure('Invalid email');
      const failure2 = ValidationFailure('Invalid email');

      expect(failure1, equals(failure2));
    });
  });
}
