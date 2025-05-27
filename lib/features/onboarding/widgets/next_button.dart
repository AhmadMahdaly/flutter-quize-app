import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import '../../../core/routing/routes.dart';

class NextButton extends StatelessWidget {
  final  VoidCallback? onTap;
  const NextButton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(AppColors.secondaryColor),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStateProperty.all(const Size(150, 52)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          )),
      child: Text('next'.tr(context), style: interBold.copyWith(
        color: AppColors.thirdColor,
        fontSize: 16.sp,
      )),
    );
  }
}
