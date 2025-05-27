import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class ExamsHistoryWidget extends StatelessWidget {
  const ExamsHistoryWidget({super.key, required this.text, this.onPressed});
final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return             Center(
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.secondaryColor),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStateProperty.all(const Size(double.infinity, 52)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        child: Text(text,
          style: interBold.copyWith(
            color: AppColors.thirdColor,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
