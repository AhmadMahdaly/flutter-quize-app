import 'package:flutter/material.dart';
import 'package:smle/core/constants.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

final ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: true,
    // backgroundColor: Colors.white,

    // systemOverlayStyle: SystemUiOverlayStyle.light,
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
  // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
  //   backgroundColor: Colors.white,
  //   selectedItemColor: AppColors.primaryColor,
  //   unselectedItemColor: AppColors.greyColor,
  // ),
  scaffoldBackgroundColor: AppColors.secondaryColor,
  primaryColor: AppColors.secondaryColor,
  secondaryHeaderColor: AppColors.primaryColor,
  colorScheme: const ColorScheme.dark(primary: AppColors.secondaryColor),
  cardTheme: CardThemeData(
    color: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: AppColors.secondaryColor),
      borderRadius: BorderRadius.circular(15.r),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,

  /// Dialog theme
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.iconColorGray,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    elevation: 5,
    titleTextStyle: AppTextStyle.style18Bold.copyWith(
      fontFamily: kPrimaryEnFont,
      color: AppColors.primaryColor,
    ),
  ),

  /// ستايل الزر الرئيسي (ElevatedButton)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondaryColor,
      foregroundColor: AppColors.primaryColor, // لون النص والأيقونة
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      textStyle: AppTextStyle.style12W500.copyWith(fontFamily: kPrimaryEnFont),
    ),
  ),

  /// ستايل الزر الثانوي (TextButton)
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
