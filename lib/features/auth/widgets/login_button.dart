import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.thirdColor),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 52.h)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Platform.isAndroid ? Assets.googleIcon : Assets.appleIcon,
          ),
          16.horizontalSpace,
          Text(
            Platform.isAndroid ? 'Continue with google' : 'Continue with apple',
            style: AppTextStyle.style14W500.copyWith(
              color: AppColors.forthColor,
            ),
          ),
        ],
      ),
    );
  }
}
