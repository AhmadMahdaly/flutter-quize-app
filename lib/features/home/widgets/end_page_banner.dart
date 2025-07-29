import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class EndPageBanner extends StatelessWidget {
  const EndPageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior:
          Clip.none, // Ensures the crown can extend beyond the container
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(100.r)),
          ),
          child: GestureDetector(
            onTap: () {
              context.pushNamed(Routes.subscriptionScreen);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 16.h),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${'now'.tr(context)}\n',
                      style: interBold.copyWith(fontSize: 16.sp),
                    ),
                    TextSpan(
                      text: "${'flashback_discount'.tr(context)}\n",
                      style: interMedium.copyWith(fontSize: 16.sp),
                    ),
                    TextSpan(
                      text: '             ${'discover_now'.tr(context)}',
                      style: interRegular.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -36.h, // Moves the image slightly above the container
          right: 0, // Aligns it to the right
          child: Image(
            image: const AssetImage(Assets.crownHome),
            width: 100.w, // Adjust width as needed
          ),
        ),
      ],
    );
  }
}
