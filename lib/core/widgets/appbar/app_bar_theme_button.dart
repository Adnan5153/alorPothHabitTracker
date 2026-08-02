import 'package:flutter/material.dart';

import 'app_bar_action_button.dart';

/// Cycles between light, dark, and system ThemeMode and surfaces the
/// current mode through a dynamic icon glyph.
class AppBarThemeButton extends StatelessWidget {
  const AppBarThemeButton({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final icon = switch (mode) {
      ThemeMode.light => Icons.light_mode_rounded,
      ThemeMode.dark => Icons.dark_mode_rounded,
      ThemeMode.system => Icons.brightness_auto_rounded,
    };
    return AppBarActionButton(
      icon: icon,
      tooltip: 'Toggle theme',
      onPressed: () {
        final next = switch (mode) {
          ThemeMode.light => ThemeMode.dark,
          ThemeMode.dark => ThemeMode.system,
          ThemeMode.system => ThemeMode.light,
        };
        onChanged(next);
      },
    );
  }
}
