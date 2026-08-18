import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/core/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('run_afterDelay_executesActionOnce', () async {
      final debouncer = Debouncer(milliseconds: 50);
      int callCount = 0;

      debouncer.run(() {
        callCount++;
      });
      debouncer.run(() {
        callCount++;
      });
      debouncer.run(() {
        callCount++;
      });

      expect(callCount, equals(0));

      await Future<void>.delayed(const Duration(milliseconds: 70));

      expect(callCount, equals(1));
      debouncer.dispose();
    });

    test('cancel_beforeDelay_preventsExecution', () async {
      final debouncer = Debouncer(milliseconds: 50);
      int callCount = 0;

      debouncer.run(() {
        callCount++;
      });
      debouncer.cancel();

      await Future<void>.delayed(const Duration(milliseconds: 70));

      expect(callCount, equals(0));
      debouncer.dispose();
    });
  });
}
