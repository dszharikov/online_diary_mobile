import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_diary_mobile/router/router.dart';

import 'package:online_diary_mobile/service_locator.dart' as di;
import 'package:online_diary_mobile/service_locator.dart';

// Тема
import 'package:online_diary_mobile/theme/material_theme.dart';

// Наши заглушки-страницы
import 'features/common/auth/auth.dart';
import 'features/common/login/login.dart';
import 'features/common/settings/settings.dart';
import 'features/director/home/home.dart';
import 'features/student/home/home.dart';
import 'features/teacher/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // 1. Инициализация зависимостей
  await di.setupLocator();

  // 2. Запускаем приложение с EasyLocalization + Bloc’ами
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr'), Locale('ar')],
      path: 'assets/translations',
      saveLocale: true,
      child: MultiBlocProvider(
        providers: [
          // SettingsBloc для темы
          BlocProvider<SettingsBloc>(
            create: (context) => sl<SettingsBloc>()..add(SettingsStarted()),
          ),
          // AuthBloc для управления авторизацией
          BlocProvider<AuthBloc>(
            create:
                (context) => sl<AuthBloc>()..add(AuthSubscriptionRequested()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Готовим Light/Dark темы
    final myMaterialTheme = MaterialTheme(ThemeData().textTheme);
    final ThemeData myLightTheme = myMaterialTheme.light();
    final ThemeData myDarkTheme = myMaterialTheme.dark();

    final _appRouter = AppRouter();

    // 3. Слушаем SettingsBloc, чтобы установить тему
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return MaterialApp.router(
          title: 'Online Diary',

          // 3.1 Настраиваем локализацию
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          routerConfig: _appRouter.config(),

          // 3.2 Темы
          theme: myLightTheme,
          darkTheme: myDarkTheme,
          themeMode:
              // TODO: make default as system
              settingsState.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // 4. Организуем навигацию:
          //    - Начальный экран: SplashPage
          //    - Затем в BlocListener<AuthBloc> (ниже) обрабатываем переходы
        );
      },
    );
  }
}
