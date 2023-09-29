import 'package:get/get.dart';
import 'package:time_tracker/views/categories_screen.dart';
import 'package:time_tracker/views/home_screen.dart';
// import 'package:time_tracker/views/splash_screen.dart';

class AppRouter {
  static const String initial = '/';
  static const String category = '/catogories';
  static const String timerec = '/time-rec';

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: category,
      page: () => const CategoriesScreen(),
    ),
    GetPage(
      name: category,
      page: () => const CategoriesScreen(),
    ),
  ];
}
