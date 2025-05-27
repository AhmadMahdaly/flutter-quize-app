import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class DrawerItemWidget extends StatelessWidget {
  final String iconAsset;
  final String title;
  final GestureTapCallback onTap;
  const DrawerItemWidget({super.key, required this.iconAsset, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return           ListTile(
      leading:  ImageIcon(AssetImage(iconAsset),color: AppColors.iconColorGray,),
      title:  Text(title,style: interBold.copyWith(color: AppColors.forthColor,fontSize: 14.sp),),
      onTap:onTap
    );

  }
}
