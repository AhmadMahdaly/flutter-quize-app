import 'package:flutter/material.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/question_items/complated_item.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/question_items/current_item.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/question_items/upcoming_item.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/timeline_status.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem(
      {required this.number,
      required this.status,
      super.key,
      required this.isBookmarked});
  final String number;
  final TimelineStatus status;
  final bool isBookmarked;

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
          ComplatedItem(
            number: number,
            color: backgroundColor,
            isBookmarked: isBookmarked,
          ),
        if (status == TimelineStatus.current)
          CurrentItem(text: number, color: backgroundColor),
        if (status == TimelineStatus.upcoming)
          UpcomingItem(text: number, color: backgroundColor),
      ],
    );
  }
}
