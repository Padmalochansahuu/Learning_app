import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../data/models/lesson_model.dart';
import '../common/status_badge.dart';

/// Reusable tile component for individual lessons in Screen 3.
/// Allows toggling completion status with immediate visual feedback.
class LessonTile extends StatelessWidget {
  final int index;
  final LessonModel lesson;
  final VoidCallback onToggle;

  const LessonTile({
    super.key,
    required this.index,
    required this.lesson,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = lesson.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.surface : Colors.white,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: isCompleted ? AppColors.successBorder : AppColors.border,
          width: 1.2,
        ),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppSpacing.borderRadiusMd,
        child: InkWell(
          onTap: onToggle,
          borderRadius: AppSpacing.borderRadiusMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                // Checkbox / Circle indicator
                InkWell(
                  onTap: onToggle,
                  borderRadius: AppSpacing.borderRadiusFull,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? AppColors.success : Colors.transparent,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.success
                            : AppColors.textMuted,
                        width: 1.8,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Title & Duration
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? AppColors.textPrimary
                              : AppColors.textPrimary,
                          decoration: isCompleted
                              ? TextDecoration.none
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 12,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.durationMinutes} mins',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),

                // Status Badge (Completed ✓ / Pending ○)
                StatusBadge(isCompleted: isCompleted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
