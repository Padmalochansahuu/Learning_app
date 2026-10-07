import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/datasources/local_storage_service.dart';
import 'package:learning_app/data/datasources/mock_course_api.dart';
import 'package:learning_app/data/repositories/course_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStorageService storageService;
  late MockCourseApi mockApi;
  late CourseRepository courseRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storageService = LocalStorageService(prefs);
    mockApi = MockCourseApi();
    courseRepository = CourseRepository(
      api: mockApi,
      storage: storageService,
    );
  });

  group('CourseRepository Unit Tests', () {
    test('Fetches courses online, saves to cache, and returns fresh data', () async {
      mockApi.isNetworkAvailable = true;

      final result = await courseRepository.getCourses();

      expect(result.courses.isNotEmpty, isTrue);
      expect(result.isFromCache, isFalse);
      expect(storageService.hasCachedCourses(), isTrue);
    });

    test('Falls back gracefully to cached courses when network is offline', () async {
      // 1. Initial online fetch to populate cache
      mockApi.isNetworkAvailable = true;
      await courseRepository.getCourses();

      // 2. Turn off network
      mockApi.isNetworkAvailable = false;

      // 3. Subsequent fetch should pull from cache without crashing
      final result = await courseRepository.getCourses();

      expect(result.isFromCache, isTrue);
      expect(result.courses.length, equals(3));
      expect(result.notice, contains('Offline mode'));
    });

    test('Toggling lesson completion updates lesson status and recalculates progress', () async {
      // Seed default courses
      mockApi.isNetworkAvailable = true;
      await courseRepository.getCourses();

      // Python Programming course (ID: 1) has lesson '1-3' ('Functions') as pending (false)
      final initialCourse = await courseRepository.getCourseById(1);
      final initialProgress = initialCourse!.calculatedProgress;

      // Toggle lesson '1-3' to completed
      final updatedCourse = await courseRepository.toggleLessonCompletion(
        courseId: 1,
        lessonId: '1-3',
      );

      final toggledLesson = updatedCourse.lessonList.firstWhere((l) => l.id == '1-3');
      expect(toggledLesson.isCompleted, isTrue);
      expect(updatedCourse.calculatedProgress, greaterThan(initialProgress));

      // Check that it's persisted in local storage
      final cachedCourse = await courseRepository.getCourseById(1);
      expect(cachedCourse!.calculatedProgress, equals(updatedCourse.calculatedProgress));
    });
  });
}
