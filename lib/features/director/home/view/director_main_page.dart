// director_main_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/auth/auth.dart';

@RoutePage()
class DirectorMainPage extends StatelessWidget {
  const DirectorMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.router.replacePath('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Director Dashboard')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Welcome, Director!'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Вызываем logout
                  context.read<AuthBloc>().add(AuthLogoutPressed());
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
