import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/local_storage_service.dart';
import 'data/datasources/mock_course_api.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/course_repository.dart';
import 'screens/splash_screen.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/dashboard_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system overlay styling for clean status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize local persistence
  final storageService = await LocalStorageService.init();
  final mockApi = MockCourseApi();

  final authRepository = AuthRepository(
    api: mockApi,
    storage: storageService,
  );

  final courseRepository = CourseRepository(
    api: mockApi,
    storage: storageService,
  );

  runApp(
    LearningApp(
      authRepository: authRepository,
      courseRepository: courseRepository,
    ),
  );
}

class LearningApp extends StatelessWidget {
  final AuthRepository authRepository;
  final CourseRepository courseRepository;

  const LearningApp({
    super.key,
    required this.authRepository,
    required this.courseRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositories
        Provider<AuthRepository>.value(value: authRepository),
        Provider<CourseRepository>.value(value: courseRepository),

        // ViewModels
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(repository: authRepository),
        ),
        ChangeNotifierProvider<DashboardViewModel>(
          create: (_) => DashboardViewModel(repository: courseRepository),
        ),
      ],
      child: MaterialApp(
        title: 'LearnHub - Learning Dashboard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
