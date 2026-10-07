import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/core/constants/app_strings.dart';
import 'package:learning_app/core/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('Email validator accepts valid email addresses', () {
      expect(Validators.validateEmail('student@learnhub.com'), isNull);
      expect(Validators.validateEmail('user.name+tag@example.co.uk'), isNull);
    });

    test('Email validator returns error for empty or blank email', () {
      expect(Validators.validateEmail(''), equals(AppStrings.emailRequired));
      expect(Validators.validateEmail('   '), equals(AppStrings.emailRequired));
      expect(Validators.validateEmail(null), equals(AppStrings.emailRequired));
    });

    test('Email validator returns error for invalid email formats', () {
      expect(Validators.validateEmail('notanemail'), equals(AppStrings.emailInvalid));
      expect(Validators.validateEmail('missingdomain@'), equals(AppStrings.emailInvalid));
      expect(Validators.validateEmail('@nodomain.com'), equals(AppStrings.emailInvalid));
    });

    test('Password validator accepts passwords >= 6 characters', () {
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('password123'), isNull);
    });

    test('Password validator returns error for passwords < 6 characters', () {
      expect(Validators.validatePassword(''), equals(AppStrings.passwordRequired));
      expect(Validators.validatePassword(null), equals(AppStrings.passwordRequired));
      expect(Validators.validatePassword('12345'), equals(AppStrings.passwordTooShort));
    });
  });
}
