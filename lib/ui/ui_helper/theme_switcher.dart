import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final switchIcon = themeProvider.isDarkMode;

    return IconButton(
      onPressed: () {
        themeProvider.toggleTheme();
      },
      icon: switchIcon ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode)
    );
  }
}
