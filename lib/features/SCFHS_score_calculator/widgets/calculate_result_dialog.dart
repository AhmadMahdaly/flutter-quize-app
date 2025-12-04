import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class CalculateResultDialog extends StatelessWidget {
  const CalculateResultDialog({super.key, required this.score});
  final String score;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          SizeConfig.responsiveValue(phone: 40.r, tablet: 12.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          SizeConfig.responsiveValue(phone: 40.r, tablet: 12.r),
        ),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.calculatorPopupBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              SizeConfig.responsiveValue(phone: 15.r, tablet: 12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      CupertinoIcons.xmark_circle,
                      color: AppColors.secondaryColor,
                      size: 30.sp,
                    ),
                  ),
                ),
                60.verticalSpace,
                Text(
                  'your_score'.tr(context),
                  style: AppTextStyle.style14W700.copyWith(
                    fontSize: SizeConfig.responsiveValue(
                      phone: 16.sp,
                      tablet: 20.sp,
                    ),
                    color: AppColors.secondaryColor,
                  ),
                ),
                20.verticalSpace,
                Text(
                  score,
                  style: AppTextStyle.style16Bold.copyWith(
                    fontSize: SizeConfig.responsiveValue(
                      phone: 20.sp,
                      tablet: 24.sp,
                    ),
                    color: AppColors.secondaryColor,
                  ),
                ),
                50.verticalSpace,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'more_info_calculate'.tr(context),
                          style: AppTextStyle.style14W500.copyWith(
                            fontSize: SizeConfig.responsiveValue(
                              phone: 14.sp,
                              tablet: 18.sp,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: 'here'.tr(context),
                          style: AppTextStyle.style14W500.copyWith(
                            color: AppColors.blueColor,
                            fontSize: SizeConfig.responsiveValue(
                              phone: 14.sp,
                              tablet: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
