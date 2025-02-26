import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // В initState можно диспатчить FetchSchoolsEvent
  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(FetchSchoolsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Кнопка "Смена языка" в AppBar или где-то сверху
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          // Вместо IconButton с языками сделаем PopupMenuButton или DropdownButton
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (langCode) {
              // При выборе «ar» или «fr» шлём событие в LoginBloc
              context.setLocale(Locale(langCode));
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'ar', child: Text('عربي')),
                  const PopupMenuItem(value: 'fr', child: Text('Français')),
                ],
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
            // Можно также слушать события успешного логина
            // и делать Navigator.pushReplacement(...)
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Текст "Tilmidi" по центру (можно ещё Spacer добавить)
                  const SizedBox(height: 20),
                  const Text(
                    'Tilmidi',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                child: Text(school.name!),
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
                      context.read<LoginBloc>().add(UsernameChangedEvent(val));
                    },
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),

                  const SizedBox(height: 16),

                  // Поле password
                  TextFormField(
                    controller: _passwordController,
                    onChanged: (val) {
                      context.read<LoginBloc>().add(PasswordChangedEvent(val));
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
                    // Кнопка Login
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
    );
  }
}
