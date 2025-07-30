import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class TopBannerWidget extends StatelessWidget {
  const TopBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: AppColors.darkGreyColor,
        borderRadius: BorderRadius.all(Radius.circular(100.r)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            child: SizedBox(
              width: SizeConfig.screenWidth / 2,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Over ',
                      style: interBold.copyWith(
                        fontSize: SizeConfig.responsiveValue(
                          phone: 15.sp,
                          tablet: 19.sp,
                        ),
                        color: AppColors.thirdColor,
                      ),
                    ),
                    TextSpan(
                      text: '400 ',
                      style: interBold.copyWith(
                        fontSize: SizeConfig.responsiveValue(
                          phone: 15.sp,
                          tablet: 19.sp,
                        ),
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    TextSpan(
                      text: 'questions across all medical specialties',
                      style: interBold.copyWith(
                        fontSize: SizeConfig.responsiveValue(
                          phone: 15.sp,
                          tablet: 19.sp,
                        ),
                        color: AppColors.thirdColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -5,
            right: -20,
            child: Image.asset(
              Assets.homeDoctor,
              height: SizeConfig.responsiveValue(phone: 180.h, tablet: 140.h),
            ),
          ),
        ],
      ),
    );
  }
}
