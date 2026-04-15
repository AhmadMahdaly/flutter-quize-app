import 'package:flutter/material.dart';
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
    final color = Theme.of(context).colorScheme.onSurface.withAlpha(185);
    return ListTile(
      leading: Icon(imagePath, color: color),

      title: Text(
        text,
        style: AppTextStyle.style14Bold.copyWith(
          color: color,
        ),
      ),
      onTap: onPressed,
    );
  }
}
