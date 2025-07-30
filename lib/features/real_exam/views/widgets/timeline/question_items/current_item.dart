import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';

class CurrentItem extends StatelessWidget {
  const CurrentItem({
    required this.text,
    required this.color,
    super.key,
    required this.isBookmarked,
  });
  final bool isBookmarked;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArrowClipper(),
      child: Container(
        width: SizeConfig.responsiveValue(phone: 60.w, tablet: 50.w),
        height: SizeConfig.responsiveValue(phone: 30.h, tablet: 60.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: color,
        ),

        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: AppColors.thirdColor,
                fontSize: SizeConfig.responsiveValue(
                  phone: 16.sp,
                  tablet: 20.sp,
                ),
              ),
            ),
            isBookmarked
                ? const Icon(Icons.flag, color: Colors.white)
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0) // top left
      ..lineTo(size.width * 0.5, 0) // move right
      ..lineTo(size.width, size.height / 2) // arrow tip
      ..lineTo(size.width * 0.5, size.height) // bottom right
      ..lineTo(0, size.height) // bottom left
      ..close(); // back to start
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
