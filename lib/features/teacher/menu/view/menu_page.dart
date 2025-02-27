import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_diary_mobile/features/common/auth/bloc/auth_bloc.dart';

@RoutePage()
class TeacherMenuPage extends StatelessWidget {
  const TeacherMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MenuPage'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('MenuPage is working', style: TextStyle(fontSize: 20)),
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
