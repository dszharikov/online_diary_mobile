import 'package:online_diary_mobile/core/networking/networking.dart';
import 'package:online_diary_mobile/features/teacher/weekly_schedule/data/models/weekly_schedule_response_model.dart';
import 'package:online_diary_mobile/helpers/typedefs.dart';

abstract class TeacherWeeklyScheduleRemoteDataSource {
  /// Запрашивает расписание на неделю, начиная с startDate (YYYY-MM-DDTHH:mm:ss)
  Future<WeeklyScheduleResponseModel> getWeeklySchedule({
    required DateTime startDate,
  });

  /// Отменить или обновить урок (PATCH /update_lesson/{lesson_id})
  Future<bool> updateLesson({
    required int lessonId,
    required bool isActive,
    required String? homework,
    required String? description,
    required String? theme,
  });
}

// Пример заглушки (без реализации)
class TeacherWeeklyScheduleRemoteDataSourceImpl
    implements TeacherWeeklyScheduleRemoteDataSource {
  final ApiInterface api;

  TeacherWeeklyScheduleRemoteDataSourceImpl({required this.api});

  @override
  Future<WeeklyScheduleResponseModel> getWeeklySchedule({
    required DateTime startDate,
  }) {
    // TODO: remove
    print(startDate.toIso8601String());
    return api.getDocumentData<WeeklyScheduleResponseModel>(
      endpoint: ApiEndpoint.teacherSchedule(
        TeacherSchedule.GET_WEEKLY_SCHEDULE,
      ),
      queryParams: {'start_date': startDate.toIso8601String()},
      converter: WeeklyScheduleResponseModel.fromMap,
    );
  }

  @override
  Future<bool> updateLesson({
    required int lessonId,
    required bool? isActive,
    required String? homework,
    required String? description,
    required String? theme,
  }) async {
    // skip field if it is null
    final data = {
      if (isActive != null) 'is_active': isActive,
      if (homework != null) 'homework': homework,
      if (description != null) 'description': description,
      if (theme != null) 'theme': theme,
    };

    try {
      await api.updateData<JSON>(
        endpoint: ApiEndpoint.teacherLesson(
          TeacherLesson.UPDATE_LESSON,
          lessonId: lessonId,
        ),
        data: data,
        converter: (json) => json,
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
