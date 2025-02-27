import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_diary_mobile/service_locator.dart';
import '../bloc/teacher_weekly_schedule_bloc.dart';
import '../../../teacher/weekly_schedule/data/models/lesson_model.dart';

class TeacherWeeklySchedulePage extends StatelessWidget {
  const TeacherWeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherWeeklyScheduleBloc>(
      create: (context) {
        final bloc = // Берём из DI (get_it) или создаём вручную
            sl<TeacherWeeklyScheduleBloc>()..add(
              LoadWeeklyScheduleEvent(
                // начальная дата - понедельник текущей недели
                DateTime.now().subtract(
                  Duration(days: DateTime.now().weekday - 1),
                ),
              ),
            );
        return bloc;
      },
      child: const _TeacherWeeklyScheduleView(),
    );
  }
}

class _TeacherWeeklyScheduleView extends StatelessWidget {
  const _TeacherWeeklyScheduleView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('WeeklySchedule')),
      body: BlocBuilder<TeacherWeeklyScheduleBloc, TeacherWeeklyScheduleState>(
        builder: (context, state) {
          // верхний блок: переключатель дней недели (горизонтальный)
          final dayHeader = _DayOfWeekHeader(state: state);

          if (state.isLoading && state.weeklyLessons.isEmpty) {
            return Column(
              children: [
                dayHeader,
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }

          final lessons = state.weeklyLessons[state.selectedDayIndex] ?? [];

          return Column(
            children: [
              dayHeader,
              // Список уроков
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return _LessonCard(lesson: lesson);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Виджет для отображения горизонтального списка дней + стрелки
class _DayOfWeekHeader extends StatelessWidget {
  final TeacherWeeklyScheduleState state;
  const _DayOfWeekHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TeacherWeeklyScheduleBloc>();
    final colorScheme = Theme.of(context).colorScheme;

    final weekStart = state.currentStartDate;
    // Создадим список DateTime на 7 дней
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));

    return Container(
      color: colorScheme.surfaceVariant.withOpacity(0.2),
      height: 80,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () {
              bloc.add(PreviousWeekEvent());
            },
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = (index == state.selectedDayIndex);

                return GestureDetector(
                  onTap: () => bloc.add(SelectDayOfWeekEvent(index)),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? colorScheme.primaryContainer
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _weekdayString(day.weekday),
                          style: TextStyle(
                            color:
                                isSelected
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              bloc.add(NextWeekEvent());
            },
          ),
        ],
      ),
    );
  }

  String _weekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Lun';
      case 2:
        return 'Mar';
      case 3:
        return 'Mer';
      case 4:
        return 'Jeu';
      case 5:
        return 'Ven';
      case 6:
        return 'Sam';
      case 7:
        return 'Dim';
      default:
        return '';
    }
  }
}

/// Карточка урока (слайд / свайп для отмены)
class _LessonCard extends StatelessWidget {
  final LessonModel lesson;
  const _LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TeacherWeeklyScheduleBloc>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Свайп влево = показать иконку отмены
    return Dismissible(
      key: ValueKey(lesson.lessonId),
      direction: DismissDirection.endToStart, // left to right for ltr
      confirmDismiss: (dir) async {
        // Покажем диалог: "Вы уверены, что хотите отменить?"
        final result = await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Annuler ce cours?'),
                content: const Text('Voulez-vous vraiment annuler ce cours?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Non'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Oui'),
                  ),
                ],
              ),
        );
        if (result == true) {
          bloc.add(UpdateLessonActivityEvent(lessonId: lesson.lessonId));
        }
        return false; // Не удаляем из списка локально, пусть BLoC сам обновит
      },
      background: Container(
        color: colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: colorScheme.onErrorContainer),
      ),
      child: _buildLessonContent(context, lesson),
    );
  }

  Widget _buildLessonContent(BuildContext context, LessonModel lesson) {
    final isInactive = !lesson.isActive;
    final theme = Theme.of(context);
    final textColor =
        isInactive
            ? theme.colorScheme.onSurfaceVariant.withOpacity(0.6)
            : theme.colorScheme.onSurface;

    final textStyle = theme.textTheme.bodyMedium?.copyWith(color: textColor);

    // Зачеркнутый стиль, если is_active=false
    final textDecoration =
        isInactive ? TextDecoration.lineThrough : TextDecoration.none;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Время + Class:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(lesson.date),
                  style: textStyle?.copyWith(decoration: textDecoration),
                ),
                Text(
                  'Salle: ${lesson.room}',
                  style: textStyle?.copyWith(decoration: textDecoration),
                ),
                Text(
                  'Classe: ${lesson.groupName}',
                  style: textStyle?.copyWith(decoration: textDecoration),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${lesson.groupName}, ${lesson.courseTitle}',
              style: textStyle?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: textDecoration,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lesson.description ?? 'Aucun sujet de leçon',
              style: textStyle?.copyWith(decoration: textDecoration),
            ),
            if (lesson.homework != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  lesson.homework!,
                  style: textStyle?.copyWith(decoration: textDecoration),
                ),
              )
            else
              TextButton(
                onPressed:
                    isInactive
                        ? null
                        : () {
                          // TODO: Открыть диалог для добавления homework
                        },
                child: const Text('Ajouter un devoir'),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
