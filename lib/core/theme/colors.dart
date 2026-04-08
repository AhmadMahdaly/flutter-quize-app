import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFFE6B9A6);
  static const primaryDColor = Color(0xFFD9B9A9);
  static const secondaryColor = Color(0xff2F3645);
  static const thirdColor = Color(0xffFFFFFF);
  static const forthColor = Color(0xff000000);
  static const successColor = Color(0xff7EBD35);
  static const greenColor = Color.fromARGB(255, 3, 168, 61);
  static const greenLightColor = Color.fromARGB(255, 115, 255, 164);
  static const errorLightColor = Color.fromARGB(255, 255, 90, 90);

  static const greyColor = Color(0xffEEEDEB);
  static const offwhiteColor = Color(0xffF1F4F5);
  static const darkGreyColor = Color(0xff939185);
  static const errorColor = Color(0xFFFF2727);
  static const iconColorBlack = Color(0xFF222222);
  static const iconColorGray = Color(0xFF33363F);
  static const blueColor = Color(0xFF3399FF);
}

final appGradientHelper = const RadialGradient(
  colors: [AppColors.primaryColor, AppColors.secondaryColor],
  center: Alignment.topLeft, // يبدأ التدرج من الزاوية العلوية اليسرى
  radius: 0.35, // نصف قطر كبير لدمج التدرج بشكل طبيعي
  stops: [0.0, 1.0], // كيفية توزيع الألوان
);
