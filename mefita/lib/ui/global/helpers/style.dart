import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

/*class AppColors{
  static MaterialColor primary = HexColor.generateMaterialColor('ffb902');
  static MaterialColor primaryLight = HexColor.generateMaterialColor('fece2a');
  static MaterialColor primaryLighter = HexColor.generateMaterialColor('fee283');
  static MaterialColor primaryLightest = HexColor.generateMaterialColor('fff9e1');
  static MaterialColor secondary = HexColor.generateMaterialColor('024aff');
  static MaterialColor secondaryLight = HexColor.generateMaterialColor('7285ff');
  static MaterialColor secondaryLighter = HexColor.generateMaterialColor('c7caff');
  static MaterialColor secondaryLightest = HexColor.generateMaterialColor('e9eaff');

  static MaterialColor black = HexColor.generateMaterialColor('17171F');
  static MaterialColor darker = HexColor.generateMaterialColor('373740');
  static MaterialColor dark = HexColor.generateMaterialColor('55555f');
  static MaterialColor grey = HexColor.generateMaterialColor('91909b');
  static MaterialColor light = HexColor.generateMaterialColor('d5d5e0');
  static MaterialColor lighter = HexColor.generateMaterialColor('e6e5f1');
  static MaterialColor extraLight = HexColor.generateMaterialColor('f0effb');
  static MaterialColor white = HexColor.generateMaterialColor('f5f5fa');

  static MaterialColor faintBlue = HexColor.generateMaterialColor('dbeafc');
}*/


ColorScheme flexSchemeLight = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff0062a1),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffd0e4ff),
  onPrimaryContainer: Color(0xff001d35),
  secondary: Color(0xff525f70),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffd6e4f7),
  onSecondaryContainer: Color(0xff0f1d2a),
  tertiary: Color(0xff6a5779),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xfff1daff),
  onTertiaryContainer: Color(0xff241432),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff410002),
  background: Color(0xfffdfcff),
  onBackground: Color(0xff1a1c1e),
  surface: Color(0xfffdfcff),
  onSurface: Color(0xff1a1c1e),
  surfaceVariant: Color(0xffdfe3eb),
  onSurfaceVariant: Color(0xff42474e),
  outline: Color(0xff73777f),
  outlineVariant: Color(0xffc2c7cf),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff2f3033),
  onInverseSurface: Color(0xfff1f0f4),
  inversePrimary: Color(0xff9ccaff),
  surfaceTint: Color(0xff0062a1),
);

ColorScheme flexSchemeDark = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff0062a1),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xff00497a),
  onPrimaryContainer: Color(0xffd0e4ff),
  secondary: Color(0xffbac8db),
  onSecondary: Color(0xff243140),
  secondaryContainer: Color(0xff3b4857),
  onSecondaryContainer: Color(0xffd6e4f7),
  tertiary: Color(0xffd5bee5),
  onTertiary: Color(0xff3a2948),
  tertiaryContainer: Color(0xff514060),
  onTertiaryContainer: Color(0xfff1daff),
  error: Color(0xffffb4ab),
  onError: Color(0xff690005),
  errorContainer: Color(0xff93000a),
  onErrorContainer: Color(0xffffb4ab),
  background: Color(0xff1a1c1e),
  onBackground: Color(0xffe2e2e6),
  surface: Color(0xff1a1c1e),
  onSurface: Color(0xffe2e2e6),
  surfaceVariant: Color(0xff42474e),
  onSurfaceVariant: Color(0xffc2c7cf),
  outline: Color(0xff8c9199),
  outlineVariant: Color(0xff42474e),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffe2e2e6),
  onInverseSurface: Color(0xff2f3033),
  inversePrimary: Color(0xff0062a1),
  surfaceTint: Color(0xff9ccaff),
);


class AppTheme {
  ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: flexSchemeLight,
    fontFamily: 'Poppins',
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
      fontFamily: 'Poppins',
    ),
  );
  ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: flexSchemeDark,
    fontFamily: 'Poppins',
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
      fontFamily: 'Poppins',
    ),
  );
}


class AppButtonProps{
  static double borderRadius = 40;
  // static double borderRadius = 17;
  static double buttonHeight = 70;
  // static double buttonHeight = 50;
}

class AppPadding{
  static double horizontal = 22;
  static double vertical = 22;
  static double inner = 15;
}

class AppBorderRadius{
  static double xs = 8;
  static double sm = 14;
  static double md = 18;
  static double lg = 30;
  static double xl = 40;
}

class AppTextStyles {
  static TextStyle sectionTitle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}