import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/real_exam/views/widgets/timeline/question_items/complated_item.dart';
import 'package:smle/features/real_exam/views/widgets/timeline/question_items/current_item.dart';
import 'package:smle/features/real_exam/views/widgets/timeline/question_items/upcoming_item.dart';
import 'package:smle/features/real_exam/views/widgets/timeline/timeline_status.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem({
    required this.number,
    required this.status,
    super.key,
    required this.isBookmarked,
    required this.hasNote,
  });
  final String number;
  final bool hasNote;
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
          CurrentItem(
            text: number,
            color: backgroundColor,
            isBookmarked: isBookmarked,
          ),
        if (status == TimelineStatus.upcoming)
          UpcomingItem(
            text: number,
            color: backgroundColor,
            isBookmarked: isBookmarked,
          ),
        if (hasNote)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                /// todo add view notes
              },
              child: Icon(
                Icons.edit,
                color: AppColors.darkGreyColor,
                size: 18.r,
              ),
            ),
          ),
      ],
    );
  }
}
