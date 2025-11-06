import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/constants.dart';
import 'package:smle/core/functions/debug_print_extension.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 3460), () {
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

    final isOnboardingComplete =
        await CacheHelper.getData(key: firstTimeRun) as bool? ?? false;
    if (await isLoggedIn()) {
      context.pushReplacementNamed(Routes.mainLayoutScreen);
    } else {
      if (!isOnboardingComplete) {
        context.pushReplacementNamed(Routes.onBoardingScreen);
      } else {
        context.pushReplacementNamed(Routes.loginScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Center(child: Image.asset(Assets.logoGif)),
    );
  }
}
