// teacher_weekly_schedule_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../service_locator.dart';
import '../bloc/teacher_weekly_schedule_bloc.dart';
import 'widgets/day_of_week_header.dart';
import 'widgets/lesson_slidable.dart';

@RoutePage()
class TeacherWeeklySchedulePage extends StatelessWidget {
  const TeacherWeeklySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherWeeklyScheduleBloc>(
      create: (context) {
        final bloc = sl<TeacherWeeklyScheduleBloc>();
        // Получим понедельник 00:00 текущей недели
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
      appBar: AppBar(title: Text(tr('teacherWeeklySchedule.title'))),
      body: BlocBuilder<TeacherWeeklyScheduleBloc, TeacherWeeklyScheduleState>(
        builder: (context, state) {
          if (state.isLoading && state.weeklyLessons.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final lessons = state.weeklyLessons[state.selectedDayIndex] ?? [];
          return Column(
            children: [
              DayOfWeekHeader(state: state),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return LessonSlidable(lesson: lesson);
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
