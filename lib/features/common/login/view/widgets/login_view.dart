// login_view.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_diary_mobile/features/common/login/view/widgets/login_school_dropdownmenu.dart';

import '../../../auth/auth.dart';
import '../../bloc/login_bloc.dart';
import 'login_appbar.dart';
import 'login_textfield.dart';
import 'login_password_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(FetchSchoolsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          final role = state.role;
          // Переход на страницу в зависимости от роли
          context.router.replacePath('/$role');
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: LoginAppBar(),
        ),
        body: SafeArea(
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, loginState) {
              if (loginState.errorMessage != null &&
                  loginState.errorMessage!.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loginState.errorMessage!)),
                );
              }
            },
            builder: (context, loginState) {
              if (loginState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Название приложения "Tilmidi" (шрифт Caveat Brush)
                    Text(
                      tr('login.title'),
                      style: GoogleFonts.caveatBrush(fontSize: 56),
                    ),

                    const SizedBox(height: 40),

                    LoginSchoolDropdownMenu(
                      schools: loginState.schools,
                      selectedSchoolName:
                          loginState
                              .selectedSchoolName, // какое имя выбрано сейчас
                      onSchoolNameChanged: (String? name) {
                        // отправляем в BLoC, например
                        context.read<LoginBloc>().add(
                          SchoolNameChangedEvent(name!),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Поле username
                    LoginTextField(
                      controller: _usernameController,
                      label: tr('login.username'),
                      icon: Icons.person,
                      onChanged:
                          (val) => context.read<LoginBloc>().add(
                            UsernameChangedEvent(val),
                          ),
                    ),

                    const SizedBox(height: 20),

                    // Поле password + иконка "глаз" справа
                    LoginPasswordField(
                      controller: _passwordController,
                      label: tr('login.password'),
                      obscureText: _obscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      onChanged:
                          (val) => context.read<LoginBloc>().add(
                            PasswordChangedEvent(val),
                          ),
                    ),

                    if (loginState.isLocked) ...[
                      const SizedBox(height: 16),
                      Text(
                        tr(
                          'login.locked',
                          namedArgs: {
                            'seconds': '${loginState.lockSecondsRemaining}',
                          },
                        ),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],

                    // Forgot password?
                    const SizedBox(height: 10),
                    Align(
                      alignment:
                          isRtl ? Alignment.centerLeft : Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          _showForgotPasswordDialog(context);
                        },
                        child: Text(
                          tr('login.forgot_password'),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Кнопка входа
                    if (!loginState.isLocked)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            context.read<LoginBloc>().add(SubmitLoginEvent());
                          },
                          child: Text(
                            tr('login.connect'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(tr('login.forgot_password_dialog_title')),
            content: Text(tr('login.forgot_password_dialog_message')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(tr('login.ok_button')),
              ),
            ],
          ),
    );
  }
}
