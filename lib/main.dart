import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:time_tracker/bloc/theme_bloc.dart';
import 'package:time_tracker/helper/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return BlocProvider(
          create: (context) => ThemeBloc(),
          child: BlocBuilder<ThemeBloc, ThemeData>(
            builder: (context, themeData) => MaterialApp.router(
              theme: themeData,
              darkTheme: ThemeData.dark(),
              title: 'Time Tracker',
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter.router,
            ),
          ),
        );
      },
    );
  }
}
