import 'package:auto_route/auto_route.dart';
import 'package:online_diary_mobile/router/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: SplashRoute.page, path: '/'),
    AutoRoute(page: DirectorMainRoute.page, path: '/director'),
    AutoRoute(page: StudentMainRoute.page, path: '/student'),
    AutoRoute(
      page: TeacherMainRoute.page,
      path: '/teacher',
      children: [
        AutoRoute(page: TeacherExamsRoute.page, path: 'exams'),
        AutoRoute(page: TeacherGradesRoute.page, path: 'grades'),
        AutoRoute(
          page: TeacherPeriodScheduleRoute.page,
          path: 'period_schedule',
        ),
        AutoRoute(page: TeacherReportsRoute.page, path: 'reports'),
        AutoRoute(
          page: TeacherWeeklyScheduleRoute.page,
          path: 'weekly_schedule',
        ),
        AutoRoute(page: TeacherMenuRoute.page, path: 'menu'),
      ],
    ),
  ];
}
