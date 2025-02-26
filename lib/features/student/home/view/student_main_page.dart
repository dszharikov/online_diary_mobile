// student_main_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/auth/auth.dart';

class StudentMainPage extends StatelessWidget {
  const StudentMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome, Student!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutPressed());
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
