import 'package:flutter_test/flutter_test.dart';
import 'package:type_b/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('dev_factoryConstructor_returnsDevConfig', () {
      final config = AppConfig.dev();

      expect(config.environment, equals(Environment.dev));
      expect(config.apiBaseUrl, equals('https://dummyjson.com'));
      expect(config.paginationLimit, equals(10));
      expect(config.searchDebounceMs, equals(300));
      expect(config.isDev, isTrue);
      expect(config.isStaging, isFalse);
      expect(config.isProd, isFalse);
      expect(config.environmentName, equals('Development'));
    });

    test('staging_factoryConstructor_returnsStagingConfig', () {
      final config = AppConfig.staging();

      expect(config.environment, equals(Environment.staging));
      expect(config.apiBaseUrl, equals('https://dummyjson.com'));
      expect(config.paginationLimit, equals(15));
      expect(config.searchDebounceMs, equals(500));
      expect(config.isDev, isFalse);
      expect(config.isStaging, isTrue);
      expect(config.isProd, isFalse);
      expect(config.environmentName, equals('Staging'));
    });

    test('prod_factoryConstructor_returnsProdConfig', () {
      final config = AppConfig.prod();

      expect(config.environment, equals(Environment.prod));
      expect(config.apiBaseUrl, equals('https://dummyjson.com'));
      expect(config.paginationLimit, equals(20));
      expect(config.searchDebounceMs, equals(800));
      expect(config.isDev, isFalse);
      expect(config.isStaging, isFalse);
      expect(config.isProd, isTrue);
      expect(config.environmentName, equals('Production'));
    });

    test('fromEnvironment_defaultValues_returnsDefaultDevConfig', () {
      final config = AppConfig.fromEnvironment();

      expect(config.environment, equals(Environment.dev));
      expect(config.apiBaseUrl, equals('https://dummyjson.com'));
      expect(config.paginationLimit, equals(10));
      expect(config.searchDebounceMs, equals(300));
    });
  });
}
