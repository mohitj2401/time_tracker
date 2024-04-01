import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DarkThemeEvent extends ThemeEvent {}

class LightThemeEvent extends ThemeEvent {}

sealed class ThemeEvent {}

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(ThemeData.dark()) {
    on<DarkThemeEvent>(
        (event, emit) => emit(ThemeData.dark(useMaterial3: true)));
    on<LightThemeEvent>(
        (event, emit) => emit(ThemeData.light(useMaterial3: true)));
  }
}
