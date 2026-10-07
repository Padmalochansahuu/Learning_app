import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

/// Reusable status badge indicating completion states (Completed ✓ / Pending ○).
class StatusBadge extends StatelessWidget {
  final bool isCompleted;

  const StatusBadge({
    super.key,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.successLight,
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(color: AppColors.successBorder, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 14,
              color: AppColors.success,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Completed',
              style: AppTypography.badge.copyWith(
                color: const Color(0xFF065F46), // Deep emerald
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textSecondary, width: 1.8),
            ),
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            'Pending',
            style: AppTypography.badge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
