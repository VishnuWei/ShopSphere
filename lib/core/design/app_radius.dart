import 'package:flutter/material.dart';

abstract class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));

  static const RoundedRectangleBorder xsBorder =
      RoundedRectangleBorder(borderRadius: xsRadius);
  static const RoundedRectangleBorder smBorder =
      RoundedRectangleBorder(borderRadius: smRadius);
  static const RoundedRectangleBorder mdBorder =
      RoundedRectangleBorder(borderRadius: mdRadius);
  static const RoundedRectangleBorder lgBorder =
      RoundedRectangleBorder(borderRadius: lgRadius);
  static const RoundedRectangleBorder xlBorder =
      RoundedRectangleBorder(borderRadius: xlRadius);
}
