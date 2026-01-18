import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';

class ComplatedItem extends StatelessWidget {
  const ComplatedItem({
    required this.number,
    required this.color,
    super.key,
    required this.isFlaged,
  });
  final String number;
  final Color color;
  final bool isFlaged;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: SizeConfig.responsiveValue(phone: 60.w, tablet: 50.w),
          height: SizeConfig.responsiveValue(phone: 30.h, tablet: 60.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6.r),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: TextStyle(
                  color: AppColors.thirdColor,
                  fontSize: SizeConfig.responsiveValue(
                    phone: 14.sp,
                    tablet: 20.sp,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              isFlaged
                  ? Icon(
                      Icons.flag,
                      color: Colors.redAccent,
                      size: SizeConfig.responsiveValue(
                        phone: 18.h,
                        tablet: 20.h,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              width: 16.w,
              height: 16.h,
              color: AppColors.thirdColor,
            ),
          ),
        ),
      ],
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
