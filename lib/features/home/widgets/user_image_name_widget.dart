import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class UserImageNameWidget extends StatelessWidget {
  const UserImageNameWidget({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
    required this.points,
  });
  final String name, email, imagePath, points;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.darkGreyColor, width: 1.r),
          ),
          child: CircleAvatar(
            radius: SizeConfig.responsiveValue(phone: 40.r, tablet: 25.r),
            backgroundColor: AppColors.greyColor,
            child: Padding(
              padding: EdgeInsets.only(top: 5.sp),
              child: Image(
                image: imagePath.isEmpty
                    ? const AssetImage(Assets.user)
                    : NetworkImage(imagePath) as ImageProvider,
              ),
            ),
          ),
        ),
        15.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 4.w,
              children: [
                Text(
                  'welcome'.tr(context),
                  style: interBold.copyWith(
                    fontSize: SizeConfig.responsiveValue(
                      phone: 14.sp,
                      tablet: 18.sp,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 240.w,
                  child: Text(
                    name,
                    style: interBold.copyWith(
                      fontSize: SizeConfig.responsiveValue(
                        phone: 15.sp,
                        tablet: 19.sp,
                      ),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width - 140.w,
              child: Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: interRegular.copyWith(
                  fontSize: SizeConfig.responsiveValue(
                    phone: 14.sp,
                    tablet: 18.sp,
                  ),
                  color: AppColors.darkGreyColor,
                ),
              ),
            ),
            Text(
              '$points ${"points".tr(context)}',
              style: interBold.copyWith(
                fontSize: SizeConfig.responsiveValue(
                  phone: 16.sp,
                  tablet: 20.sp,
                ),
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
