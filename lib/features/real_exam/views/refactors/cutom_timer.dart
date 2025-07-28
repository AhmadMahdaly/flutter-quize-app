import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';

class CustomTimerWidget extends StatefulWidget {
  const CustomTimerWidget({super.key});

  @override
  State<CustomTimerWidget> createState() => _CustomTimerWidgetState();
}

class _CustomTimerWidgetState extends State<CustomTimerWidget> {
  bool isButtonDisabled = false; // لمنع الضغط على الزر أثناء العد التنازلي
  int timeLeftInSeconds = 3600; // ساعة واحدة = 3600 ثانية
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
        // الإجراء بعد انتهاء الوقت
      }
    });
  }

  String formatTime(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
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
          style: TextStyle(fontSize: 16.sp, color: AppColors.thirdColor),
        ),
      ],
    );
  }
}
