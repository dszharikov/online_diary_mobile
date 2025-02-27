import 'package:online_diary_mobile/features/teacher/weekly_schedule/data/models/lesson_model.dart';

class WeeklyScheduleResponseModel {
  final List<LessonModel> monday;
  final List<LessonModel> tuesday;
  final List<LessonModel> wednesday;
  final List<LessonModel> thursday;
  final List<LessonModel> friday;
  final List<LessonModel> saturday;
  final List<LessonModel> sunday;

  WeeklyScheduleResponseModel({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory WeeklyScheduleResponseModel.fromMap(Map<String, dynamic> map) {
    List<LessonModel> parseDayList(String key) {
      final dayList = map[key] as List<dynamic>? ?? [];
      return dayList
          .map((item) => LessonModel.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    return WeeklyScheduleResponseModel(
      monday: parseDayList('Monday'),
      tuesday: parseDayList('Tuesday'),
      wednesday: parseDayList('Wednesday'),
      thursday: parseDayList('Thursday'),
      friday: parseDayList('Friday'),
      saturday: parseDayList('Saturday'),
      sunday: parseDayList('Sunday'),
    );
  }
}
