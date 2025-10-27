import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

final ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle.light,

    scrolledUnderElevation: 0,

    titleTextStyle: interRegular.copyWith(color: AppColors.primaryColor),

    iconTheme: IconThemeData(
      color: AppColors.primaryColor,
      size: SizeConfig.responsiveValue(phone: 20.sp, tablet: 40.sp),
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.primaryColor,
      size: SizeConfig.responsiveValue(phone: 20.sp, tablet: 40.sp),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.primaryColor,
    unselectedItemColor: AppColors.greyColor,
  ),
  scaffoldBackgroundColor: AppColors.thirdColor,
  primaryColor: AppColors.primaryColor,
  secondaryHeaderColor: AppColors.secondaryColor,
  colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
);
