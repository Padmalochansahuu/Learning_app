import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_typography.dart';
import '../data/models/course_model.dart';
import '../data/repositories/course_repository.dart';
import '../viewmodels/course_details_viewmodel.dart';
import '../widgets/course_details/lesson_tile.dart';
import '../widgets/course_details/progress_card.dart';

/// Screen 3 — Course Details
/// Displays course banner, instructor details, dummy description, current progress, and list of lessons.
/// Allows user to mark lessons as completed with immediate progress recalculation and offline persistence.
class CourseDetailsScreen extends StatelessWidget {
  final CourseModel course;
  final ValueChanged<CourseModel>? onCourseUpdated;

  const CourseDetailsScreen({
    super.key,
    required this.course,
    this.onCourseUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CourseDetailsViewModel(
        repository: ctx.read<CourseRepository>(),
        initialCourse: course,
        onCourseUpdated: onCourseUpdated,
      ),
      child: const _CourseDetailsContent(),
    );
  }
}

class _CourseDetailsContent extends StatelessWidget {
  const _CourseDetailsContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CourseDetailsViewModel>();
    final currentCourse = viewModel.course;
    final lessons = currentCourse.lessonList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.courseDetailsTitle, style: AppTypography.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Course Hero Banner
            _buildHeroBanner(currentCourse),
            const SizedBox(height: AppSpacing.lg),

            // 2. Course Title & Instructor Card
            _buildHeaderCard(currentCourse),
            const SizedBox(height: AppSpacing.md),

            // 3. About This Course Description Card
            if (currentCourse.description.isNotEmpty) ...[
              _buildDescriptionCard(currentCourse),
              const SizedBox(height: AppSpacing.md),
            ],

            // 4. Screen 3 Requirement: Current Progress Card (Interactive)
            ProgressCard(course: currentCourse),
            const SizedBox(height: AppSpacing.xl),

            // 5. Curriculum Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.curriculumTitle,
                  style: AppTypography.h3,
                ),
                Text(
                  '${viewModel.completedLessonsCount}/${viewModel.totalLessonsCount} Completed',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tap any lesson to mark as completed or pending',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // 6. Screen 3 Requirement: List of Lessons
            if (lessons.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppSpacing.borderRadiusLg,
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Text(
                    'No lessons available for this course.',
                    style: AppTypography.subtitle2,
                  ),
                ),
              )
            else
              Column(
                children: List.generate(lessons.length, (index) {
                  final lesson = lessons[index];
                  return LessonTile(
                    index: index,
                    lesson: lesson,
                    onToggle: () => viewModel.toggleLesson(lesson.id),
                  );
                }),
              ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  /// High-resolution banner image with overlay tags
  Widget _buildHeroBanner(CourseModel course) {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusXl,
      child: Stack(
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: course.thumbnailUrl.isNotEmpty
                ? Image.network(
                    course.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildFallbackBanner(course.id),
                  )
                : _buildFallbackBanner(course.id),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
          // Category Chip
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: AppSpacing.borderRadiusFull,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 0.5,
                ),
              ),
              child: Text(
                course.category.isNotEmpty ? course.category : 'Certification',
                style: AppTypography.badge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Total Lessons Tag
          Positioned(
            bottom: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: AppSpacing.borderRadiusFull,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_circle_fill_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${course.lessons} Modules',
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

  Widget _buildFallbackBanner(int id) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.school_rounded,
          size: 52,
          color: Colors.white70,
        ),
      ),
    );
  }

  /// Title & Instructor profile
  Widget _buildHeaderCard(CourseModel course) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusXl,
        border: Border.all(color: AppColors.border),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.title,
            style: AppTypography.h2.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 40,
                  height: 40,
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
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.instructor,
                      style: AppTypography.subtitle1.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Senior Course Instructor',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: AppSpacing.borderRadiusSm,
                  border: Border.all(color: AppColors.successBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.person_rounded,
        size: 20,
        color: AppColors.textSecondary,
      ),
    );
  }

  /// Short dummy description card
  Widget _buildDescriptionCard(CourseModel course) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'About This Course',
                style: AppTypography.subtitle2.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            course.description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
