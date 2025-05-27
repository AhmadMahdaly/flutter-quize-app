import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/text_styles.dart';

class TextRowWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  const TextRowWidget({super.key, required this.firstText, required this.secondText});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(firstText,style: interMedium.copyWith(fontSize: 16.sp),),
        Text(secondText,style: interMedium.copyWith(fontSize: 16.sp),),
      ],
    );
  }
}
