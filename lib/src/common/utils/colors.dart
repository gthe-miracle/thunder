import 'package:material_ui/material_ui.dart';

/// {@template app_colors}
/// Emphasis class
/// Logger colors for the application:
/// {@endtemplate}
@immutable
final class const ThunderColors({
  /// The white color of the thunder.
  required final Color cWhite,

  /// The black color of the thunder.
  required final Color cBlack,

  /// The yellow color of the thunder.
  required final Color cYellow,

  /// The red color of the thunder.
  required final Color cRed,

  /// The green color of the thunder.
  required final Color cGreen,

  /// The magenta color of the thunder.
  required final Color cMagenta,

  /// The blue color of the thunder.
  required final Color cBlue,

  /// The cyan color of the thunder.
  required final Color cCyan,

  /// The default color of the thunder.
  required final Color cDefault,

  /// The background color of the thunder.
  required final Color thunderBackground,

  /// The brilliant azure color.
  required final Color brilliantAzure,

  /// The gray color.
  required final Color gray,

  /// The elevated surface color (cards, buttons, handle, snackbar).
  required final Color surface,
}) extends ThemeExtension<ThunderColors> {
  /// {@macro app_colors}
  this;

  /// Gets the logger colors from the theme.
  factory of(BuildContext context) {
    try {
      final theme = Theme.of(context);

      return theme.extension<ThunderColors>() ??
          switch (theme.brightness) {
            Brightness.light => ThunderColors.light,
            Brightness.dark => ThunderColors.dark,
          };
    } on Object {
      return ThunderColors.light;
    }
  }

  /// The default light theme colors.
  static const light = ThunderColors(
    thunderBackground: Color(0xFFf2f2f2),
    cWhite: Color(0xFF555555),
    cBlack: Color(0xFF000000),
    cYellow: Color(0xFF787a01),
    cRed: Color(0xFFcd3131),
    cGreen: Color(0xFF0e7c10),
    cMagenta: Color(0xFFbc06bc),
    cBlue: Color(0xFF0000FF),
    cCyan: Color(0xFF00FFFF),
    cDefault: Color(0xFF000000),
    brilliantAzure: Color(0xFF3794ff),
    gray: Color(0xFF808080),
    surface: Color(0xFFffffff),
  );

  /// The default dark theme colors.
  static const dark = ThunderColors(
    thunderBackground: Color(0xFF181818),
    cWhite: Color(0xFFe5e5e5),
    cBlack: Color(0xFFd6d6d6),
    cYellow: Color(0xFFe5e50e),
    cRed: Color(0xFFd75959),
    cGreen: Color(0xFF0fbc7a),
    cMagenta: Color(0xFFc353c3),
    cBlue: Color(0xFF0000FF),
    cCyan: Color(0xFF00FFFF),
    cDefault: Color(0xFF000000),
    brilliantAzure: Color(0xFF3794ff),
    gray: Color(0xFF808080),
    surface: Color(0xFF262626),
  );

  @override
  ThunderColors copyWith({
    Color? thunderBackground,
    Color? cWhite,
    Color? cBlack,
    Color? cYellow,
    Color? cRed,
    Color? cGreen,
    Color? cMagenta,
    Color? cBlue,
    Color? cCyan,
    Color? cDefault,
    Color? brilliantAzure,
    Color? gray,
    Color? surface,
  }) => ThunderColors(
    // logViewer colors
    thunderBackground: thunderBackground ?? this.thunderBackground,
    cWhite: cWhite ?? this.cWhite,
    cBlack: cBlack ?? this.cBlack,
    cYellow: cYellow ?? this.cYellow,
    cRed: cRed ?? this.cRed,
    cGreen: cGreen ?? this.cGreen,
    cMagenta: cMagenta ?? this.cMagenta,
    cBlue: cBlue ?? this.cBlue,
    cCyan: cCyan ?? this.cCyan,
    cDefault: cDefault ?? this.cDefault,
    brilliantAzure: brilliantAzure ?? this.brilliantAzure,
    gray: gray ?? this.gray,
    surface: surface ?? this.surface,
  );

  @override
  ThemeExtension<ThunderColors> lerp(
    ThemeExtension<ThunderColors>? other,
    double t,
  ) => other is! ThunderColors
      ? this
      : ThunderColors(
          thunderBackground: Color.lerp(
            thunderBackground,
            other.thunderBackground,
            t,
          )!,
          cWhite: Color.lerp(cWhite, other.cWhite, t)!,
          cBlack: Color.lerp(cBlack, other.cBlack, t)!,
          cYellow: Color.lerp(cYellow, other.cYellow, t)!,
          cRed: Color.lerp(cRed, other.cRed, t)!,
          cGreen: Color.lerp(cGreen, other.cGreen, t)!,
          cMagenta: Color.lerp(cMagenta, other.cMagenta, t)!,
          cBlue: Color.lerp(cBlue, other.cBlue, t)!,
          cCyan: Color.lerp(cCyan, other.cCyan, t)!,
          cDefault: Color.lerp(cDefault, other.cDefault, t)!,
          brilliantAzure: Color.lerp(brilliantAzure, other.brilliantAzure, t)!,
          gray: Color.lerp(gray, other.gray, t)!,
          surface: Color.lerp(surface, other.surface, t)!,
        );

  @override
  String toString() => 'ThunderColors{}';
}
