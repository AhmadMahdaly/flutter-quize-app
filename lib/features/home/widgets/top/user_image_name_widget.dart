import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
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
          clipBehavior: Clip.hardEdge,
          child: CircleAvatar(
            radius: SizeConfig.responsiveValue(phone: 24.r, tablet: 20.r),
            backgroundColor: AppColors.greyColor,
            child: Image(
              image: imagePath.contains('png')
                  ? AssetImage(imagePath)
                  : imagePath.isEmpty
                  ? const AssetImage(Assets.user)
                  : NetworkImage(imagePath) as ImageProvider,
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
                  'Welcome',
                  style: AppTextStyle.style14Bold.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 240.w,
                  child: Text(
                    name,
                    style: AppTextStyle.style16Bold.copyWith(
                      // color: AppColors.darkGreyColor,
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
                style: AppTextStyle.style12W500.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  '$points ',
                  style: AppTextStyle.style14Bold.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  'Points',
                  style: AppTextStyle.style12Bold.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
