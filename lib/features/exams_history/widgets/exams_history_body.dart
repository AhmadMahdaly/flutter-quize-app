import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/exams_history/widgets/exams_lists.dart';

class ExamHistoryBody extends StatelessWidget {
  const ExamHistoryBody({super.key, required this.cubit});

  final ExamsHistoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: ExamsList(cubit: cubit),
    );
  }
}
