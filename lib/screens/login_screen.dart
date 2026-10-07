import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_typography.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';
import 'dashboard_screen.dart';

/// Screen 1 — Login Screen
/// Implements email & password inputs, validation, loading state, error display, and navigation.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthViewModel authVM) async {
    FocusScope.of(context).unfocus();
    final success = await authVM.login();
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Brand Logo & Title
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: AppSpacing.borderRadiusXl,
                        boxShadow: AppSpacing.elevatedShadow,
                        image: const DecorationImage(
                          image: AssetImage('assets/icons/app_icon.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Center(
                    child: Text(
                      AppStrings.loginTitle,
                      style: AppTypography.h1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Center(
                    child: Text(
                      AppStrings.loginSubtitle,
                      style: AppTypography.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Error State Banner (if login failed)
                  if (authVM.generalError != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: AppSpacing.borderRadiusMd,
                        border: Border.all(
                          color: AppColors.errorBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 20,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              authVM.generalError!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // Email Input Field
                  CustomTextField(
                    label: AppStrings.emailLabel,
                    hint: AppStrings.emailHint,
                    controller: authVM.emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    errorText: authVM.emailError,
                    focusNode: _emailFocus,
                    onChanged: authVM.onEmailChanged,
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Password Input Field
                  CustomTextField(
                    label: AppStrings.passwordLabel,
                    hint: AppStrings.passwordHint,
                    controller: authVM.passwordController,
                    obscureText: authVM.obscurePassword,
                    prefixIcon: Icons.lock_outline_rounded,
                    errorText: authVM.passwordError,
                    focusNode: _passwordFocus,
                    onChanged: authVM.onPasswordChanged,
                    onSubmitted: (_) => _handleLogin(authVM),
                    suffixIcon: IconButton(
                      icon: Icon(
                        authVM.obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: authVM.togglePasswordVisibility,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Auto-fill button for quick testing
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: authVM.isLoading
                          ? null
                          : () => authVM.fillDemoCredentials(),
                      icon: const Icon(Icons.flash_on_rounded, size: 16),
                      label: Text(
                        'Auto-fill Test Account',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Login Button with Loading State
                  CustomButton(
                    text: authVM.isLoading
                        ? AppStrings.loggingIn
                        : AppStrings.loginButton,
                    isLoading: authVM.isLoading,
                    icon: Icons.login_rounded,
                    onPressed: () => _handleLogin(authVM),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Subtitle notice
                  Center(
                    child: Text(
                      'Cross-platform Flutter build • Android & iOS',
                      style: AppTypography.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
