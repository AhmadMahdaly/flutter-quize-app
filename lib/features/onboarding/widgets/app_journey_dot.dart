import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';

class CustomJourneyDot extends StatelessWidget {
  const CustomJourneyDot({
    super.key,
    required this.activeIndex,
    required this.count,
  });
  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 10.h,
              width: 12.w,
              decoration: BoxDecoration(
                color: activeIndex == index
                    ? AppColors.secondaryColor
                    : AppColors.primaryColor.withAlpha(77),
                borderRadius: BorderRadius.circular(15.w),
              ),
            ),
          );
        },
      ),
    );
  }
}
