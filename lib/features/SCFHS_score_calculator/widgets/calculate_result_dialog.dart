import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';

import '../../../core/theme/assets.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class CalculateResultDialog extends StatelessWidget {
  const CalculateResultDialog({super.key, required this.score});
final String score;
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.r), // Rounded corners
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.r), // Image respects corners
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.calculatorPopupBackground), // Your image path
              fit: BoxFit.cover, // Fit the image
            ),
          ),
          child: Padding(
            padding:  EdgeInsets.all(15.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Flexible height
              children: [
                GestureDetector(
                  onTap:(){
                    Navigator.pop(context);
                  },
                  child: Align(
                      alignment:Alignment.topRight,
                      child: Icon(CupertinoIcons.xmark_circle,color: AppColors.secondaryColor,size: 30.sp,)),
                ),
                60.verticalSpace,
                Text(
                  'your_score'.tr(context),
                  style: interMedium.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.secondaryColor, // Text color
                  ),
                ),
                25.verticalSpace,
                Text(
                  score,
                  style: interBold.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.secondaryColor, // Text color
                  ),
                ),
                50.verticalSpace,
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'more_info_calculate'.tr(context),style: interRegular.copyWith(fontSize: 14.sp)),
                        TextSpan(text: 'here'.tr(context),style: interRegular.copyWith(
                            color: AppColors.blueColor,fontSize: 14.sp
                        )),
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
