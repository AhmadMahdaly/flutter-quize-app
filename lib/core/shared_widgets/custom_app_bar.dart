import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/text_styles.dart';
import '../../core/theme/colors.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
     this.title='',
    this.canBack= true,
    this.iconAction,
  });

  String title;
  bool canBack ;
  IconData? iconAction ;

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      elevation: 0,
      backgroundColor: AppColors.primaryColor,
      leading: canBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.iconColorBlack),
              onPressed: () => Navigator.of(context).pop(),
            )
          : const SizedBox(),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style:  interBold.copyWith(
          color: AppColors.secondaryColor,
          fontSize: 20.sp,
            decoration: TextDecoration.underline,
            decorationColor:  AppColors.secondaryColor,
            decorationStyle: TextDecorationStyle.solid,
        ),

      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(90.r),
          bottomLeft: Radius.circular(15.r),
        ),
      ),
      centerTitle: true,
      actions: [
        Icon(iconAction,color: AppColors.secondaryColor,size: 30.sp,),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
