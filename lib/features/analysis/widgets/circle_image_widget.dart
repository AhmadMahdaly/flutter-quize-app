import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

import '../../../core/theme/assets.dart';

class CircleImageWidget extends StatelessWidget {
  const CircleImageWidget({super.key, required this.imagePath, required this.number});
final String imagePath,number;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center, // Ensures proper alignment
      children: [
        // Badge at the bottom of the Avatar
        Positioned(
          bottom: 20, // Adjusted positioning
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), // Padding for text
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkGreyColor, // Badge background color
            ),
            child: Text(
              number,
              style: interBold.copyWith(
                fontSize: number=='1'?26.sp:16.sp,
                color: AppColors.thirdColor,
              ),
            ),
          ),
        ),

        // Main Column with Avatar and Stars
        Column(
          mainAxisSize: MainAxisSize.min, // Ensures Column wraps content properly
          children: [
            // Circle Avatar with Border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.darkGreyColor, width: 2.r),
              ),
              child: CircleAvatar(
                radius: number=='1'?70.r:50.r, // Avatar size
                backgroundColor: Colors.transparent,
                backgroundImage:  NetworkImage(imagePath),
              ),
            ),
            Image.asset(
              Assets.stars,
              height: number=='1'?35.h:30.h,
            ),
          ],
        ),
      ],
    );
  }
}
