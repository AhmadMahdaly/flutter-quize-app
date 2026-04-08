import 'package:flutter/material.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class DrawerItemWidget extends StatelessWidget {
  const DrawerItemWidget({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onPressed,
  });
  final IconData imagePath;
  final String text;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(imagePath, color: AppColors.greyColor.withAlpha(150)),

      title: Text(
        text,
        style: AppTextStyle.style14Bold.copyWith(
          color: AppColors.greyColor.withAlpha(150),
        ),
      ),
      onTap: onPressed,
    );
  }
}
