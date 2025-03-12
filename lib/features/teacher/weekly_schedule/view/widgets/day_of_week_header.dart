// day_of_week_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/teacher_weekly_schedule_bloc.dart';

class DayOfWeekHeader extends StatelessWidget {
  final TeacherWeeklyScheduleState state;
  const DayOfWeekHeader({super.key, required this.state});

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

  // Пример: французские сокращения, либо адаптируйте
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
