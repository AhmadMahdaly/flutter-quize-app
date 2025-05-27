import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';

import '../../../core/theme/text_styles.dart';

class ProfileButtonWidget extends StatelessWidget {
  const ProfileButtonWidget({super.key, required this.imagePath, required this.text, this.onPressed});
final String imagePath,text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return               Center(
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
          WidgetStateProperty.all(AppColors.secondaryColor),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStateProperty.all(
              const Size(double.infinity, 52)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        child: Row(
          children: [
            ImageIcon(AssetImage(
             imagePath),
              color: AppColors.greyColor,
              size: 30.sp,
            ),
            5.horizontalSpace,
            Text(
              text,
              style: interBold.copyWith(
                color: AppColors.greyColor,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
