enum Environment { dev, staging, prod }

class AppConfig {
  static const String _defaultBaseUrl = 'https://dummyjson.com';
  static const int _defaultPaginationLimit = 10;
  static const int _defaultSearchDebounceMs = 300;

  final Environment environment;
  final String apiBaseUrl;
  final int paginationLimit;
  final int searchDebounceMs;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.paginationLimit,
    required this.searchDebounceMs,
  });

  /// Factory constructor to initialize from --dart-define flags
  factory AppConfig.fromEnvironment() {
    const String envString = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'dev',
    );
    const String baseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: _defaultBaseUrl,
    );
    const int limit = int.fromEnvironment(
      'PAGINATION_LIMIT',
      defaultValue: _defaultPaginationLimit,
    );
    const int debounce = int.fromEnvironment(
      'SEARCH_DEBOUNCE_MS',
      defaultValue: _defaultSearchDebounceMs,
    );

    Environment env;
    switch (envString.toLowerCase()) {
      case 'staging':
        env = Environment.staging;
        break;
      case 'prod':
      case 'production':
        env = Environment.prod;
        break;
      case 'dev':
      default:
        env = Environment.dev;
        break;
    }

    return AppConfig(
      environment: env,
      apiBaseUrl: baseUrl.isNotEmpty ? baseUrl : _defaultBaseUrl,
      paginationLimit: limit > 0 ? limit : _defaultPaginationLimit,
      searchDebounceMs: debounce > 0 ? debounce : _defaultSearchDebounceMs,
    );
  }

  /// Preset for Development environment
  factory AppConfig.dev() {
    return const AppConfig(
      environment: Environment.dev,
      apiBaseUrl: 'https://dummyjson.com',
      paginationLimit: 10,
      searchDebounceMs: 300,
    );
  }

  /// Preset for Staging environment
  factory AppConfig.staging() {
    return const AppConfig(
      environment: Environment.staging,
      apiBaseUrl: 'https://dummyjson.com',
      paginationLimit: 15,
      searchDebounceMs: 500,
    );
  }

  /// Preset for Production environment
  factory AppConfig.prod() {
    return const AppConfig(
      environment: Environment.prod,
      apiBaseUrl: 'https://dummyjson.com',
      paginationLimit: 20,
      searchDebounceMs: 800,
    );
  }

  String get environmentName {
    switch (environment) {
      case Environment.dev:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.prod:
        return 'Production';
    }
  }

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}
