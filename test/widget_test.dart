import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/core/constants/app_strings.dart';
import 'package:learning_app/data/datasources/local_storage_service.dart';
import 'package:learning_app/data/datasources/mock_course_api.dart';
import 'package:learning_app/data/repositories/auth_repository.dart';
import 'package:learning_app/data/repositories/course_repository.dart';
import 'package:learning_app/main.dart';
import 'package:learning_app/widgets/common/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App renders Login screen and handles validation', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = LocalStorageService(prefs);
    final api = MockCourseApi();
    final authRepo = AuthRepository(api: api, storage: storage);
    final courseRepo = CourseRepository(api: api, storage: storage);

    await tester.pumpWidget(
      LearningApp(
        authRepository: authRepo,
        courseRepository: courseRepo,
      ),
    );

    // Initial pump & settle
    await tester.pumpAndSettle();

    // Verify Login Screen widgets exist
    expect(find.text(AppStrings.loginTitle), findsOneWidget);
    expect(find.text(AppStrings.loginButton), findsOneWidget);
    expect(find.text(AppStrings.emailLabel), findsOneWidget);
    expect(find.text(AppStrings.passwordLabel), findsOneWidget);

    // Tap Login with empty fields to trigger validation
    final loginButton = find.widgetWithText(CustomButton, AppStrings.loginButton);
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify validation errors are shown
    expect(find.text(AppStrings.emailRequired), findsOneWidget);
    expect(find.text(AppStrings.passwordRequired), findsOneWidget);

    // Enter credentials directly
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.first, AppStrings.demoEmail);
    await tester.enterText(textFields.last, AppStrings.demoPassword);
    await tester.pumpAndSettle();

    // Verify values populated
    expect(find.text(AppStrings.demoEmail), findsOneWidget);
  });
}
