import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data/models/school.dart';

/// Виджет выбора школы с помощью Material 3 [DropdownMenu],
/// с включённым поиском (enableFilter = true).
///
/// При каждом вводе (каждой букве) вызываем [onSchoolNameChanged(_controller.text)].
/// При выборе пункта списка вызываем [onSchoolNameChanged(selected?.name)].
class LoginSchoolDropdownMenu extends StatefulWidget {
  final List<School> schools;
  final String? selectedSchoolName;
  final ValueChanged<String?> onSchoolNameChanged;

  const LoginSchoolDropdownMenu({
    super.key,
    required this.schools,
    required this.selectedSchoolName,
    required this.onSchoolNameChanged,
  });

  @override
  State<LoginSchoolDropdownMenu> createState() =>
      _LoginSchoolDropdownMenuState();
}

class _LoginSchoolDropdownMenuState extends State<LoginSchoolDropdownMenu> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Изначально устанавливаем текст контроллера:
    _controller.text = widget.selectedSchoolName ?? '';

    // Подписываемся на изменения в контроллере:
    // каждая буква => onSchoolNameChanged
    _controller.addListener(() {
      widget.onSchoolNameChanged(_controller.text);
    });
  }

  @override
  void didUpdateWidget(covariant LoginSchoolDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSchoolName != oldWidget.selectedSchoolName) {
      _controller.text = widget.selectedSchoolName ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Ищем School, у которого name == selectedSchoolName
    final School? initialSchool =
        widget.schools
                .where((s) => s.name == widget.selectedSchoolName)
                .isNotEmpty
            ? widget.schools.firstWhere(
              (s) => s.name == widget.selectedSchoolName,
            )
            : null;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: DropdownMenu<School>(
        controller: _controller,
        // начальное значение (объект) – если нужно в списке
        initialSelection: initialSchool,
        requestFocusOnTap: true,
        enableFilter: true,
        expandedInsets: EdgeInsets.zero,
        leadingIcon: Icon(Icons.school, color: colorScheme.onSurface),
        label: Text(
          tr('login.select_school'),
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        ),
        inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
        dropdownMenuEntries:
            widget.schools.map((school) {
              return DropdownMenuEntry<School>(
                value: school,
                label: school.name ?? tr('login.unknown_school'),
              );
            }).toList(),
        onSelected: (School? selected) {
          // При выборе пункта
          widget.onSchoolNameChanged(selected?.name);
        },
      ),
    );
  }
}
