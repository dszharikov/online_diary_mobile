// splash_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth.dart';

@RoutePage()
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

          context.router.replacePath('/$role');
        } else {
          context.router.replacePath('/login');
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
