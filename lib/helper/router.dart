import 'package:go_router/go_router.dart';
import 'package:time_tracker/models/tasks.dart';
import 'package:time_tracker/views/categories_screen.dart';
import 'package:time_tracker/views/home_screen.dart';
import 'package:time_tracker/views/report_screen.dart';
import 'package:time_tracker/views/task_detail.dart';
// import 'package:time_tracker/views/splash_screen.dart';

class AppRouter {
  static const String initial = '/';
  static const String category = '/catogories';
  static const String taskDetail = 'task-detail';
  static const String timerec = '/time-rec';
  static const String report = '/report';

  static GoRouter router = GoRouter(routes: [
    GoRoute(
      path: initial,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: taskDetail,
          builder: (context, state) =>
              TaskDetailScreen(task: state.extra as Tasks),
        )
      ],
    ),
    GoRoute(
      path: category,
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: report,
      builder: (context, state) => const ReportScreen(),
    ),
  ]);
}
