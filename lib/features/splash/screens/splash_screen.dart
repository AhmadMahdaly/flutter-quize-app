import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smle/core/animation_helper/animation_do.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/functions/debug_print_extension.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2500), () {
      _route();
    });
  }

  Future<bool> isLoggedIn() async {
    final String? token = await CacheHelper.getData(key: CacheKeys.userToken);
    token?.dPrint();
    return token != null ? true : false;
  }

  Future<void> _route() async {
    // context.pushReplacementNamed(AppRoutes.mainLayoutScreen);

    /// Without Onboard
    if (await isLoggedIn()) {
      context.pushReplacementNamed(AppRoutes.mainLayoutScreen);
    } else {
      context.pushReplacementNamed(AppRoutes.loginScreen);
    }

    /// With Onboard
    // final isOnboardingComplete =
    //     await CacheHelper.getData(key: firstTimeRun) as bool? ?? false;
    // if (await isLoggedIn()) {
    //   context.pushReplacementNamed(AppRoutes.mainLayoutScreen);
    // } else {
    // if (!isOnboardingComplete) {
    //   context.pushReplacementNamed(AppRoutes.onBoardingScreen);
    // } else {
    // context.pushReplacementNamed(AppRoutes.loginScreen);
    // }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/png/logo-animation.gif'),
            CustomFadeInUp(
              duration: 1000,
              child: Text(
                textAlign: TextAlign.center,
                'SMLE Gate',
                style: AppTextStyle.style16Bold.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.offwhiteColor,
                  fontSize: SizeConfig.responsiveValue(
                    phone: 34.sp,
                    tablet: 36.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
