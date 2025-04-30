import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system));

  void setThemeMode(ThemeMode mode) => emit(ThemeState(themeMode: mode));

  void toggleTheme() {
    final currentMode = state.themeMode;
    if (currentMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else if (currentMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState(
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.toString() == json['themeMode'] as String,
        orElse: () => ThemeMode.system,
      ),
    );
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'themeMode': state.themeMode.toString()};
  }
}
