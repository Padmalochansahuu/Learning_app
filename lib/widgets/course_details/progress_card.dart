import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../data/models/course_model.dart';
import '../common/custom_progress_bar.dart';

/// Interactive Progress Card displaying overall completion stats and dynamic recalculation.
class ProgressCard extends StatelessWidget {
  final CourseModel course;

  const ProgressCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final progress = course.calculatedProgress;
    final completedCount = course.lessonList.where((l) => l.isCompleted).length;
    final totalCount = course.lessonList.isNotEmpty
        ? course.lessonList.length
        : course.lessons;

    final isCompleted = progress == 100;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusXl,
        border: Border.all(
          color: isCompleted
              ? AppColors.successBorder
              : AppColors.border,
          width: 1,
        ),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Status Label & Percentage Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.successLight
                          : AppColors.primaryLight,
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.insights_rounded,
                      size: 18,
                      color: isCompleted
                          ? AppColors.success
                          : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Your Learning Progress',
                    style: AppTypography.subtitle1.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              // Dynamic % Pill
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.successLight
                      : AppColors.primaryLight,
                  borderRadius: AppSpacing.borderRadiusFull,
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.successBorder
                        : AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  '$progress%',
                  style: AppTypography.h3.copyWith(
                    color: isCompleted
                        ? AppColors.success
                        : AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Dynamic Progress Bar
          CustomProgressBar(
            progressPercent: progress,
            height: 9,
            showLabel: false,
          ),
          const SizedBox(height: AppSpacing.md),

          // Completion counter & Congratulations badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completedCount of $totalCount lessons completed',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              if (isCompleted)
                Row(
                  children: [
                    const Icon(
                      Icons.celebration_rounded,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'All Complete!',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
