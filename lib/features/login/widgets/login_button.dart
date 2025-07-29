import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key,required this.onTap});
  final  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(AppColors.thirdColor),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStateProperty.all(const Size(double.infinity, 52)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset( Platform.isAndroid?Assets.googleIcon:Assets.appleIcon),
          20.horizontalSpace,
          Text(  Platform.isAndroid?'continue_google'.tr(context):'continue_apple'.tr(context), style: interRegular.copyWith(
            color: AppColors.forthColor,
            fontSize: 14.sp,
          )),
        ],
      ),
    );
  }
}
