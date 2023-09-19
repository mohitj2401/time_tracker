/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Foodies Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2022-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:time_tracker/helper/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // DatabaseHelper databaseHelper = DatabaseHelper();
  // databaseHelper;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.find<MyCartController>().getCart();
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          theme: ThemeData.dark(useMaterial3: true),
          title: 'Your Time Tracker',
          // color: ThemeProvider.appColor,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          initialRoute: AppRouter.initial,
          getPages: AppRouter.routes,
          defaultTransition: Transition.native,
          // translations: LocaleString(),
          // locale: const Locale('en', 'US'),
        );
      },
    );
  }
}
