// login_textfield.dart
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const LoginTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: colorScheme.onSurface),
          hintText: label,
          hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        ),
      ),
    );
  }
}
