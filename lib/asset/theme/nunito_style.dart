import 'package:flutter/material.dart';

class NunitoStyle {
  NunitoStyle._();

  static TextStyle defaultStyle = TextStyle(
    fontFamily: "Nunito"
  );

  static TextStyle h1 = defaultStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );

  static TextStyle h2 = defaultStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );

  static TextStyle h3 = defaultStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5
  );

  static TextStyle h4 = defaultStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5
  );

  static TextStyle title = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5
  );

  static TextStyle title2 = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5
  );

  static TextStyle button1 = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5
  );

  static TextStyle button2 = defaultStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 1
  );

  static TextStyle body1 = defaultStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
  );

  static TextStyle body2 = defaultStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
  );

  static TextStyle caption1 = defaultStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 1
  );

  static TextStyle caption2 = defaultStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
  );
}