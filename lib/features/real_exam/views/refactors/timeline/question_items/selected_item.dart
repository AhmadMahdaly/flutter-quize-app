import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';

class SelectedQuestionItem extends StatelessWidget {
  const SelectedQuestionItem({
    required this.number,
    required this.color,
    super.key,
  });
  final String number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // المستطيل الرئيسي
        Container(
          width: 60.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6.r),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(color: AppColors.thirdColor, fontSize: 16.sp),
          ),
        ),

        // المثلث في الزاوية العلوية اليسرى
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

// مثلث الزاوية اليسرى
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
