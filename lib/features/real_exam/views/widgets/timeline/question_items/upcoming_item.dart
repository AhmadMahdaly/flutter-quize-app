import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';

class UpcomingItem extends StatelessWidget {
  const UpcomingItem({
    required this.text,
    required this.color,
    super.key,
    required this.isFlaged,
  });
  final bool isFlaged;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.responsiveValue(phone: 60.w, tablet: 50.w),
      height: SizeConfig.responsiveValue(phone: 40.h, tablet: 60.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: AppColors.thirdColor,
                fontSize: SizeConfig.responsiveValue(
                  phone: 14.sp,
                  tablet: 22.sp,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            isFlaged
                ? Icon(
                    Icons.flag,
                    color: Colors.redAccent,
                    size: SizeConfig.responsiveValue(phone: 18.h, tablet: 20.h),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
