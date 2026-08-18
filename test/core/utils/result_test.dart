import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/core/errors/failures.dart';
import 'package:type_b/core/utils/result.dart';

void main() {
  group('Result', () {
    test('success_whenMethodsCalled_returnsExpectedValues', () {
      const Result<String, Failure> result = Success('data');

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, equals('data'));
      expect(result.failureOrNull, isNull);

      final whenValue = result.when(
        success: (data) => 'success: $data',
        failure: (failure) => 'failure: ${failure.message}',
      );
      expect(whenValue, equals('success: data'));

      final mapped = result.map((data) => data.length);
      expect(mapped.dataOrNull, equals(4));

      final folded = result.fold(
        (failure) => 'error',
        (data) => 'folded: $data',
      );
      expect(folded, equals('folded: data'));
    });

    test('failureResult_whenMethodsCalled_returnsExpectedValues', () {
      const Result<String, Failure> result = FailureResult(
        ServerFailure('server error'),
      );

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, equals(const ServerFailure('server error')));

      final whenValue = result.when(
        success: (data) => 'success: $data',
        failure: (failure) => 'failure: ${failure.message}',
      );
      expect(whenValue, equals('failure: server error'));

      final mapped = result.map((data) => data.length);
      expect(mapped.isFailure, isTrue);

      final folded = result.fold(
        (failure) => 'folded error: ${failure.message}',
        (data) => 'success',
      );
      expect(folded, equals('folded error: server error'));
    });
  });
}
