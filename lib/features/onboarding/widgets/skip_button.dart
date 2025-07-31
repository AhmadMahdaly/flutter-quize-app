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
          context.pushReplacementNamed(Routes.loginScreen);
        },
        child: Align(
          alignment: Alignment.topRight,
          child: Text(
            'skip'.tr(context),
            style: interRegular.copyWith(
              color: AppColors.secondaryColor,
              fontSize: SizeConfig.responsiveValue(phone: 12.sp, tablet: 16.sp),
            ),
          ),
        ),
      ),
    );
  }
}
