import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            final role = state.role;
            if (role == 'student') {
              Navigator.pushReplacementNamed(context, '/student');
            } else if (role == 'teacher') {
              Navigator.pushReplacementNamed(context, '/teacher');
            } else if (role == 'director') {
              Navigator.pushReplacementNamed(context, '/director');
            } else {
              // неведомая роль — отправим на логин
              Navigator.pushReplacementNamed(context, '/login');
            }
          } else if (state is Unauthenticated) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
