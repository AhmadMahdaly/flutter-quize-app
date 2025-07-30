import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';

class UpcomingItem extends StatelessWidget {
  const UpcomingItem({
    required this.text,
    required this.color,
    super.key,
    required this.isBookmarked,
  });
  final bool isBookmarked;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.responsiveValue(phone: 60.w, tablet: 50.w),
      height: SizeConfig.responsiveValue(phone: 30.h, tablet: 60.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.thirdColor,
            fontSize: SizeConfig.responsiveValue(phone: 18.sp, tablet: 22.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
