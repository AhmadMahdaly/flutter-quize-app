import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class CustomTimerWidget extends StatefulWidget {
  const CustomTimerWidget({
    super.key,
    required this.endTime,
    required this.onTimerFinish,
  });

  final DateTime endTime;
  final VoidCallback onTimerFinish;

  @override
  State<CustomTimerWidget> createState() => _CustomTimerWidgetState();
}

class _CustomTimerWidgetState extends State<CustomTimerWidget> {
  Timer? _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant CustomTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.endTime != oldWidget.endTime) {
      _timer?.cancel();
      _updateTimeLeft();
      _startTimer();
    }
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    _timeLeft = now.isBefore(widget.endTime)
        ? widget.endTime.difference(now)
        : Duration.zero;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        widget.onTimerFinish();
      }
    });
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
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
        fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
        color: AppColors.thirdColor,
      ),
    );
  }
}
