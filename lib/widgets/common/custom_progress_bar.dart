import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

/// Reusable animated linear progress bar with percentage indicator.
class CustomProgressBar extends StatelessWidget {
  final int progressPercent;
  final double height;
  final bool showLabel;
  final Color? barColor;

  const CustomProgressBar({
    super.key,
    required this.progressPercent,
    this.height = 8.0,
    this.showLabel = true,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progressPercent.clamp(0, 100);
    final factor = clamped / 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$clamped%',
                style: AppTypography.subtitle2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: clamped == 100 ? AppColors.success : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Stack(
          children: [
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: factor),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return Container(
                      height: height,
                      width: constraints.maxWidth * value,
                      decoration: BoxDecoration(
                        gradient: clamped == 100
                            ? const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                              )
                            : (barColor != null
                                ? null
                                : AppColors.primaryGradient),
                        color: barColor,
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
