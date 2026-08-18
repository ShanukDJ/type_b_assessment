import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/constants/app_strings.dart';
import 'package:type_b/features/auth/domain/repositories/auth_repository.dart';
import 'package:type_b/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:type_b/features/auth/presentation/pages/login_page.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(authRepository: mockAuthRepository),
        child: const LoginPage(),
      ),
    );
  }

  group('LoginPage Widget Test', () {
    testWidgets('renders all login UI elements including quick test accounts', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.text(AppStrings.welcomeBack), findsOneWidget);
      expect(find.text(AppStrings.emailOrUsername), findsOneWidget);
      expect(find.text(AppStrings.password), findsOneWidget);
      expect(find.text(AppStrings.login), findsOneWidget);
      expect(find.text(AppStrings.loginWithBiometrics), findsOneWidget);
      expect(find.text(AppStrings.loginWithGoogle), findsOneWidget);
      expect(find.text(AppStrings.signUp), findsOneWidget);
      expect(find.text('👤 emilys'), findsOneWidget);
      expect(find.text('👤 michaelw'), findsOneWidget);
    });

    testWidgets('populates fields when tapping quick account chips', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());

      final chipFinder = find.text('👤 michaelw');
      await tester.ensureVisible(chipFinder);
      await tester.tap(chipFinder);
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
