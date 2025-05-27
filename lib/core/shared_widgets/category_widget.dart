import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';

import '../theme/text_styles.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.categoryName, required this.imagePath, this.onTap});
final String categoryName,imagePath;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return                 GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        padding:
        EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(50.r))),
        child: Column(
          children: [
            ImageIcon(
               AssetImage(imagePath),
              color: AppColors.greyColor,
              size: 35.sp,
            ),
            FittedBox(
              child: Text(
                categoryName,
                style: interRegular.copyWith(
                    fontSize: 16.sp, color: AppColors.greyColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
