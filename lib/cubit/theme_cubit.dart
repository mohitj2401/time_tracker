import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<int> {
  ThemeCubit() : super(0);

  updateTheme(int themeNumber) {
    emit(themeNumber);
  }
}
