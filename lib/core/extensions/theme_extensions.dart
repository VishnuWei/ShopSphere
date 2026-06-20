import 'package:flutter/material.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);

  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);

  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);

  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);

  TextStyle withColor(Color color) => copyWith(color: color);
}

extension BorderRadiusExtension on BorderRadius {
  RoundedRectangleBorder get asRounded =>
      RoundedRectangleBorder(borderRadius: this);
}
