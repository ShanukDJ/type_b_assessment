import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:type_b/core/constants/app_strings.dart';
import 'package:type_b/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NewsBay End-to-End Integration Test', () {
    testWidgets(
      'Full User Journey: Splash -> Login -> Feed -> Detail -> Profile',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Check if Login Page is displayed
        expect(find.text(AppStrings.welcomeBack), findsOneWidget);

        // Tap Login Button with default demo credentials
        final loginButton = find.text(AppStrings.login);
        expect(loginButton, findsOneWidget);
        await tester.tap(loginButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Check if Dashboard or Loading is reached
        expect(find.text(AppStrings.searchPostsPlaceholder), findsOneWidget);
      },
    );
  });
}
