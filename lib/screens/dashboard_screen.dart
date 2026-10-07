import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_typography.dart';
import '../data/models/course_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../widgets/common/empty_view.dart';
import '../widgets/common/error_view.dart';
import '../widgets/dashboard/course_card.dart';
import '../widgets/dashboard/dashboard_header.dart';
import 'course_details_screen.dart';
import 'login_screen.dart';

/// Screen 2 — Course Dashboard
/// Displays list of courses, handles Loading, Success, Empty, and API Failure states,
/// with offline caching.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().fetchCourses();
    });
  }

  void _navigateToDetails(BuildContext context, CourseModel course) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CourseDetailsScreen(
          course: course,
          onCourseUpdated: (updated) {
            context.read<DashboardViewModel>().updateCourse(updated);
          },
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final authVM = context.read<AuthViewModel>();

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xl,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 32,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Sign Out of LearnHub?',
              style: AppTypography.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'You can always sign back in using your email and password.',
              style: AppTypography.subtitle2.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, AppSpacing.buttonHeight),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.button
                          .copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize:
                          const Size(double.infinity, AppSpacing.buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                    ),
                    child: Text('Sign Out', style: AppTypography.button),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      await authVM.logout();
      if (mounted) {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardVM = context.watch<DashboardViewModel>();
    final authVM = context.watch<AuthViewModel>();
    final userName = authVM.currentUser?.name ?? 'Alex Johnson';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: AppSpacing.borderRadiusSm,
                image: const DecorationImage(
                  image: AssetImage('assets/icons/app_icon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(AppStrings.appName, style: AppTypography.h3),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: AppStrings.refreshTooltip,
            onPressed: () => dashboardVM.fetchCourses(forceRefresh: true),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => dashboardVM.fetchCourses(forceRefresh: true),
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard User Header & Stats
              DashboardHeader(
                userName: userName,
                totalCourses: dashboardVM.totalCoursesCount,
                averageProgress: dashboardVM.overallProgressAverage,
                onLogout: () => _handleLogout(context),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Section Title & Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.dashboardTitle,
                    style: AppTypography.h2,
                  ),
                  if (dashboardVM.isSuccess)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                      child: Text(
                        '${dashboardVM.courses.length} Available',
                        style: AppTypography.badge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // State Content (Loading / Error / Empty / Success)
              _buildStateContent(context, dashboardVM),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateContent(
    BuildContext context,
    DashboardViewModel dashboardVM,
  ) {
    // 1. Loading State
    if (dashboardVM.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        child: Column(
          children: List.generate(
            3,
            (index) => Container(
              height: 180,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // 2. Error State (API Failure)
    if (dashboardVM.isError) {
      return ErrorView(
        message: dashboardVM.errorMessage,
        onRetry: () => dashboardVM.fetchCourses(forceRefresh: true),
      );
    }

    // 3. Empty State
    if (dashboardVM.isEmpty || dashboardVM.courses.isEmpty) {
      return EmptyView(
        title: AppStrings.emptyStateTitle,
        subtitle: AppStrings.emptyStateSubtitle,
        actionLabel: 'Refresh Courses',
        onAction: () => dashboardVM.fetchCourses(forceRefresh: true),
      );
    }

    // 4. Success State (List of courses)
    return Column(
      children: dashboardVM.courses.map((course) {
        return CourseCard(
          course: course,
          onContinue: () => _navigateToDetails(context, course),
        );
      }).toList(),
    );
  }
}
