import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class QBankProgressWidget extends StatelessWidget {
  const QBankProgressWidget({
    super.key,
    required this.currentValue,
    required this.endValue,
    required this.switchValue,
    this.switchFun,
  });
  final int currentValue, endValue;
  final bool switchValue;
  final ValueChanged<bool>? switchFun;
  @override
  Widget build(BuildContext context) {
    final double progressValue = (endValue == 0)
        ? 0.0
        : currentValue / endValue;

    return Container(
      color: AppColors.thirdColor,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: SizedBox(
                height: 40.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.r),
                      child: SizedBox(
                        height: 40.h,
                        child: LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: AppColors.greyColor,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Text(
                          '$currentValue/$endValue',
                          style: interBold.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          50.horizontalSpace,
          Icon(
            CupertinoIcons.book,
            color: AppColors.secondaryColor,
            size: SizeConfig.responsiveValue(phone: 20.sp, tablet: 40.sp),
          ),
          20.horizontalSpace,
          Transform.scale(
            scale: 1.2,
            child: CupertinoSwitch(
              value: switchValue,
              activeTrackColor: AppColors.primaryColor,
              onChanged: switchFun,
            ),
          ),
        ],
      ),
    );
  }
}
