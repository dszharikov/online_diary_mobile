// login_password_field.dart
import 'package:flutter/material.dart';

class LoginPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final ValueChanged<String> onChanged;

  const LoginPasswordField({
    Key? key,
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.onToggleVisibility,
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
        obscureText: obscureText,
        onChanged: onChanged,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.lock, color: colorScheme.onSurface),
          hintText: label,
          hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: colorScheme.onSurface,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }
}
