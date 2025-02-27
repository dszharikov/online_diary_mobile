import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // <-- импорт для Slidable
import 'package:online_diary_mobile/features/teacher/weekly_schedule/data/models/lesson_model.dart';

import '../bloc/teacher_weekly_schedule_bloc.dart';
import '../../../../service_locator.dart'; // например, для sl<...>()

class TeacherWeeklySchedulePage extends StatelessWidget {
  const TeacherWeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherWeeklyScheduleBloc>(
      create: (context) {
        final bloc = sl<TeacherWeeklyScheduleBloc>();
        // Получим «понедельник 00:00» текущей недели
        final now = DateTime.now();
        final monday = DateTime(
          now.year,
          now.month,
          now.day - (now.weekday - 1),
        );
        final mondayAtMidnight = DateTime(
          monday.year,
          monday.month,
          monday.day,
          0,
          0,
          0,
        );
        bloc.add(LoadWeeklyScheduleEvent(mondayAtMidnight));
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
    return Scaffold(
      appBar: AppBar(title: const Text('WeeklySchedule')),
      body: BlocBuilder<TeacherWeeklyScheduleBloc, TeacherWeeklyScheduleState>(
        builder: (context, state) {
          if (state.isLoading && state.weeklyLessons.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final lessons = state.weeklyLessons[state.selectedDayIndex] ?? [];
          return Column(
            children: [
              _DayOfWeekHeader(state: state),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return _LessonSlidable(lesson: lesson);
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

/// Горизонтальный список дней + стрелки (как в предыдущем примере)
class _DayOfWeekHeader extends StatelessWidget {
  final TeacherWeeklyScheduleState state;
  const _DayOfWeekHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TeacherWeeklyScheduleBloc>();

    final weekStart = state.currentStartDate;
    final days = List.generate(7, (i) => weekStart.add(Duration(days: i)));

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_weekdayString(day.weekday)),
                        Text('${day.day}'),
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
    }
    return '';
  }
}

/// Виджет Slidable (два действия: "Annuler/Restaurer" и "Modifier")
class _LessonSlidable extends StatelessWidget {
  final LessonModel lesson;
  const _LessonSlidable({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TeacherWeeklyScheduleBloc>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Определяем иконку / название / цвет для удаления или восстановления
    final isActive = lesson.isActive;
    final actionColor =
        isActive ? colorScheme.errorContainer : Colors.green[400];
    final icon = isActive ? Icons.delete : Icons.restore;
    final label = isActive ? 'Annuler' : 'Restaurer';

    return Slidable(
      key: ValueKey(lesson.lessonId),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) async {
              // Подтверждение
              final confirm = await showDialog<bool>(
                context: context,
                builder: (dialogCtx) {
                  return AlertDialog(
                    title: Text(
                      isActive ? 'Annuler ce cours?' : 'Rétablir ce cours?',
                    ),
                    content: Text(
                      isActive
                          ? 'Voulez-vous vraiment annuler ce cours?'
                          : 'Voulez-vous vraiment rétablir ce cours?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogCtx, false),
                        child: const Text('Non'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(dialogCtx, true),
                        child: const Text('Oui'),
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) {
                bloc.add(UpdateLessonActivityEvent(lessonId: lesson.lessonId));
              }
            },
            backgroundColor: actionColor!,
            foregroundColor: colorScheme.onErrorContainer,
            icon: icon,
            label: label,
          ),
          SlidableAction(
            onPressed: (ctx) async {
              // Открываем диалог для редактирования (theme, homework, description)
              final updated = await _showEditLessonDialog(context, lesson);
              if (updated != null) {
                // updated - это { 'theme':..., 'homework':..., 'description':... }
                bloc.add(
                  UpdateLessonInfoEvent(
                    lessonId: lesson.lessonId,
                    theme: updated['theme'],
                    homework: updated['homework'],
                    description: updated['description'],
                  ),
                );
              }
            },
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            icon: Icons.edit,
            label: 'Modifier',
          ),
        ],
      ),
      child: _LessonCard(lesson: lesson),
    );
  }

  /// Показываем диалог с 3 полями: theme, homework, description
  Future<Map<String, String>?> _showEditLessonDialog(
    BuildContext context,
    LessonModel lesson,
  ) async {
    final themeController = TextEditingController(text: lesson.theme ?? '');
    final homeworkController = TextEditingController(
      text: lesson.homework ?? '',
    );
    final descriptionController = TextEditingController(
      text: lesson.description ?? '',
    );

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Modifier le cours'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: themeController,
                  decoration: const InputDecoration(labelText: 'Thème'),
                ),
                TextField(
                  controller: homeworkController,
                  decoration: const InputDecoration(labelText: 'Devoir'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, {
                  'theme': themeController.text,
                  'homework': homeworkController.text,
                  'description': descriptionController.text,
                });
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
    return result;
  }
}

/// Собственно карточка урока с текстом, временем, homework и т.д.
class _LessonCard extends StatelessWidget {
  final LessonModel lesson;
  const _LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInactive = !lesson.isActive;
    final textDecoration =
        isInactive ? TextDecoration.lineThrough : TextDecoration.none;
    final themeText =
        (lesson.theme == null || lesson.theme!.trim().isEmpty)
            ? 'Aucun sujet de leçon'
            : lesson.theme!;
    final isHomeworkEmpty =
        (lesson.homework == null || lesson.homework!.trim().isEmpty);

    Text(themeText, style: TextStyle(decoration: textDecoration));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Время + класс/room
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(lesson.date),
                  style: TextStyle(decoration: textDecoration),
                ),
                Text(
                  'Salle: ${lesson.room}',
                  style: TextStyle(decoration: textDecoration),
                ),
                Text(
                  'Classe: ${lesson.groupName}',
                  style: TextStyle(decoration: textDecoration),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${lesson.courseTitle}',
              style: theme.textTheme.titleMedium?.copyWith(
                decoration: textDecoration,
              ),
            ),
            const SizedBox(height: 4),
            Text(themeText, style: TextStyle(decoration: textDecoration)),
            if (!isHomeworkEmpty) ...{
              const SizedBox(height: 4),
              Text(
                lesson.homework!,
                style: TextStyle(decoration: textDecoration),
              ),
            } else if (!isInactive) ...[
              const Divider(),
              // Кнопка "Ajouter un devoir"
              Center(
                child: TextButton(
                  onPressed: () async {
                    // Открываем диалог на 2 поля: homework, description
                    final updated = await _showHomeworkDialog(context);
                    if (updated != null) {
                      context.read<TeacherWeeklyScheduleBloc>().add(
                        UpdateLessonInfoEvent(
                          lessonId: lesson.lessonId,
                          homework: updated['homework'],
                          description: updated['description'],
                        ),
                      );
                    }
                  },
                  child: const Text('Ajouter un devoir'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<Map<String, String>?> _showHomeworkDialog(BuildContext context) async {
    final homeworkCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    return showDialog<Map<String, String>>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Ajouter un devoir'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: homeworkCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Devoir (homework)',
                  ),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx, {
                    'homework': homeworkCtrl.text,
                    'description': descCtrl.text,
                  });
                },
                child: const Text('Confirmer'),
              ),
            ],
          ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
