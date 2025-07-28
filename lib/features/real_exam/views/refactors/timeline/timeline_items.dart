import 'package:flutter/material.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/question_items/next_item.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/question_items/select_item.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/question_items/selected_item.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/timeline_status.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem({required this.number, required this.status, super.key});
  final String number;
  final TimelineStatus status;

  Color get backgroundColor {
    switch (status) {
      case TimelineStatus.current:
        return AppColors.successColor;
      case TimelineStatus.completed:
        return AppColors.iconColorBlack;
      case TimelineStatus.upcoming:
        return AppColors.successColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (status == TimelineStatus.completed)
          SelectedQuestionItem(number: number, color: backgroundColor),
        if (status == TimelineStatus.current)
          SelectQuestionItem(text: number, color: backgroundColor),
        if (status == TimelineStatus.upcoming)
          NextQuestionItem(text: number, color: backgroundColor),
      ],
    );
  }
}