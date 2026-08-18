# 📰 NewsBay — Flutter Enterprise Application

NewsBay is a high-performance news & articles mobile application built with Flutter, adhering strictly to **Clean Architecture**, **BLoC Pattern**, **Repository Pattern**, **Offline-First Secure Storage**, and the **DummyJSON API**.

---

## 🎯 Enterprise Features

### 🔐 Authentication & Security Suite
- **User Registration (`/users/add`)**: Complete signup flow with field validation (names, username, email regex, password matching).
- **JWT Token Management & Auto-Refresh (`/auth/refresh`)**: Dio interceptor transparently refreshes expired JWT access tokens using the refresh token on 401 Unauthorized responses.
- **Biometric Authentication**: Local biometric authentication (FaceID / TouchID / Fingerprint) abstraction via `BiometricService` for quick logins.
- **Secure Persistence (`flutter_secure_storage`)**: Sensitive JWT access/refresh tokens and user sessions are encrypted in iOS Keychain (`kSecAttrAccessibleAfterFirstUnlock`) and Android KeyStore (AES-CBC).
- **Session Auto-Restoration (`/auth/me`)**: Validates active session on app launch.
- **Quick Demo Accounts**: One-tap credential fill for `emilys` and `michaelw`.

### 📶 Offline-First Resilience
- **Offline Post Caching (`PostLocalDataSource`)**: Automatically persists the initial feed to encrypted local storage so articles can be viewed offline.
- **Network Status Monitoring (`NetworkInfoService`)**: Real-time connectivity monitor with an animated offline status indicator banner.

### 📱 Responsive & Adaptive UI
- **Adaptive Breakpoints (`ResponsiveLayout`)**:
  - **Mobile (< 600dp)**: Single-column vertical list with pull-to-refresh.
  - **Tablet & Landscape (600dp - 1024dp+)**: Multi-column responsive grid with adaptive aspect ratios.
- **Micro-interactions & Animations**: 60fps shimmer loading skeletons (`AppShimmer`), Hero transitions for cards (`Hero(tag: 'post_card_...')`), and smooth list animations.

### 🧪 Comprehensive Testing Suite
- **119 Automated Tests**: Unit tests, Data Source mocks, BLoC state transition tests (`bloc_test`), Widget tests (`login_page_test`, `register_page_test`, `post_card_widget_test`), and E2E Integration tests (`integration_test/app_test.dart`).
- **High Test Coverage**: **79.42%** across all tested business logic and presentation components.

### 🚀 CI/CD Pipeline
- **GitHub Actions (`.github/workflows/ci_cd.yml`)**:
  - Code formatting & static lint analysis (`flutter analyze`)
  - Unit & widget test execution with coverage enforcement
  - Multi-environment compilation matrix (`dev`, `staging`, `prod`)

---

## 🏗️ Architecture & State Management

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│    (Pages, Widgets, Custom UI, BLoC Events & States)       │
└──────────────────────────────▲──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                      Domain Layer                           │
│     (Entities, Repository Interfaces, Typed Failures)       │
└──────────────────────────────▲──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                       Data Layer                            │
│  (Repository Implementations, Remote/Local DataSources,     │
│   DTO Models, Dio HTTP Client, FlutterSecureStorage)        │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔑 Demo Credentials

| Username | Password | Full Name |
| :--- | :--- | :--- |
| `emilys` | `emilyspass` | Emily Johnson |
| `michaelw` | `michaelwpass` | Michael Williams |

---

## ⚙️ Multi-Environment Configuration

| Setting | Dev | Staging | Production |
| :--- | :---: | :---: | :---: |
| **API Base URL** | `https://dummyjson.com` | `https://dummyjson.com` | `https://dummyjson.com` |
| **Pagination Limit** | `10` | `15` | `20` |
| **Search Debounce** | `300ms` | `500ms` | `800ms` |

### Running via `--dart-define`

```bash
# Development
flutter run --dart-define=ENVIRONMENT=dev --dart-define=API_BASE_URL=https://dummyjson.com --dart-define=PAGINATION_LIMIT=10 --dart-define=SEARCH_DEBOUNCE_MS=300

# Staging
flutter run --dart-define=ENVIRONMENT=staging --dart-define=API_BASE_URL=https://dummyjson.com --dart-define=PAGINATION_LIMIT=15 --dart-define=SEARCH_DEBOUNCE_MS=500

# Production
flutter run --dart-define=ENVIRONMENT=prod --dart-define=API_BASE_URL=https://dummyjson.com --dart-define=PAGINATION_LIMIT=20 --dart-define=SEARCH_DEBOUNCE_MS=800
```

---

## 🧪 Testing Commands

```bash
# Run all unit and widget tests
flutter test --coverage

# Check test coverage report
dart pub global run test_cov_console

# Run E2E Integration test
flutter test integration_test/app_test.dart
```
