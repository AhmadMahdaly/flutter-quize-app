import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class BreakTimeDialog extends StatelessWidget {
  const BreakTimeDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        6.verticalSpace,

        Text(
          textAlign: TextAlign.center,
          'Break Time',
          style: interBold.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 22.sp, tablet: 26.sp),
            color: AppColors.iconColorGray,
          ),
        ),
        const BreakTimerWidget(),
        Container(
          height: 4.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        Text(
          textAlign: TextAlign.center,
          "You're now on a 30-minute break",
          style: interRegular.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 18.sp),
            color: AppColors.iconColorGray,
          ),
        ),
        Row(
          spacing: 6.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                context.pop();
                context.pushNamed(Routes.realExamScreen);
                // context.read<RealExamCubit>().startRealExam();
                // cubit.finishAnalysisExam();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text(
                  'End Break Early',
                  style: interBold.copyWith(
                    fontSize: SizeConfig.responsiveValue(
                      phone: 14.sp,
                      tablet: 18.sp,
                    ),
                    color: AppColors.iconColorBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BreakTimerWidget extends StatefulWidget {
  const BreakTimerWidget({super.key});

  @override
  State<BreakTimerWidget> createState() => _BreakTimerWidgetState();
}

class _BreakTimerWidgetState extends State<BreakTimerWidget> {
  bool isButtonDisabled = false;
  int timeLeftInSeconds = 1800;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeftInSeconds > 0) {
        setState(() {
          timeLeftInSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String formatTime(int totalSeconds) {
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatTime(timeLeftInSeconds),
          style: interBold.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 52.sp, tablet: 56.sp),
            color: AppColors.forthColor,
          ),
        ),
      ],
    );
  }
}
