import 'package:online_diary_mobile/features/teacher/weekly_schedule/data/models/lesson_model.dart';
import 'package:online_diary_mobile/features/teacher/weekly_schedule/data/models/weekly_schedule_response_model.dart';

abstract class TeacherWeeklyScheduleRepository {
  Future<WeeklyScheduleResponseModel> getWeeklySchedule(DateTime startDate);
  Future<bool> updateLesson({
    required int lessonId,
    required bool isActive,
    String? homework,
    String? description,
    String? theme,
  });
}
