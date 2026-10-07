import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_typography.dart';
import '../../data/models/course_model.dart';
import '../common/custom_button.dart';
import '../common/custom_progress_bar.dart';

/// Course Card displaying banner image, instructor avatar, title, progress %, lessons count, and Continue button.
class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onContinue;

  const CourseCard({
    super.key,
    required this.course,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveProgress = course.calculatedProgress;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppSpacing.borderRadiusLg,
        child: InkWell(
          onTap: onContinue,
          borderRadius: AppSpacing.borderRadiusLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Course Banner Image with Badges
              _buildCourseBanner(context),

              // 2. Card Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instructor Avatar & Name Row
                    _buildInstructorRow(),
                    const SizedBox(height: AppSpacing.sm),

                    // Course Title
                    Text(
                      course.title,
                      style: AppTypography.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // Lessons Count & Category meta row (Strict PDF requirement: Lessons count)
                    Row(
                      children: [
                        const Icon(
                          Icons.play_lesson_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.lessons}${AppStrings.lessonsCountSuffix}',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (course.category.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text(
                            '•',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            course.category,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Course Description Preview
                    if (course.description.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        course.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.md),

                    // Progress Bar with Percentage
                    CustomProgressBar(
                      progressPercent: effectiveProgress,
                      height: 7,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Continue Action Button (strict PDF requirement: "Continue" button)
                    CustomButton(
                      text: AppStrings.continueButton,
                      icon: Icons.play_arrow_rounded,
                      height: 44,
                      onPressed: onContinue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the top image banner with fallback gradient and floating badges
  Widget _buildCourseBanner(BuildContext context) {
    final accentColor = _getAccentColor(course.id);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusLg),
      ),
      child: Stack(
        children: [
          // Banner Image
          SizedBox(
            height: 145,
            width: double.infinity,
            child: course.thumbnailUrl.isNotEmpty
                ? Image.network(
                    course.thumbnailUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: accentColor.withValues(alpha: 0.15),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: accentColor,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        _buildFallbackBanner(accentColor),
                  )
                : _buildFallbackBanner(accentColor),
          ),

          // Gradient overlay for contrast
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),

          // Top Left: Category Badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: AppSpacing.borderRadiusFull,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getCourseIcon(course.id),
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    course.category.isNotEmpty
                        ? course.category
                        : 'Certified Course',
                    style: AppTypography.badge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Right: Lessons Count Badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: AppSpacing.borderRadiusFull,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_lesson_outlined,
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${course.lessons}${AppStrings.lessonsCountSuffix}',
                    style: AppTypography.badge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fallback banner when image is offline or loading fails
  Widget _buildFallbackBanner(Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.8),
            accentColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          _getCourseIcon(course.id),
          size: 48,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  /// Instructor avatar and title row
  Widget _buildInstructorRow() {
    return Row(
      children: [
        // Instructor Avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 32,
            height: 32,
            child: course.instructorAvatarUrl.isNotEmpty
                ? Image.network(
                    course.instructorAvatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDefaultAvatar(),
                  )
                : _buildDefaultAvatar(),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Instructor Name & Tag
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.instructorPrefix}${course.instructor}',
                style: AppTypography.subtitle2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Verified Instructor',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.person_rounded,
        size: 18,
        color: AppColors.textSecondary,
      ),
    );
  }

  Color _getAccentColor(int id) {
    switch (id % 3) {
      case 1:
        return const Color(0xFF4F46E5); // Indigo
      case 2:
        return const Color(0xFF0EA5E9); // Sky
      default:
        return const Color(0xFF8B5CF6); // Purple
    }
  }

  IconData _getCourseIcon(int id) {
    switch (id) {
      case 1:
        return Icons.code_rounded;
      case 2:
        return Icons.auto_awesome_rounded;
      case 3:
        return Icons.layers_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}
