import '../datasources/local_storage_service.dart';
import '../datasources/mock_course_api.dart';
import '../models/course_model.dart';

/// Result wrapper indicating data origin (network vs offline cache).
class CourseFetchResult {
  final List<CourseModel> courses;
  final bool isFromCache;
  final String? notice;

  const CourseFetchResult({
    required this.courses,
    required this.isFromCache,
    this.notice,
  });
}

/// Repository managing course catalog, lesson completion states, and offline caching.
class CourseRepository {
  final MockCourseApi api;
  final LocalStorageService storage;

  CourseRepository({
    required this.api,
    required this.storage,
  });

  /// Fetches courses with an offline-first caching strategy.
  /// 1. If online and API succeeds: updates local cache and returns fresh data.
  /// 2. If offline or API fails: falls back to local cache if available.
  /// 3. If API fails and no cache exists: rethrows error to trigger UI error state.
  Future<CourseFetchResult> getCourses({bool forceRefresh = false}) async {
    // 1. If not forcing refresh and network is disabled, return cache directly
    if (!api.isNetworkAvailable) {
      final cached = storage.getCachedCourses();
      if (cached != null && cached.isNotEmpty) {
        return CourseFetchResult(
          courses: cached,
          isFromCache: true,
          notice: 'Offline mode: Showing cached courses',
        );
      }
      throw Exception('Device is offline and no cached courses are available.');
    }

    try {
      // 2. Fetch fresh data from Mock API
      final remoteCourses = await api.fetchCourses();

      // If we already had cached local modifications (e.g. user toggled lessons),
      // preserve user lesson progress over defaults.
      final cached = storage.getCachedCourses();
      List<CourseModel> mergedCourses = [];

      if (cached != null && cached.isNotEmpty) {
        for (final remote in remoteCourses) {
          final existing = cached.firstWhere(
            (c) => c.id == remote.id,
            orElse: () => remote,
          );
          mergedCourses.add(existing);
        }
      } else {
        mergedCourses = remoteCourses;
      }

      // Persist to local cache
      await storage.saveCourses(mergedCourses);

      return CourseFetchResult(
        courses: mergedCourses,
        isFromCache: false,
      );
    } catch (e) {
      // 3. Fallback to cache on network/API failure
      final cached = storage.getCachedCourses();
      if (cached != null && cached.isNotEmpty) {
        return CourseFetchResult(
          courses: cached,
          isFromCache: true,
          notice: 'Network unavailable: Displaying cached courses',
        );
      }
      // No cache available, propagate exception
      rethrow;
    }
  }

  /// Retrieves a single course by ID from cache or default.
  Future<CourseModel?> getCourseById(int courseId) async {
    final cached = storage.getCachedCourses();
    if (cached != null) {
      final match = cached.where((c) => c.id == courseId);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  /// Toggles completion status of a lesson within a course and updates progress.
  /// Persists immediately to local storage.
  Future<CourseModel> toggleLessonCompletion({
    required int courseId,
    required String lessonId,
  }) async {
    final cachedCourses = storage.getCachedCourses() ?? MockCourseApi.defaultCourses;
    final courseIndex = cachedCourses.indexWhere((c) => c.id == courseId);

    if (courseIndex == -1) {
      throw Exception('Course with ID $courseId not found.');
    }

    final course = cachedCourses[courseIndex];
    final updatedLessons = course.lessonList.map((lesson) {
      if (lesson.id == lessonId) {
        return lesson.copyWith(isCompleted: !lesson.isCompleted);
      }
      return lesson;
    }).toList();

    // Recalculate dynamic progress percentage
    final completedCount = updatedLessons.where((l) => l.isCompleted).length;
    final totalCount = updatedLessons.length;
    final newProgress = totalCount == 0
        ? 0
        : ((completedCount / totalCount) * 100).round().clamp(0, 100);

    final updatedCourse = course.copyWith(
      lessonList: updatedLessons,
      progress: newProgress,
    );

    // Save back to local storage
    cachedCourses[courseIndex] = updatedCourse;
    await storage.saveCourses(cachedCourses);

    return updatedCourse;
  }

  /// Clears local courses cache (useful for testing empty state).
  Future<void> clearCache() async {
    await storage.saveCourses([]);
  }

  /// Resets courses back to default assignment state.
  Future<void> resetToDefaults() async {
    await storage.saveCourses(MockCourseApi.defaultCourses);
  }
}
