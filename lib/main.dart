import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:online_diary_mobile/features/common/auth/bloc/auth_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_diary_mobile/service_locator.dart';
import 'service_locator.dart' as di;

// Блоки / Темы
import 'features/common/settings/settings.dart';
import 'theme/material_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await di.setupLocator();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr'), Locale('ar')],
      path: "assets/translations",
      saveLocale: true,
      child: MultiBlocProvider(
        providers: [
          // Поднимаем SettingsBloc
          BlocProvider<SettingsBloc>(
            create: (context) => sl<SettingsBloc>()..add(SettingsStarted()),
          ),
          // Поднимаем AuthBloc
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
    // Получаем ссылку на наш кастомный класс темы
    final myMaterialTheme = MaterialTheme(ThemeData().textTheme);
    final ThemeData myLightTheme = myMaterialTheme.light();
    final ThemeData myDarkTheme = myMaterialTheme.dark();

    // Оборачиваем MaterialApp в BlocBuilder<SettingsBloc, SettingsState>,
    // чтобы при смене темы/локали происходил rebuild.
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return MaterialApp(
          title: 'Flutter Demo',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          theme: myLightTheme,
          darkTheme: myDarkTheme,

          // Если isDarkMode == true -> ThemeMode.dark, иначе ThemeMode.light
          themeMode:
              settingsState.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Пример экрана
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("title".tr())),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Пример: меняем локаль на арабский
                context.setLocale(const Locale("ar"));
              },
              child: const Text("Arabe"),
            ),
            ElevatedButton(
              onPressed: () {
                // Пример: меняем локаль на французский
                context.setLocale(const Locale("fr"));
              },
              child: const Text("Francais"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                // Пример: переключаем тёмную/светлую тему
                context.read<SettingsBloc>().add(SettingsThemeToggled());
              },
              child: const Text("Toggle Theme"),
            ),
          ],
        ),
      ),
    );
  }
}
