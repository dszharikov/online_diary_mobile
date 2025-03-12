// login_appbar.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginAppBar extends StatelessWidget {
  const LoginAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.language, color: colorScheme.onPrimary),
            onPressed: () => _showLanguageMenu(context),
          ),
        ),
      ],
    );
  }

  Future<void> _showLanguageMenu(BuildContext context) async {
    bool isRTL = context.locale.languageCode == 'ar';
    RelativeRect position;
    if (!isRTL) {
      position = RelativeRect.fromLTRB(1000, 50, 0, 16);
    } else {
      position = RelativeRect.fromLTRB(0, 50, 1000, 16);
    }

    final selected = await showMenu<String>(
      context: context,
      position: position,

      items: [
        PopupMenuItem(value: 'ar', child: const Text('عربي')),
        PopupMenuItem(value: 'fr', child: const Text('Français')),
      ],
    );
    if (selected != null) {
      context.setLocale(Locale(selected));
    }
  }
}
