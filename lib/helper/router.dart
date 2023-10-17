import 'package:get/get.dart';
import 'package:time_tracker/views/categories_screen.dart';
import 'package:time_tracker/views/home_screen.dart';
import 'package:time_tracker/views/report_screen.dart';
import 'package:time_tracker/views/task_detail.dart';
// import 'package:time_tracker/views/splash_screen.dart';

class AppRouter {
  static const String initial = '/';
  static const String category = '/catogories';
  static const String taskDetail = '/task-detail';
  static const String timerec = '/time-rec';
  static const String report = '/report';

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => const HomeScreen(),
      transition: Transition.noTransition,
      children: [
        GetPage(
          name: taskDetail,
          page: () => const TaskDetailScreen(),
        )
      ],
    ),
    GetPage(
      name: category,
      transition: Transition.noTransition,
      page: () => const CategoriesScreen(),
    ),
    GetPage(
      name: report,
      transition: Transition.noTransition,
      page: () => const ReportScreen(),
    ),
  ];
}
