import 'package:flutter/material.dart';
import '../data/models/course_model.dart';
import '../data/repositories/course_repository.dart';

/// ViewModel managing state for Screen 3 (Course Details).
/// Handles lesson status toggling, automatic dynamic progress recalculation, and offline caching.
class CourseDetailsViewModel extends ChangeNotifier {
  final CourseRepository repository;
  CourseModel _course;
  final ValueChanged<CourseModel>? onCourseUpdated;

  bool _isUpdating = false;

  CourseDetailsViewModel({
    required this.repository,
    required CourseModel initialCourse,
    this.onCourseUpdated,
  }) : _course = initialCourse;

  CourseModel get course => _course;
  bool get isUpdating => _isUpdating;

  int get currentProgress => _course.calculatedProgress;

  int get completedLessonsCount =>
      _course.lessonList.where((l) => l.isCompleted).length;

  int get totalLessonsCount => _course.lessonList.length;

  /// Toggles completion status for a lesson and recalculates course progress.
  Future<void> toggleLesson(String lessonId) async {
    _isUpdating = true;
    notifyListeners();

    try {
      final updated = await repository.toggleLessonCompletion(
        courseId: _course.id,
        lessonId: lessonId,
      );
      _course = updated;
      onCourseUpdated?.call(updated);
    } catch (e) {
      debugPrint('Error toggling lesson: $e');
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}
