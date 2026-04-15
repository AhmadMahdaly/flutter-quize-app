import 'package:flutter/material.dart';
import 'package:smle/core/constants.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

final ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: true,
    scrolledUnderElevation: 0,
    titleTextStyle: AppTextStyle.style12W500.copyWith(
      color: AppColors.primaryColor,
    ),
    iconTheme: IconThemeData(
      color: AppColors.primaryColor,
      size: SizeConfig.responsiveValue(phone: 20.sp, tablet: 40.sp),
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.primaryColor,
      size: SizeConfig.responsiveValue(phone: 20.sp, tablet: 40.sp),
    ),
  ),
  scaffoldBackgroundColor: AppColors.secondaryColor,
  primaryColor: AppColors.secondaryColor,
  secondaryHeaderColor: AppColors.primaryColor,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryColor,
    secondary: AppColors.thirdColor,
    surface: AppColors.secondaryColor,
    onSurface: AppColors.offwhiteColor,
  ),
  cardTheme: CardThemeData(
    color: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: AppColors.primaryColor),
      borderRadius: BorderRadius.circular(15.r),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.iconColorGray,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    elevation: 5,
    titleTextStyle: AppTextStyle.style18Bold.copyWith(
      fontFamily: kPrimaryEnFont,
      color: AppColors.primaryColor,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondaryColor,
      foregroundColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      textStyle: AppTextStyle.style12W500.copyWith(fontFamily: kPrimaryEnFont),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: AppTextStyle.style14W500.copyWith(fontFamily: kPrimaryEnFont),
    ),
  ),
  useMaterial3: true,
  fontFamily: kPrimaryEnFont,
);

final ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    titleTextStyle: AppTextStyle.style12W500.copyWith(
      color: AppColors.secondaryColor,
    ),
    iconTheme: IconThemeData(
      color: AppColors.secondaryColor,
      size: SizeConfig.responsiveValue(phone: 20.sp, tablet: 40.sp),
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.secondaryColor,
      size: SizeConfig.responsiveValue(phone: 20.sp, tablet: 40.sp),
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.white,
  secondaryHeaderColor: AppColors.secondaryColor,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    surface: Colors.white,
    onSurface: AppColors.secondaryColor,
  ),
  cardTheme: CardThemeData(
    color: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: AppColors.primaryDColor),
      borderRadius: BorderRadius.circular(15.r),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    elevation: 5,
    titleTextStyle: AppTextStyle.style18Bold.copyWith(
      fontFamily: kPrimaryEnFont,
      color: AppColors.secondaryColor,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      textStyle: AppTextStyle.style12W500.copyWith(fontFamily: kPrimaryEnFont),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: AppTextStyle.style14W500.copyWith(fontFamily: kPrimaryEnFont),
    ),
  ),
  useMaterial3: true,
  fontFamily: kPrimaryEnFont,
);
