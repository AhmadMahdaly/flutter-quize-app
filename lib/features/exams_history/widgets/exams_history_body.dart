import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/exams_history/widgets/exams_lists.dart';

class ExamHistoryBody extends StatelessWidget {
  const ExamHistoryBody({super.key, required this.cubit});

  final ExamsHistoryCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Column(
        children: [
          TabBar(
            unselectedLabelColor: AppColors.darkGreyColor,
            labelColor: AppColors.forthColor,
            indicator: const BoxDecoration(),
            dividerColor: Colors.transparent,
            labelStyle: interBold.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 18.sp),
              color: AppColors.forthColor,
            ),
            tabs: [
              Tab(text: 'pass'.tr(context)),
              Tab(text: 'mid_level'.tr(context)),
              Tab(text: 'fail'.tr(context)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ExamsList(exams: cubit.passedExams),
                ExamsList(exams: cubit.midLevelExams),
                ExamsList(exams: cubit.failedExams),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
