import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/auth.dart';
import '../bloc/login_bloc.dart';
// Импортируем SettingsBloc, если нужно (для смены темы).
import '../../settings/settings.dart';
// Импортируем get_it для sl<LoginBloc>()
import 'package:online_diary_mobile/service_locator.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      // Получаем блок из get_it
      create: (context) => sl<LoginBloc>(),
      // Важно: здесь не вызываем FetchSchoolsEvent сразу,
      // а сделаем это в initState дочернего виджета.
      child: const _LoginView(),
    );
  }
}

// Вспомогательный виджет со стейтфул-логикой
class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Здесь вызываем FetchSchoolsEvent
  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(FetchSchoolsEvent());
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('LoginPage: build()');

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Смотрим на роль
          final role = state.role;

          context.router.replacePath('/$role');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // Выбор языка из выпадающего меню
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              onSelected: (langCode) {
                // Меняем язык через EasyLocalization
                context.setLocale(Locale(langCode));
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(value: 'ar', child: Text('عربي')),
                    PopupMenuItem(value: 'fr', child: Text('Français')),
                  ],
            ),
            ElevatedButton(
              onPressed: () {
                // Пример: переключаем тёмную/светлую тему
                context.read<SettingsBloc>().add(SettingsThemeToggled());
              },
              child: const Text("Toggle Theme"),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.errorMessage != null &&
                  state.errorMessage!.isNotEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
              // Здесь же можно обрабатывать успешный логин и делать Navigator.pushReplacement(...)
            },
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Tilmidi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dropdown со списком школ
                    DropdownButtonFormField<String>(
                      value: state.selectedSchoolId,
                      items:
                          state.schools
                              .map(
                                (school) => DropdownMenuItem<String>(
                                  value: school.id,
                                  child: Text(school.name ?? 'Unknown'),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          context.read<LoginBloc>().add(
                            SchoolSelectedEvent(value),
                          );
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Select school',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Поле username
                    TextFormField(
                      controller: _usernameController,
                      onChanged: (val) {
                        context.read<LoginBloc>().add(
                          UsernameChangedEvent(val),
                        );
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 16),

                    // Поле password
                    TextFormField(
                      controller: _passwordController,
                      onChanged: (val) {
                        context.read<LoginBloc>().add(
                          PasswordChangedEvent(val),
                        );
                      },
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    const SizedBox(height: 20),

                    // Если заблокирован
                    if (state.isLocked) ...[
                      Text(
                        'Please wait ${state.lockSecondsRemaining} seconds before next attempt',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () {
                          context.read<LoginBloc>().add(SubmitLoginEvent());
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
