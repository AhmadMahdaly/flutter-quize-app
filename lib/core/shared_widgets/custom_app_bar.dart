import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.canBack = true,
    this.iconAction,
    this.leading,
  });

  final String title;
  final bool canBack;
  final Widget? iconAction;
  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // primary: false,
      // toolbarOpacity: 0,
      // bottomOpacity: 0,
      // foregroundColor: Colors.transparent,
      // elevation: 0,
      backgroundColor: AppColors.forthColor.withAlpha(70),
      leading: canBack
          ? IconButton(
              icon: Icon(
                size: SizeConfig.responsiveValue(phone: 16.r, tablet: 30.r),
                Icons.arrow_back_ios_new,
                color: AppColors.primaryColor,
              ),
              onPressed: () => context.pop(),
            )
          : leading,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: AppTextStyle.style20Bold.copyWith(
          color: AppColors.primaryColor,
          fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 24.sp),
        ),
      ),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     bottomRight: Radius.circular(16.r),
      //     bottomLeft: Radius.circular(16.r),
      //   ),
      // ),
      centerTitle: true,
      actions: [
        if (iconAction != null) ...[iconAction!, 12.horizontalSpace],
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(SizeConfig.responsiveValue(phone: 50.h, tablet: 50.h));
}
