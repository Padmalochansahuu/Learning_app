/// Centralized strings and labels used throughout the application.
class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'LearnHub';
  static const String appTagline = 'Empower your future with guided learning';

  // Screen 1: Login
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Sign in to access your course dashboard';
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'e.g. student@learnhub.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String loginButton = 'Sign In';
  static const String loggingIn = 'Signing in...';
  static const String useDemoCredentials = 'Use Demo Account';
  static const String demoEmail = 'student@learnhub.com';
  static const String demoPassword = 'password123';

  // Validation
  static const String emailRequired = 'Email address is required';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String invalidCredentials = 'Invalid email or password. Please try again.';

  // Screen 2: Dashboard
  static const String dashboardTitle = 'My Courses';
  static const String dashboardSubtitle = 'Continue where you left off';
  static const String searchHint = 'Search courses...';
  static const String instructorPrefix = 'Instructor: ';
  static const String lessonsCountSuffix = ' lessons';
  static const String progressLabel = 'Progress';
  static const String continueButton = 'Continue';
  static const String refreshTooltip = 'Refresh courses';
  static const String offlineModeActive = 'Offline Mode Active';
  static const String cachedDataNotice = 'Showing cached course data';
  static const String emptyStateTitle = 'No Courses Found';
  static const String emptyStateSubtitle = 'You currently have no enrolled courses.';
  static const String errorStateTitle = 'Unable to Load Courses';
  static const String errorStateSubtitle = 'Something went wrong while fetching courses.';
  static const String retryButton = 'Try Again';

  // Screen 3: Details
  static const String courseDetailsTitle = 'Course Details';
  static const String curriculumTitle = 'Course Curriculum';
  static const String completed = 'Completed';
  static const String pending = 'Pending';
  static const String markCompleted = 'Mark Completed';
  static const String markPending = 'Mark Pending';
  static const String allLessonsCompleted = 'All lessons completed! Great job 🎉';
}
