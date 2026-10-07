import 'dart:async';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/user_model.dart';

/// ============================================================================
/// Mock Course API Datasource
/// ============================================================================
/// 
/// WHY THIS EXISTS:
/// The assignment specification requests a functioning client app with realistic
/// course dummy data without a live remote server provided.
///
/// HOW REAL API INTERACTION IS SIMULATED:
/// 1. Network Latency: Simulates real HTTP round-trip latency via [Future.delayed] (800-900ms).
/// 2. REST Endpoints Emulated:
///    - POST /api/v1/auth/login -> [login] (validates credentials, returns JWT user token)
///    - GET  /api/v1/courses    -> [fetchCourses] (returns JSON-serialized courses)
/// 3. Realistic Error Handling: Supports HTTP 500 server errors and offline network disconnection.
///
/// HOW TO CONNECT A REAL BACKEND IN PRODUCTION:
/// 1. Implement a class (e.g. `RemoteCourseApi`) that calls `http.get()` / `dio.get('https://api.learnhub.com/courses')`.
/// 2. In `lib/main.dart`, pass `RemoteCourseApi` into `CourseRepository(api: RemoteCourseApi())`.
/// 3. Neither the ViewModels nor the UI screens require ANY changes because
///    the Repository pattern encapsulates data sourcing!
/// ============================================================================
class MockCourseApi {
  // Simulate network toggle
  bool shouldSimulateFailure = false;
  bool isNetworkAvailable = true;

  /// Default courses adhering precisely to assignment specifications,
  /// enriched with high-resolution Unsplash banners, instructor avatars, and descriptions.
  static List<CourseModel> get defaultCourses => [
        CourseModel(
          id: 1,
          title: 'Python Programming',
          instructor: 'John Smith',
          category: 'Software Engineering',
          description:
              'Master Python fundamentals, OOP architecture, data structures, and algorithmic problem-solving with real-world projects.',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800&auto=format&fit=crop&q=80',
          instructorAvatarUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&crop=faces&q=80',
          progress: 65,
          lessons: 20,
          lessonList: [
            const LessonModel(
              id: '1-1',
              title: 'Introduction',
              isCompleted: true,
              durationMinutes: 10,
            ),
            const LessonModel(
              id: '1-2',
              title: 'Variables & Data Types',
              isCompleted: true,
              durationMinutes: 15,
            ),
            const LessonModel(
              id: '1-3',
              title: 'Functions',
              isCompleted: false,
              durationMinutes: 20,
            ),
            const LessonModel(
              id: '1-4',
              title: 'OOP',
              isCompleted: false,
              durationMinutes: 25,
            ),
            const LessonModel(
              id: '1-5',
              title: 'Data Structures & Collections',
              isCompleted: false,
              durationMinutes: 30,
            ),
            const LessonModel(
              id: '1-6',
              title: 'File I/O & Exception Handling',
              isCompleted: false,
              durationMinutes: 20,
            ),
          ],
        ),
        CourseModel(
          id: 2,
          title: 'Generative AI',
          instructor: 'Sarah Williams',
          category: 'Artificial Intelligence',
          description:
              'Explore Transformer foundations, prompt engineering, fine-tuning modern LLMs, and building production-grade RAG pipelines.',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&auto=format&fit=crop&q=80',
          instructorAvatarUrl:
              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&crop=faces&q=80',
          progress: 40,
          lessons: 16,
          lessonList: [
            const LessonModel(
              id: '2-1',
              title: 'Foundations of Neural Networks',
              isCompleted: true,
              durationMinutes: 15,
            ),
            const LessonModel(
              id: '2-2',
              title: 'Transformer Architecture & Attention',
              isCompleted: true,
              durationMinutes: 25,
            ),
            const LessonModel(
              id: '2-3',
              title: 'Prompt Engineering & Few-Shot Learning',
              isCompleted: false,
              durationMinutes: 20,
            ),
            const LessonModel(
              id: '2-4',
              title: 'Fine-Tuning Large Language Models',
              isCompleted: false,
              durationMinutes: 30,
            ),
            const LessonModel(
              id: '2-5',
              title: 'Vector Databases & RAG Pipelines',
              isCompleted: false,
              durationMinutes: 35,
            ),
          ],
        ),
        CourseModel(
          id: 3,
          title: 'Full Stack Development',
          instructor: 'David Brown',
          category: 'Web & Cloud Systems',
          description:
              'Design end-to-end full stack web platforms with modern frontend state management, REST APIs, databases, and automated cloud deployments.',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&auto=format&fit=crop&q=80',
          instructorAvatarUrl:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&crop=faces&q=80',
          progress: 25,
          lessons: 28,
          lessonList: [
            const LessonModel(
              id: '3-1',
              title: 'Modern Frontend Architecture',
              isCompleted: true,
              durationMinutes: 15,
            ),
            const LessonModel(
              id: '3-2',
              title: 'State Management & Performance',
              isCompleted: false,
              durationMinutes: 25,
            ),
            const LessonModel(
              id: '3-3',
              title: 'RESTful & GraphQL API Design',
              isCompleted: false,
              durationMinutes: 20,
            ),
            const LessonModel(
              id: '3-4',
              title: 'Database Modeling & Indexing',
              isCompleted: false,
              durationMinutes: 30,
            ),
            const LessonModel(
              id: '3-5',
              title: 'CI/CD & Cloud Deployment',
              isCompleted: false,
              durationMinutes: 35,
            ),
          ],
        ),
      ];

  /// Simulates authenticating a user.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (!isNetworkAvailable) {
      throw Exception('Network unreachable. Please check your connection.');
    }

    // Demo credentials or any valid non-empty login
    if (email.trim().toLowerCase() == 'student@learnhub.com' &&
        password == 'password123') {
      return const UserModel(
        id: 'usr_101',
        name: 'Alex Johnson',
        email: 'student@learnhub.com',
        token: 'mock_jwt_token_auth_learnhub_2026',
      );
    }

    // Allow standard login format
    if (email.contains('@') && password.length >= 6) {
      return UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first.capitalize(),
        email: email,
        token: 'mock_jwt_token_auth_learnhub_${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    throw Exception('Invalid email or password.');
  }

  /// Fetches courses from remote API mock.
  Future<List<CourseModel>> fetchCourses() async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!isNetworkAvailable) {
      throw Exception('No internet connection. Network request failed.');
    }

    if (shouldSimulateFailure) {
      throw Exception('HTTP 500: Internal server error while fetching courses.');
    }

    return defaultCourses;
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
