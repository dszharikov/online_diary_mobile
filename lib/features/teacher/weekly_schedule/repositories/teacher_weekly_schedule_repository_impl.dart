import 'package:online_diary_mobile/features/teacher/weekly_schedule/data/models/lesson_model.dart';
import 'package:online_diary_mobile/features/teacher/weekly_schedule/data/models/weekly_schedule_response_model.dart';
import 'package:online_diary_mobile/features/teacher/weekly_schedule/data/sources/teacher_weekly_schedule_remote_data_source.dart';
import 'package:online_diary_mobile/features/teacher/weekly_schedule/repositories/teacher_weekly_schedule_repository.dart';

class TeacherWeeklyScheduleRepositoryImpl
    implements TeacherWeeklyScheduleRepository {
  final TeacherWeeklyScheduleRemoteDataSource remoteDataSource;

  TeacherWeeklyScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WeeklyScheduleResponseModel> getWeeklySchedule(DateTime startDate) {
    final response = remoteDataSource.getWeeklySchedule(startDate: startDate);
    return response;
  }

  @override
  Future<bool> updateLesson({
    required int lessonId,
    required bool isActive,
    String? homework,
    String? description,
    String? theme,
  }) async {
    return await remoteDataSource.updateLesson(
      lessonId: lessonId,
      isActive: isActive,
      homework: homework,
      description: description,
      theme: theme,
    );
  }
}
