// lesson_slidable.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/teacher_weekly_schedule_bloc.dart';
import '../../data/models/lesson_model.dart';
import 'lesson_card.dart';

class LessonSlidable extends StatelessWidget {
  final LessonModel lesson;
  const LessonSlidable({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TeacherWeeklyScheduleBloc>();
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = lesson.isActive;

    final actionColor = isActive ? colorScheme.errorContainer : Colors.green[400];
    final icon = isActive ? Icons.delete : Icons.restore;
    final label = isActive
        ? tr('teacherWeeklySchedule.actionCancel')
        : tr('teacherWeeklySchedule.actionRestore');

    return Slidable(
      key: ValueKey(lesson.lessonId),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  title: Text(isActive
                      ? tr('teacherWeeklySchedule.confirmCancelTitle')
                      : tr('teacherWeeklySchedule.confirmRestoreTitle')),
                  content: Text(isActive
                      ? tr('teacherWeeklySchedule.confirmCancelMessage')
                      : tr('teacherWeeklySchedule.confirmRestoreMessage')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx, false),
                      child: Text(tr('common.no')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx, true),
                      child: Text(tr('common.yes')),
                    ),
                  ],
                ),
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
              // диалог редактирования (3 поля: theme, homework, description)
              final updated = await _showEditLessonDialog(context, lesson);
              if (updated != null) {
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
            label: tr('teacherWeeklySchedule.actionEdit'),
          ),
        ],
      ),
      child: LessonCard(lesson: lesson),
    );
  }

  Future<Map<String, String>?> _showEditLessonDialog(
    BuildContext context,
    LessonModel lesson,
  ) async {
    final themeController = TextEditingController(text: lesson.theme ?? '');
    final homeworkController = TextEditingController(text: lesson.homework ?? '');
    final descriptionController = TextEditingController(text: lesson.description ?? '');

    return showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(tr('teacherWeeklySchedule.dialogEditTitle')),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: themeController,
                  decoration: InputDecoration(
                    labelText: tr('teacherWeeklySchedule.fieldTheme'),
                  ),
                ),
                TextField(
                  controller: homeworkController,
                  decoration: InputDecoration(
                    labelText: tr('teacherWeeklySchedule.fieldHomework'),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: tr('teacherWeeklySchedule.fieldDescription'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(tr('common.cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, {
                  'theme': themeController.text,
                  'homework': homeworkController.text,
                  'description': descriptionController.text,
                });
              },
              child: Text(tr('common.confirm')),
            ),
          ],
        );
      },
    );
  }
}
