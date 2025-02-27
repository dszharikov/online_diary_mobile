class LessonModel {
  final DateTime date;
  final String? homework;
  final String? description;
  final String room;
  final String? theme;
  final bool isActive;
  final String courseTitle;
  final int courseId;
  final String groupName;
  final int groupId;
  final int lessonId;

  LessonModel({
    required this.date,
    this.homework,
    this.description,
    required this.room,
    this.theme,
    required this.isActive,
    required this.courseTitle,
    required this.courseId,
    required this.groupName,
    required this.groupId,
    required this.lessonId,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      date: DateTime.parse(map['date'] as String),
      homework: map['homework'] as String?,
      description: map['description'] as String?,
      room: map['room'] as String,
      theme: map['theme'] as String?,
      isActive: map['is_active'] as bool,
      courseTitle: map['course_title'] as String,
      courseId: map['course_id'] as int,
      groupName: map['group_name'] as String,
      groupId: map['group_id'] as int,
      lessonId: map['lesson_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'homework': homework,
      'description': description,
      'room': room,
      'theme': theme,
      'is_active': isActive,
      'course_title': courseTitle,
      'course_id': courseId,
      'group_name': groupName,
      'group_id': groupId,
      'lesson_id': lessonId,
    };
  }

  LessonModel copyWith({
    DateTime? date,
    String? homework,
    String? description,
    String? room,
    String? theme,
    bool? isActive,
    String? courseTitle,
    int? courseId,
    String? groupName,
    int? groupId,
    int? lessonId,
  }) {
    return LessonModel(
      date: date ?? this.date,
      homework: homework ?? this.homework,
      description: description ?? this.description,
      room: room ?? this.room,
      theme: theme ?? this.theme,
      isActive: isActive ?? this.isActive,
      courseTitle: courseTitle ?? this.courseTitle,
      courseId: courseId ?? this.courseId,
      groupName: groupName ?? this.groupName,
      groupId: groupId ?? this.groupId,
      lessonId: lessonId ?? this.lessonId,
    );
  }
}
