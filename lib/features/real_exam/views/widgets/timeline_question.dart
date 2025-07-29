import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/data/model/get_real_exam_model.dart';
import 'package:smle/features/real_exam/views/refactors/question_widget.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/timeline_items.dart';
import 'package:smle/features/real_exam/views/refactors/timeline/timeline_status.dart';
import 'package:smle/features/real_exam/views/widgets/header_exam_details_card.dart';

class TimelineQuestionPage extends StatefulWidget {
  const TimelineQuestionPage({required this.examModel, super.key});
  final StartRealExamModel examModel;

  @override
  State<TimelineQuestionPage> createState() => _TimelineQuestionPageState();
}

class _TimelineQuestionPageState extends State<TimelineQuestionPage> {
  late final ScrollController _scrollController;

  final double _itemHeight = 48.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TimelineQuestionPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.examModel.data?.questionNo !=
        oldWidget.examModel.data?.questionNo) {
      _scrollToCurrent();
    }
  }

  void _scrollToCurrent() {
    if (_scrollController.hasClients) {
      final currentQuestionIndex = (widget.examModel.data?.questionNo ?? 1) - 1;

      final targetOffset = _itemHeight * currentQuestionIndex;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RealExamCubit>();
    final Question currentQuestion = widget.examModel.data!;
    final int totalQuestions = widget.examModel.questionsCount!;
    final int currentQuestionNo = currentQuestion.questionNo!;

    Widget buildTimelineItem(int index) {
      final questionNumber = index + 1;

      final isCurrent = questionNumber == currentQuestionNo;
      TimelineStatus status;
      if (isCurrent) {
        status = TimelineStatus.current;
      } else if (questionNumber < currentQuestionNo) {
        status = TimelineStatus.completed;
      } else {
        status = TimelineStatus.upcoming;
      }
      return GestureDetector(
        onTap: () {
          if (!isCurrent) {
            cubit.goToIndex(questionNumber);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: SizedBox(
            height: _itemHeight - 24.h,
            child: TimelineItem(
              isBookmarked: currentQuestion.isBookmarked!,
              number: questionNumber.toString(),
              status: status,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        ExamDetailsCard(
          question: currentQuestion,
          totalQuestions: totalQuestions,
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: double.infinity,
                width: 80.w,
                color: AppColors.thirdColor,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: totalQuestions,
                  itemExtent: _itemHeight,
                  itemBuilder: (context, index) => buildTimelineItem(index),
                ),
              ),

              /// MARK: Q
              Expanded(
                child: Center(
                  child: QuestionWidget(
                    key: ValueKey(currentQuestion.id),
                    data: currentQuestion,
                    onNext: cubit.goToNext,
                    onPrevious: cubit.goToPrevious,
                    isFirst: currentQuestionNo == 1,
                    isLast: currentQuestionNo == totalQuestions,
                  ),
                ),
              ),
            ],
          ),
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
                  8.horizontalSpace,
                  IconButton(
                    onPressed: () {
                      context.read<RealExamCubit>().makeQuestionFlag(
                        currentQuestion.id.toString(),
                      );
                      context.watch()<RealExamCubit>().getQuestion(
                        currentQuestion.examId!,
                        currentQuestionNo,
                        currentQuestion.section!,
                      );
                    },
                    icon: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: ShapeDecoration(
                        color: AppColors.successColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: const Icon(
                        Icons.flag_outlined,
                        color: AppColors.thirdColor,
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  InkWell(
                    onTap: currentQuestionNo == 0 ? null : cubit.goToPrevious,
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
                  8.horizontalSpace,
                  InkWell(
                    onTap: () => currentQuestionNo == totalQuestions - 1
                        ? null
                        : cubit.goToNext(),
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
  }
}
