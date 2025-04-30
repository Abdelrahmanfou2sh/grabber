import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/cubit/theme_cubit.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return IconButton(
          icon: Icon(
            state.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          tooltip:
              state.themeMode == ThemeMode.dark
                  ? 'تفعيل الوضع الفاتح'
                  : 'تفعيل الوضع المظلم',
        );
      },
    );
  }
}
