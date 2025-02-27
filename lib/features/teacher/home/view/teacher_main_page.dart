// teacher_main_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_diary_mobile/router/router.gr.dart';

import '../../../common/auth/auth.dart';

@RoutePage()
class TeacherMainPage extends StatelessWidget {
  const TeacherMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.router.replacePath('/login');
        }
      },
      child: AutoTabsRouter(
        // list of your tab routes
        // routes used here must be declared as children
        // routes of /dashboard
        routes: const [
          TeacherWeeklyScheduleRoute(),
          TeacherGradesRoute(),
          TeacherPeriodScheduleRoute(),
          TeacherMenuRoute(),
        ],
        transitionBuilder:
            (context, child, animation) => FadeTransition(
              opacity: animation,
              // the passed child is technically our animated selected-tab page
              child: child,
            ),
        builder: (context, child) {
          // obtain the scoped TabsRouter controller using context
          final tabsRouter = AutoTabsRouter.of(context);
          final colorScheme = Theme.of(context).colorScheme;
          // Here we're building our Scaffold inside of AutoTabsRouter
          // to access the tabsRouter controller provided in this context
          //
          // alternatively, you could use a global key
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: tabsRouter.activeIndex,
              onTap: (index) {
                // here we switch between tabs
                tabsRouter.setActiveIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  label: 'WeeklySchedule',
                  icon: Icon(Icons.calendar_today),
                ),
                BottomNavigationBarItem(
                  label: 'Grades',
                  icon: Icon(Icons.grade),
                ),
                BottomNavigationBarItem(
                  label: 'Period Schedule',
                  icon: Icon(Icons.schedule),
                ),
                BottomNavigationBarItem(label: 'Menu', icon: Icon(Icons.menu)),
              ],
            ),
          );
        },
      ),
    );
  }
}
