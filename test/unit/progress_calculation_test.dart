import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/data/models/course_model.dart';
import 'package:learning_app/data/models/lesson_model.dart';

void main() {
  group('Course Progress Calculation Logic Tests', () {
    test('Calculates 0% progress when no lessons are completed', () {
      final course = CourseModel(
        id: 1,
        title: 'Python Programming',
        instructor: 'John Smith',
        progress: 0,
        lessons: 4,
        lessonList: const [
          LessonModel(id: '1', title: 'Intro', isCompleted: false),
          LessonModel(id: '2', title: 'Variables', isCompleted: false),
          LessonModel(id: '3', title: 'Functions', isCompleted: false),
          LessonModel(id: '4', title: 'OOP', isCompleted: false),
        ],
      );

      expect(course.calculatedProgress, equals(0));
      expect(course.completedLessonsCount, equals(0));
    });

    test('Calculates 50% progress when 2 out of 4 lessons are completed', () {
      final course = CourseModel(
        id: 1,
        title: 'Python Programming',
        instructor: 'John Smith',
        progress: 0,
        lessons: 4,
        lessonList: const [
          LessonModel(id: '1', title: 'Intro', isCompleted: true),
          LessonModel(id: '2', title: 'Variables', isCompleted: true),
          LessonModel(id: '3', title: 'Functions', isCompleted: false),
          LessonModel(id: '4', title: 'OOP', isCompleted: false),
        ],
      );

      expect(course.calculatedProgress, equals(50));
      expect(course.completedLessonsCount, equals(2));
    });

    test('Calculates 100% progress when all lessons are marked completed', () {
      final course = CourseModel(
        id: 1,
        title: 'Python Programming',
        instructor: 'John Smith',
        progress: 0,
        lessons: 3,
        lessonList: const [
          LessonModel(id: '1', title: 'Intro', isCompleted: true),
          LessonModel(id: '2', title: 'Variables', isCompleted: true),
          LessonModel(id: '3', title: 'Functions', isCompleted: true),
        ],
      );

      expect(course.calculatedProgress, equals(100));
      expect(course.completedLessonsCount, equals(3));
    });

    test('Correctly rounds decimal progress (e.g., 2/3 = 67%)', () {
      final course = CourseModel(
        id: 2,
        title: 'Generative AI',
        instructor: 'Sarah Williams',
        progress: 0,
        lessons: 3,
        lessonList: const [
          LessonModel(id: '1', title: 'Lesson 1', isCompleted: true),
          LessonModel(id: '2', title: 'Lesson 2', isCompleted: true),
          LessonModel(id: '3', title: 'Lesson 3', isCompleted: false),
        ],
      );

      expect(course.calculatedProgress, equals(67));
    });

    test('Falls back to static progress when lessonList is empty', () {
      const course = CourseModel(
        id: 3,
        title: 'Full Stack Development',
        instructor: 'David Brown',
        progress: 25,
        lessons: 28,
        lessonList: [],
      );

      expect(course.calculatedProgress, equals(25));
    });
  });
}
