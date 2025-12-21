import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class PayDoneDialog extends StatelessWidget {
  const PayDoneDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90.r), // Rounded corners
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90.r), // Image respects corners
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.calculatorPopupBackground,
              ), // Your image path
              fit: BoxFit.cover, // Fit the image
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(15.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Flexible height
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
                  'done'.tr(context),
                  style: AppTextStyle.style16Bold.copyWith(
                    fontSize: 24.sp,
                    color: AppColors.secondaryColor, // Text color
                  ),
                ),
                100.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
