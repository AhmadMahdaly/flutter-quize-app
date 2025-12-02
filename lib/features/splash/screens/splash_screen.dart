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

    Future.delayed(const Duration(milliseconds: 4000), () {
      _route();
    });
  }

  Future<bool> isLoggedIn() async {
    final String? token = await CacheHelper.getData(key: CacheKeys.userToken);
    token?.dPrint();
    return token != null ? true : false;
  }

  Future<void> _route() async {
    // context.pushReplacementNamed(Routes.mainLayoutScreen);

    /// Without Onboard
    if (await isLoggedIn()) {
      context.pushReplacementNamed(Routes.mainLayoutScreen);
    } else {
      context.pushReplacementNamed(Routes.loginScreen);
    }

    /// With Onboard
    // final isOnboardingComplete =
    //     await CacheHelper.getData(key: firstTimeRun) as bool? ?? false;
    // if (await isLoggedIn()) {
    //   context.pushReplacementNamed(Routes.mainLayoutScreen);
    // } else {
    // if (!isOnboardingComplete) {
    //   context.pushReplacementNamed(Routes.onBoardingScreen);
    // } else {
    // context.pushReplacementNamed(Routes.loginScreen);
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
              duration: 1500,
              child: Text(
                textAlign: TextAlign.center,
                'SMLE Gate',
                style: interExtraBold.copyWith(
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
