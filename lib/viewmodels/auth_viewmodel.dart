import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/validators.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

/// ViewModel managing authentication state and input validations for Screen 1.
class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthViewModel({required this.repository});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  String? _generalError;
  UserModel? _currentUser;

  // Getters
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get generalError => _generalError;
  UserModel? get currentUser => _currentUser ?? repository.getCurrentUser();
  bool get isAuthenticated => repository.isLoggedIn;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void onEmailChanged(String val) {
    if (_emailError != null) {
      _emailError = null;
      notifyListeners();
    }
    if (_generalError != null) {
      _generalError = null;
      notifyListeners();
    }
  }

  void onPasswordChanged(String val) {
    if (_passwordError != null) {
      _passwordError = null;
      notifyListeners();
    }
    if (_generalError != null) {
      _generalError = null;
      notifyListeners();
    }
  }

  /// Autofills demo credentials for quick and hassle-free evaluation.
  void fillDemoCredentials() {
    emailController.text = AppStrings.demoEmail;
    passwordController.text = AppStrings.demoPassword;
    _emailError = null;
    _passwordError = null;
    _generalError = null;
    notifyListeners();
  }

  /// Validates inputs and performs login.
  Future<bool> login() async {
    // 1. Validate inputs
    final emailValidation = Validators.validateEmail(emailController.text);
    final passwordValidation = Validators.validatePassword(passwordController.text);

    _emailError = emailValidation;
    _passwordError = passwordValidation;
    _generalError = null;

    if (emailValidation != null || passwordValidation != null) {
      notifyListeners();
      return false;
    }

    // 2. Perform API call
    _isLoading = true;
    notifyListeners();

    try {
      final user = await repository.login(
        emailController.text.trim(),
        passwordController.text,
      );
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _generalError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Logs out active session.
  Future<void> logout() async {
    await repository.logout();
    _currentUser = null;
    emailController.clear();
    passwordController.clear();
    _generalError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
