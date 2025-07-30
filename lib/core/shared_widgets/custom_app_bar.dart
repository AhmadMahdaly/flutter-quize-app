import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.canBack = true,
    this.iconAction,
  });

  final String title;
  final bool canBack;
  final IconData? iconAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: SizeConfig.responsiveValue(phone: 56.h, tablet: 100.h),
      elevation: 0,
      backgroundColor: AppColors.primaryColor,
      leading: canBack
          ? IconButton(
              icon: Icon(
                size: SizeConfig.responsiveValue(phone: 24.sp, tablet: 30.sp),
                Icons.arrow_back_ios_new,
                color: AppColors.iconColorBlack,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : const SizedBox(),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: interBold.copyWith(
          color: AppColors.secondaryColor,
          fontSize: SizeConfig.responsiveValue(phone: 20.sp, tablet: 24.sp),
          // decoration: TextDecoration.underline,
          // decorationColor: AppColors.secondaryColor,
          // decorationStyle: TextDecorationStyle.solid,
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
        Icon(
          iconAction,
          color: AppColors.secondaryColor,
          size: SizeConfig.responsiveValue(phone: 30.sp, tablet: 40.sp),
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(SizeConfig.responsiveValue(phone: 56.h, tablet: 100.h));
}
