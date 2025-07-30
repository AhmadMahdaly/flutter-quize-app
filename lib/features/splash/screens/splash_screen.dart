import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import '../../../core/cache_helper/cache_helper.dart';
import '../../../core/cache_helper/cache_values.dart';
import '../../../core/theme/assets.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';



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
  Future<bool>isLoggedIn()async{
    String? token= await  CacheHelper.getData(key:CacheKeys.userToken);
    debugPrintWidget(token);
    return token!=null?true:false;
  }
  Future<void> _route() async {
    if(await isLoggedIn()){
     context.pushReplacementNamed(Routes.mainLayoutScreen);
    }else{
      context.pushReplacementNamed(Routes.onBoardingScreen);
    }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Center(
        child: Image.asset(Assets.logoGif), // Add your GIF to assets.
      ),
    );
  }
}

