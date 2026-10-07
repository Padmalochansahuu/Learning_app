import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

enum ButtonVariant { primary, secondary, outline }

/// Reusable high-performance button widget with variants and loading state.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final IconData? icon;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? AppSpacing.buttonHeight;

    if (variant == ButtonVariant.outline) {
      return SizedBox(
        height: effectiveHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            foregroundColor: AppColors.primary,
          ),
          child: _buildContent(AppColors.primary),
        ),
      );
    }

    if (variant == ButtonVariant.secondary) {
      return SizedBox(
        height: effectiveHeight,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMd,
            ),
          ),
          child: _buildContent(AppColors.primary),
        ),
      );
    }

    // Default: Primary
    return SizedBox(
      height: effectiveHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppSpacing.borderRadiusMd,
          gradient: onPressed == null || isLoading
              ? null
              : AppColors.primaryGradient,
          color: (onPressed == null || isLoading) ? AppColors.border : null,
          boxShadow: (onPressed == null || isLoading)
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.textOnPrimary,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMd,
            ),
          ),
          child: _buildContent(Colors.white),
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: AppSpacing.sm),
          Text(
            text,
            style: AppTypography.button.copyWith(color: textColor),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTypography.button.copyWith(color: textColor),
    );
  }
}
