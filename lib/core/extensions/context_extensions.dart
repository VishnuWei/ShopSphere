import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  MediaQueryData get _mediaQuery => MediaQuery.of(this);

  Size get screenSize => _mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get padding => _mediaQuery.padding;

  EdgeInsets get viewInsets => _mediaQuery.viewInsets;

  Orientation get orientation => _mediaQuery.orientation;

  bool get isPortrait => orientation == Orientation.portrait;

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isSmallPhone => screenWidth < 380;

  bool get isMobilePhone => screenWidth < 600;

  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  bool get isDesktop => screenWidth >= 900;

  bool get isWeb => screenWidth >= 1200;

  double get horizontalPadding => isMobilePhone ? 16.0 : 24.0;

  double get verticalPadding => isMobilePhone ? 12.0 : 16.0;

  Brightness get brightness => _mediaQuery.platformBrightness;

  bool get isDarkMode => brightness == Brightness.dark;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;
}
