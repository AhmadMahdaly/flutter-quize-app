import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class UserImageNameWidget extends StatelessWidget {
  const UserImageNameWidget({super.key, required this.name, required this.email, required this.imagePath});
final String name,email,imagePath;
  @override
  Widget build(BuildContext context) {
    return             Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.darkGreyColor, width: 1.r),
          ),
          child: CircleAvatar(
            radius: 50.r, // Avatar size
            backgroundColor:AppColors.greyColor,
            child: Padding(
              padding:  EdgeInsets.only(top: 5.sp),
              child: Image(
                image: imagePath.isEmpty
                    ?  const AssetImage(Assets.user) // Use a valid asset path
                    : NetworkImage(imagePath) as ImageProvider,
              ),
            ),
          ),
        ),
        15.horizontalSpace,
        Column(
          children: [
            Text(name,style: interBold.copyWith(fontSize: 16.sp),),
            Text(email,style: interRegular.copyWith(fontSize: 14.sp,color: AppColors.darkGreyColor),),
          ],
        )
      ],
    );
  }
}
