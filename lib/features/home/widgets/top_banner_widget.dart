import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class TopBannerWidget extends StatelessWidget {
  const TopBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: AppColors.darkGreyColor,
        borderRadius: BorderRadius.all(Radius.circular(100.r)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(28.r),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - 175,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Over ',
                      style: interBold.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.thirdColor,
                      ),
                    ),
                    TextSpan(
                      text: '400 ',
                      style: interBold.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    TextSpan(
                      text: 'questions across all medical specialties',
                      style: interBold.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.thirdColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: -20,
            child: Image.asset(Assets.homeDoctor, height: 180.h),
          ),
        ],
      ),
    );
  }
}
