import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/core/constants/app_assets.dart';
import 'package:type_b/core/widgets/app_image.dart';

void main() {
  group('AppAssets Singleton', () {
    test('returns same singleton instance and holds messenger asset', () {
      final instance1 = AppAssets.instance;
      final instance2 = AppAssets();

      expect(identical(instance1, instance2), isTrue);
      expect(instance1.messenger, 'assets/images/messenger.png');
    });
  });

  group('AppImage Widget', () {
    testWidgets('renders Image with specified size and assetPath', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppImage(
              assetPath: 'assets/images/messenger.png',
              size: 24,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.width, 24);
      expect(imageWidget.height, 24);
      expect(imageWidget.color, Colors.blue);
    });
  });
}
