// lesson_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../bloc/teacher_weekly_schedule_bloc.dart';
import '../../data/models/lesson_model.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInactive = !lesson.isActive;
    final textDecoration =
        isInactive ? TextDecoration.lineThrough : TextDecoration.none;

    // Если theme пустая => "Aucun sujet de leçon"
    final themeText =
        (lesson.theme == null || lesson.theme!.trim().isEmpty)
            ? tr('teacherWeeklySchedule.noLessonTheme')
            : lesson.theme!;

    final isHomeworkEmpty =
        (lesson.homework == null || lesson.homework!.trim().isEmpty);

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
                  '${tr('teacherWeeklySchedule.room')}: ${lesson.room}',
                  style: TextStyle(decoration: textDecoration),
                ),
                Text(
                  '${tr('teacherWeeklySchedule.group')}: ${lesson.groupName}',
                  style: TextStyle(decoration: textDecoration),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              lesson.courseTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                decoration: textDecoration,
              ),
            ),
            const SizedBox(height: 4),
            Text(themeText, style: TextStyle(decoration: textDecoration)),
            if (!isHomeworkEmpty) ...[
              const SizedBox(height: 4),
              Text(
                lesson.homework!,
                style: TextStyle(decoration: textDecoration),
              ),
            ] else if (!isInactive) ...[
              const Divider(),
              Center(
                child: TextButton(
                  onPressed: () async {
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
                  child: Text(tr('teacherWeeklySchedule.addHomework')),
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
            title: Text(tr('teacherWeeklySchedule.dialogAddHomeworkTitle')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: homeworkCtrl,
                  decoration: InputDecoration(
                    labelText: tr('teacherWeeklySchedule.fieldHomework'),
                  ),
                ),
                TextField(
                  controller: descCtrl,
                  decoration: InputDecoration(
                    labelText: tr('teacherWeeklySchedule.fieldDescription'),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(tr('common.cancel')),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx, {
                    'homework': homeworkCtrl.text,
                    'description': descCtrl.text,
                  });
                },
                child: Text(tr('common.confirm')),
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
