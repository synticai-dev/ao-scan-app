import 'package:flutter/material.dart';

class AppTextStyle {
  // Regular Text Styles
  static TextStyle regular({
    double fontSize = 14,
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? const Color(0xFF1a3a5f),
      fontWeight: fontWeight ?? FontWeight.normal,
      height: height,
      fontFamily: 'sans-serif',
    );
  }

  // Bold Text Styles
  static TextStyle bold({
    double fontSize = 14,
    Color? color,
    double? height,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? const Color(0xFF1a3a5f),
      fontWeight: fontWeight ?? FontWeight.bold,
      height: height,
      fontFamily: 'sans-serif',
    );
  }
}
