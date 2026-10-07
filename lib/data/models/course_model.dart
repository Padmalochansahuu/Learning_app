import 'lesson_model.dart';

/// Model representing a course item in the Learning Dashboard.
class CourseModel {
  final int id;
  final String title;
  final String instructor;
  final int progress; // Stored progress % (0-100)
  final int lessons; // Total number of lessons
  final List<LessonModel> lessonList;
  final String thumbnailUrl;
  final String instructorAvatarUrl;
  final String description;
  final String category;

  const CourseModel({
    required this.id,
    required this.title,
    required this.instructor,
    required this.progress,
    required this.lessons,
    this.lessonList = const [],
    this.thumbnailUrl = '',
    this.instructorAvatarUrl = '',
    this.description = '',
    this.category = '',
  });

  /// Calculates dynamic progress percentage based on completed lessons.
  /// If lessonList is available, uses actual completed count; otherwise uses [progress].
  int get calculatedProgress {
    if (lessonList.isEmpty) return progress.clamp(0, 100);
    final completedCount = lessonList.where((l) => l.isCompleted).length;
    final total = lessonList.length;
    return total == 0 ? 0 : ((completedCount / total) * 100).round().clamp(0, 100);
  }

  /// Returns count of completed lessons.
  int get completedLessonsCount {
    if (lessonList.isNotEmpty) {
      return lessonList.where((l) => l.isCompleted).length;
    }
    return ((progress / 100) * lessons).round();
  }

  CourseModel copyWith({
    int? id,
    String? title,
    String? instructor,
    int? progress,
    int? lessons,
    List<LessonModel>? lessonList,
    String? thumbnailUrl,
    String? instructorAvatarUrl,
    String? description,
    String? category,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      progress: progress ?? this.progress,
      lessons: lessons ?? this.lessons,
      lessonList: lessonList ?? this.lessonList,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      instructorAvatarUrl: instructorAvatarUrl ?? this.instructorAvatarUrl,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'progress': progress,
      'lessons': lessons,
      'lessonList': lessonList.map((l) => l.toJson()).toList(),
      'thumbnailUrl': thumbnailUrl,
      'instructorAvatarUrl': instructorAvatarUrl,
      'description': description,
      'category': category,
    };
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    var rawList = json['lessonList'] as List<dynamic>?;
    List<LessonModel> lessonsParsed = [];
    if (rawList != null) {
      lessonsParsed = rawList
          .map((item) => LessonModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return CourseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      instructor: json['instructor'] as String? ?? '',
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      lessons: (json['lessons'] as num?)?.toInt() ?? 0,
      lessonList: lessonsParsed,
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      instructorAvatarUrl: json['instructorAvatarUrl'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}
