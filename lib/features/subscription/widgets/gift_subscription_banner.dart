import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class GiftSubscriptionBanner extends StatelessWidget {
  const GiftSubscriptionBanner({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.iconColorBlack,
            AppColors.iconColorGray,
            AppColors.primaryDColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDColor.withAlpha(77),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.card_giftcard, color: Colors.white, size: 30.r),
          12.horizontalSpace,

          /// Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gift a Subscription 🎁',
                  style: AppTextStyle.style16Bold.copyWith(color: Colors.white),
                ),
                4.verticalSpace,
                Text(
                  'Subscribe & gift access to others',
                  style: AppTextStyle.style16Bold.copyWith(
                    color: Colors.white70,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),

          /// Button
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
            child: Text(
              'Gift',
              style: AppTextStyle.style16Bold.copyWith(
                color: AppColors.iconColorGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
