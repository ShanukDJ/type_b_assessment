# NewsBay

NewsBay is a Flutter news and articles reader application built with clean architecture, BLoC state management, and offline-first capabilities using the DummyJSON API.

---

## Architecture Overview

The codebase follows Clean Architecture principles divided into three core layers:

```
lib/
├── core/
│   ├── config/          # Environment configuration (Dev, Staging, Prod)
│   ├── constants/       # App strings and asset paths
│   ├── errors/          # Custom exceptions and typed failures
│   ├── network/         # Dio client and token refresh interceptors
│   ├── services/        # Biometric and connectivity services
│   ├── storage/         # Secure storage service
│   ├── theme/           # Colors, typography, and theme definitions
│   ├── utils/           # Debouncer and result helpers
│   └── widgets/         # Reusable UI components (buttons, text fields, skeletons)
└── features/
    ├── auth/            # Authentication (login, registration, session management)
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── home/            # Main navigation wrapper
    ├── posts/           # Posts feed, search, and detail view
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── profile/         # User profile and settings
        └── presentation/
```

### Key Features

- **Authentication & Security**:
  - Email/username login and account registration.
  - JWT token storage in encrypted platform storage (`flutter_secure_storage`).
  - Automatic token refresh interceptor handling `401 Unauthorized` responses.
  - Biometric authentication integration via `BiometricService`.
- **Feed & Reading Experience**:
  - Paginated article feed with pull-to-refresh and infinite scrolling.
  - Live search with debouncing.
  - Featured posts carousel and recent posts grid/list.
  - Article detail view with engagement metrics.
- **Offline Support**:
  - Local caching of fetched posts for offline reading.
  - Network connectivity monitoring with an offline status banner.
- **Responsive Layout**:
  - Adapts between single-column mobile view and multi-column grid layouts for tablets and wider screens.
  - Custom shimmer skeletons for smooth loading states.

---

## Getting Started

### Prerequisites

- Flutter SDK (3.12.2 or higher)
- Dart SDK
- Android Studio / Xcode for device simulation

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd type_b_assessment
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

---

## Environment Configurations

The application supports multiple environments via `--dart-define` parameters:

| Parameter | Dev | Staging | Production |
| :--- | :---: | :---: | :---: |
| `ENVIRONMENT` | `dev` | `staging` | `prod` |
| `API_BASE_URL` | `https://dummyjson.com` | `https://dummyjson.com` | `https://dummyjson.com` |
| `PAGINATION_LIMIT` | `10` | `15` | `20` |
| `SEARCH_DEBOUNCE_MS` | `300` | `500` | `800` |

### Running with specific environments

```bash
# Development
flutter run --dart-define=ENVIRONMENT=dev --dart-define=PAGINATION_LIMIT=10 --dart-define=SEARCH_DEBOUNCE_MS=300

# Staging
flutter run --dart-define=ENVIRONMENT=staging --dart-define=PAGINATION_LIMIT=15 --dart-define=SEARCH_DEBOUNCE_MS=500

# Production
flutter run --dart-define=ENVIRONMENT=prod --dart-define=PAGINATION_LIMIT=20 --dart-define=SEARCH_DEBOUNCE_MS=800
```

---

## Testing & Quality

### Static Analysis
```bash
flutter analyze
```

### Unit & Widget Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/app_test.dart
```
