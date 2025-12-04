import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/text_styles.dart';

class TextRowWidget extends StatelessWidget {
  const TextRowWidget({
    super.key,
    required this.firstText,
    required this.secondText,
  });
  final String firstText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          firstText,
          style: AppTextStyle.style14W700.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
          ),
        ),
        Text(
          secondText,
          style: AppTextStyle.style14W700.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
          ),
        ),
      ],
    );
  }
}
