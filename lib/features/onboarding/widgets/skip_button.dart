import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: GestureDetector(
        onTap: () {
          context.pushReplacementNamed(AppRoutes.loginScreen);
        },
        child: Align(
          alignment: Alignment.topRight,
          child: Text(
            'skip'.tr(context),
            style: AppTextStyle.style12W500.copyWith(
              color: AppColors.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
