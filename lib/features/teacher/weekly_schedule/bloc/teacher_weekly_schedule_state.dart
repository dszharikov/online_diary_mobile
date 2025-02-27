part of 'teacher_weekly_schedule_bloc.dart';

class TeacherWeeklyScheduleState extends Equatable {
  final bool isLoading;
  final DateTime currentStartDate; // начало текущей недели (понедельник)
  final int selectedDayIndex; // 0..6
  final Map<int, List<LessonModel>> weeklyLessons;
  // Ключ: 0=Monday, 1=Tuesday, 2=Wednesday, ...
  // Значение: список уроков

  final String? errorMessage;
  final bool isUpdatingLesson;

  const TeacherWeeklyScheduleState({
    this.isLoading = false,
    required this.currentStartDate,
    this.selectedDayIndex = 0,
    this.weeklyLessons = const {},
    this.errorMessage,
    this.isUpdatingLesson = false,
  });

  TeacherWeeklyScheduleState copyWith({
    bool? isLoading,
    DateTime? currentStartDate,
    int? selectedDayIndex,
    Map<int, List<LessonModel>>? weeklyLessons,
    String? errorMessage,
    bool? isUpdatingLesson,
  }) {
    return TeacherWeeklyScheduleState(
      isLoading: isLoading ?? this.isLoading,
      currentStartDate: currentStartDate ?? this.currentStartDate,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      weeklyLessons: weeklyLessons ?? this.weeklyLessons,
      errorMessage: errorMessage,
      isUpdatingLesson: isUpdatingLesson ?? this.isUpdatingLesson,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    currentStartDate,
    selectedDayIndex,
    weeklyLessons,
    errorMessage,
    isUpdatingLesson,
  ];
}
