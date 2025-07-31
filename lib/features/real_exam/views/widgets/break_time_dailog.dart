import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';

class BreakTimeDialog extends StatelessWidget {
  const BreakTimeDialog({required this.breakEndTime, super.key});
  final DateTime breakEndTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Break Time',
          style: interBold.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 22.sp, tablet: 26.sp),
            color: AppColors.iconColorGray,
          ),
        ),
        12.verticalSpace,
        BreakTimerWidget(
          breakEndTime: breakEndTime,
          onTimerFinish: () {
            getIt<RealExamCubit>().startNextSection();
          },
        ),
        12.verticalSpace,
        Text(
          "You're now on a 30-minute break",
          style: interRegular.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 18.sp),
            color: AppColors.iconColorGray,
          ),
        ),
        24.verticalSpace,
        TextButton(
          onPressed: () {
            getIt<RealExamCubit>().startNextSection();
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
    );
  }
}

class BreakTimerWidget extends StatefulWidget {
  const BreakTimerWidget({
    required this.breakEndTime,
    required this.onTimerFinish,
    super.key,
  });
  final DateTime breakEndTime;
  final VoidCallback onTimerFinish;

  @override
  State<BreakTimerWidget> createState() => _BreakTimerWidgetState();
}

class _BreakTimerWidgetState extends State<BreakTimerWidget> {
  Timer? _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _recalculateTime();
    _startTimer();
  }

  void _recalculateTime() {
    final now = DateTime.now();
    if (now.isAfter(widget.breakEndTime)) {
      _timeLeft = Duration.zero;
    } else {
      _timeLeft = widget.breakEndTime.difference(now);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recalculateTime();
      if (_timeLeft.inSeconds <= 0) {
        _timer?.cancel();
        widget.onTimerFinish();
      }
      setState(() {});
    });
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_timeLeft),
      style: interBold.copyWith(
        fontSize: SizeConfig.responsiveValue(phone: 52.sp, tablet: 56.sp),
        color: AppColors.forthColor,
      ),
    );
  }
}
