// splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../director/home/home.dart';
import '../../../student/home/home.dart';
import '../../../teacher/home/home.dart';
import '../../login/login.dart';
import '../auth.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Здесь можно ничего не делать, так как AuthBloc уже «сам» инициировал проверку.
    // Просто отображаем индикатор загрузки, пока не придёт AuthState -> Authenticated / Unauthenticated.
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        // Если не авторизован -> Переходим на LoginPage
        if (state is Authenticated) {
          // Смотрим на роль
          final role = state.role;

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/$role/home',
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Splash Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Loading.. Please wait", style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
