part of 'teacher_weekly_schedule_bloc.dart';

abstract class TeacherWeeklyScheduleEvent extends Equatable {
  const TeacherWeeklyScheduleEvent();

  @override
  List<Object?> get props => [];
}

/// Загрузка расписания на неделю
class LoadWeeklyScheduleEvent extends TeacherWeeklyScheduleEvent {
  final DateTime startDate; // дата, с которой начинается неделя (понедельник)
  const LoadWeeklyScheduleEvent(this.startDate);

  @override
  List<Object?> get props => [startDate];
}

/// Пользователь переключил день недели (пн, вт, ср ...)
class SelectDayOfWeekEvent extends TeacherWeeklyScheduleEvent {
  final int weekdayIndex; // 0=Monday, 1=Tuesday, ...
  const SelectDayOfWeekEvent(this.weekdayIndex);

  @override
  List<Object?> get props => [weekdayIndex];
}

/// Перейти на предыдущую неделю (startDate - 7 дней)
class PreviousWeekEvent extends TeacherWeeklyScheduleEvent {}

/// Перейти на следующую неделю (startDate + 7 дней)
class NextWeekEvent extends TeacherWeeklyScheduleEvent {}

/// Обновление/отмена урока (PATCH)
class UpdateLessonActivityEvent extends TeacherWeeklyScheduleEvent {
  final int lessonId; // если false => "отменить урок"
  const UpdateLessonActivityEvent({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}

/// Изменение информации (homework, description, theme, etc.)
class UpdateLessonInfoEvent extends TeacherWeeklyScheduleEvent {
  final int lessonId;
  final String? theme;
  final String? homework;
  final String? description;

  const UpdateLessonInfoEvent({
    required this.lessonId,
    this.theme,
    this.homework,
    this.description,
  });
}
