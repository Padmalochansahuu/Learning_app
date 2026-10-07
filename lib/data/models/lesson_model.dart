/// Model representing an individual lesson within a course.
class LessonModel {
  final String id;
  final String title;
  final bool isCompleted;
  final int durationMinutes;

  const LessonModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.durationMinutes = 15,
  });

  LessonModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    int? durationMinutes,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'durationMinutes': durationMinutes,
    };
  }

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 15,
    );
  }
}
