import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/views/refactors/question_widget.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/timeline_items.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/timeline_status.dart';
import 'package:smle/features/real_exam/views/widgets/header_exam_details_card.dart';

class TimelineQuestionPage extends StatefulWidget {
  const TimelineQuestionPage({
    required this.currentIndex,
    super.key,
  });
  final int currentIndex;
  @override
  State<TimelineQuestionPage> createState() => _TimelineQuestionPageState();
}

class _TimelineQuestionPageState extends State<TimelineQuestionPage> {
  @override
  void initState() {
    context.read<RealExamCubit>().startRealExam();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTimelineItem(int index) {
      final isCompleted = index < widget.currentIndex;
      final isCurrent = index == widget.currentIndex;
      final cubit = context.read<RealExamCubit>();
      final data = cubit.startRealExamModel?.data!;
      return GestureDetector(
        onTap: () {
          context.read<RealExamCubit>().goToIndex(index);
          cubit.getQuestion(data!.examId!, data.questionNo!, data.section!);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: TimelineItem(
            number: (index + 1).toString(),
            status: isCompleted
                ? TimelineStatus.completed
                : isCurrent
                    ? TimelineStatus.current
                    : TimelineStatus.upcoming,
          ),
        ),
      );
    }

    return BlocBuilder<RealExamCubit, RealExamState>(builder: (context, state) {
      final cubit = context.read<RealExamCubit>();
      final progress = cubit.startRealExamModel?.questionsCount;
      final data = cubit.startRealExamModel?.data!;

      return Column(
        children: [
          ExamDetailsCard(
              // data: data,
              currentIndex: widget.currentIndex),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //  الشريط الجانبي
              Container(
                height: 370.h,
                width: 80.w,
                color: AppColors.thirdColor,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(progress!, buildTimelineItem),
                  ),
                ),
              ),

              //  عرض السؤال
              Expanded(
                child: Center(
                  child: QuestionWidget(
                    data: data!,
                    onNext: () => {cubit.goToNext(widget.currentIndex)},
                    onPrevious: cubit.goToPrevious,
                    isFirst: widget.currentIndex == 0,
                    isLast: widget.currentIndex == progress - 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Column(
            children: [
              Container(
                width: 359.w,
                height: 5.h,
                decoration: ShapeDecoration(
                  color: AppColors.successColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
                    ),
                  ),
                ),
              ),
              Container(
                width: 359.w,
                height: 48.h,
                decoration: ShapeDecoration(
                  color: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// buttons
                    Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: ShapeDecoration(
                        color: AppColors.successColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.thirdColor,
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: ShapeDecoration(
                        color: AppColors.successColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: const Icon(Icons.flag_outlined,
                          color: AppColors.thirdColor),
                    ),
                    10.verticalSpace,
                    InkWell(
                      onTap:
                          widget.currentIndex == 0 ? null : cubit.goToPrevious,
                      child: Container(
                        width: 74.w,
                        height: 30.h,
                        decoration: ShapeDecoration(
                          color: AppColors.successColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '<Back',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: AppColors.thirdColor,
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    InkWell(
                      onTap: () => widget.currentIndex == progress - 1
                          ? null
                          : cubit.goToNext(widget.currentIndex),
                      child: Container(
                        width: 74.w,
                        height: 30.h,
                        decoration: ShapeDecoration(
                          color: AppColors.successColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Next>',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: AppColors.thirdColor,
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
