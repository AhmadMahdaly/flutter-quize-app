import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';

class SelectQuestionItem extends StatelessWidget {
  const SelectQuestionItem({
    required this.text,
    required this.color,
    super.key,
  });
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArrowClipper(),
      child: Container(
        width: 60.w,
        height: 30.h,
        color: color,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.thirdColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
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
