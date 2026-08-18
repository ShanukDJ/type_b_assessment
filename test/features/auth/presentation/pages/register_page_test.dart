import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:type_b/core/constants/app_strings.dart';
import 'package:type_b/features/auth/domain/repositories/auth_repository.dart';
import 'package:type_b/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:type_b/features/auth/presentation/pages/register_page.dart';

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
        child: const RegisterPage(),
      ),
    );
  }

  group('RegisterPage Widget Test', () {
    testWidgets('renders all registration form fields and submit button', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(AppStrings.createAccount), findsOneWidget);
      expect(find.text(AppStrings.joinNewsBay), findsOneWidget);
      expect(find.text(AppStrings.firstName), findsOneWidget);
      expect(find.text(AppStrings.lastName), findsOneWidget);
      expect(find.text(AppStrings.username), findsOneWidget);
      expect(find.text(AppStrings.email), findsOneWidget);
      expect(find.text(AppStrings.password), findsOneWidget);
      expect(find.text(AppStrings.confirmPassword), findsOneWidget);
      expect(find.text(AppStrings.register), findsOneWidget);
      expect(find.text(AppStrings.alreadyHaveAccount), findsOneWidget);
    });

    testWidgets('validates required fields on empty submit', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());

      final submitBtn = find.text(AppStrings.register);
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.fieldRequired), findsWidgets);
    });
  });
}
