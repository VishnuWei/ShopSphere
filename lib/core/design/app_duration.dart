abstract class AppDuration {
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  static const Duration pageTransition = normal;
  static const Duration cardHover = fast;
  static const Duration skeleton = verySlow;
}
