import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_diary_mobile/features/teacher/weekly_schedule/data/models/lesson_model.dart';
import 'package:online_diary_mobile/features/teacher/weekly_schedule/repositories/teacher_weekly_schedule_repository.dart';

part 'teacher_weekly_schedule_event.dart';
part 'teacher_weekly_schedule_state.dart';

class TeacherWeeklyScheduleBloc
    extends Bloc<TeacherWeeklyScheduleEvent, TeacherWeeklyScheduleState> {
  final TeacherWeeklyScheduleRepository repository;

  TeacherWeeklyScheduleBloc({required this.repository})
    : super(
        TeacherWeeklyScheduleState(
          currentStartDate: _getMondayOfCurrentWeek(),
          selectedDayIndex: _dayIndexForToday(),
        ),
      ) {
    on<LoadWeeklyScheduleEvent>(_onLoadWeeklyScheduleEvent);
    on<SelectDayOfWeekEvent>(_onSelectDayOfWeekEvent);
    on<PreviousWeekEvent>(_onPreviousWeekEvent);
    on<NextWeekEvent>(_onNextWeekEvent);
    on<UpdateLessonActivityEvent>(_onUpdateLessonActivityEvent);
  }

  static DateTime _getMondayOfCurrentWeek() {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - 1)).toUtc();
  }

  static int _dayIndexForToday() {
    // weekday: monday=1 ... sunday=7
    final weekday = DateTime.now().weekday;
    return weekday - 1; // monday => 0
  }

  Future<void> _onLoadWeeklyScheduleEvent(
    LoadWeeklyScheduleEvent event,
    Emitter<TeacherWeeklyScheduleState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final resp = await repository.getWeeklySchedule(event.startDate);
      final mapped = <int, List<LessonModel>>{
        0: resp.monday,
        1: resp.tuesday,
        2: resp.wednesday,
        3: resp.thursday,
        4: resp.friday,
        5: resp.saturday,
        6: resp.sunday,
      };
      emit(
        state.copyWith(
          isLoading: false,
          currentStartDate: event.startDate,
          weeklyLessons: mapped,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onSelectDayOfWeekEvent(
    SelectDayOfWeekEvent event,
    Emitter<TeacherWeeklyScheduleState> emit,
  ) {
    emit(state.copyWith(selectedDayIndex: event.weekdayIndex));
  }

  Future<void> _onPreviousWeekEvent(
    PreviousWeekEvent event,
    Emitter<TeacherWeeklyScheduleState> emit,
  ) async {
    final newDate = state.currentStartDate.subtract(const Duration(days: 7));
    add(LoadWeeklyScheduleEvent(newDate));
  }

  Future<void> _onNextWeekEvent(
    NextWeekEvent event,
    Emitter<TeacherWeeklyScheduleState> emit,
  ) async {
    final newDate = state.currentStartDate.add(const Duration(days: 7));
    add(LoadWeeklyScheduleEvent(newDate));
  }

  Future<void> _onUpdateLessonActivityEvent(
    UpdateLessonActivityEvent event,
    Emitter<TeacherWeeklyScheduleState> emit,
  ) async {
    emit(state.copyWith(isUpdatingLesson: true));
    try {
      // Найдём lesson в currentDayList, чтобы получить нужные параметры
      // TODO: make either left or right (where left is an error)
      final currentDayLessons =
          state.weeklyLessons[state.selectedDayIndex] ?? [];
      final lesson = currentDayLessons.firstWhere(
        (l) => l.lessonId == event.lessonId,
      );

      final result = await repository.updateLesson(
        lessonId: lesson.lessonId,
        isActive: !lesson.isActive,
        homework: lesson.homework,
        description: lesson.description,
        theme: lesson.theme,
      );

      if (!result) {
        emit(state.copyWith(isUpdatingLesson: false));
        return;
      }

      final updatedLesson = lesson.copyWith(isActive: !lesson.isActive);

      final updatedList =
          currentDayLessons.map((l) {
            if (l.lessonId == event.lessonId) {
              return updatedLesson;
            }
            return l;
          }).toList();

      final newMap = Map<int, List<LessonModel>>.from(state.weeklyLessons);
      newMap[state.selectedDayIndex] = updatedList;

      emit(state.copyWith(isUpdatingLesson: false, weeklyLessons: newMap));
    } catch (e) {
      emit(state.copyWith(isUpdatingLesson: false, errorMessage: e.toString()));
    }
  }
}
