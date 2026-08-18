import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/core/constants/app_strings.dart';

void main() {
  group('AppStrings', () {
    test('instance_returnsSameSingletonInstance', () {
      final instance1 = AppStrings.instance;
      final instance2 = AppStrings.instance;
      final instance3 = AppStrings();

      expect(identical(instance1, instance2), isTrue);
      expect(identical(instance1, instance3), isTrue);
    });

    test('predefinedStrings_haveValidValues', () {
      expect(AppStrings.appName, equals('NewsBay'));
      expect(AppStrings.welcomeBack, equals('Welcome Back'));
      expect(AppStrings.login, equals('Login'));
      expect(AppStrings.goodMorning, equals('Good Morning!'));
      expect(AppStrings.profileTitle, equals('Profile'));
      expect(AppStrings.navHome, equals('Home'));
      expect(AppStrings.noInternetConnection, isNotEmpty);
    });
  });
}
