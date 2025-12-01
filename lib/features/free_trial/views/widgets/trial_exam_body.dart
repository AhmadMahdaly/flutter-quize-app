// ignore_for_file: unreachable_switch_default

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/free_trial/cubit/free_trial_cubit.dart';
import 'package:smle/features/free_trial/views/widgets/trial_header_card.dart';
import 'package:smle/features/free_trial/views/widgets/trial_question_widget.dart';
import 'package:smle/features/real_exam/views/widgets/timeline/question_items/complated_item.dart';
import 'package:smle/features/real_exam/views/widgets/timeline/question_items/current_item.dart';
import 'package:smle/features/real_exam/views/widgets/timeline/question_items/upcoming_item.dart';

class TrialExamBody extends StatefulWidget {
  const TrialExamBody({super.key});

  @override
  State<TrialExamBody> createState() => _TrialExamBodyState();
}

class _TrialExamBodyState extends State<TrialExamBody> {
  late final ScrollController _scrollController;
  final double _itemHeight = 52.h;

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
  void didUpdateWidget(covariant TrialExamBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    _scrollToCurrent();
  }

  void _scrollToCurrent() {
    final state = context.read<TrialExamCubit>().state;
    if (_scrollController.hasClients) {
      final targetOffset = _itemHeight * state.currentQuestionIndex;
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TrialExamCubit>();
    return BlocListener<TrialExamCubit, TrialExamState>(
      listener: (context, state) {
        // التحقق من الانتهاء التلقائي: آخر سؤال + إجابة عليه
        if (state.status == FetchStatus.success &&
            state.questions.isNotEmpty &&
            state.currentQuestionIndex == state.questions.length - 1 &&
            state.userAnswers.containsKey(
              state.questions[state.currentQuestionIndex].id,
            )) {
          showDialog(
            context: context,
            builder: (ctx) => ResultsDialog(state: state, cubit: cubit),
          );
        }
      },
      child: BlocBuilder<TrialExamCubit, TrialExamState>(
        builder: (context, state) {
          final currentQuestion = state.questions[state.currentQuestionIndex];
          final totalQuestions = state.questions.length;
          final currentQuestionNo = state.currentQuestionIndex + 1;

          return Column(
            children: [
              TrialHeaderCard(
                questionNumber: currentQuestionNo,
                totalQuestions: totalQuestions,
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: totalQuestions,
                        itemExtent: _itemHeight,
                        itemBuilder: (context, index) {
                          return buildTimelineItem(context, index);
                        },
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: TrialQuestionWidget(
                          key: ValueKey(currentQuestion.id),
                          question: currentQuestion,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              _buildBottomBar(
                context,
                cubit,
                currentQuestionNo,
                totalQuestions,
                currentQuestion.id,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildTimelineItem(BuildContext context, int index) {
    final cubit = context.read<TrialExamCubit>();
    final state = cubit.state;
    final question = state.questions[index];
    final questionNumber = index + 1;
    final isCurrent = index == state.currentQuestionIndex;
    final hasAnswered = state.userAnswers.containsKey(question.id);

    UITimelineStatus status;
    if (isCurrent) {
      status = UITimelineStatus.current;
    } else if (hasAnswered) {
      status = UITimelineStatus.completed;
    } else {
      status = UITimelineStatus.upcoming;
    }

    return GestureDetector(
      onTap: () => cubit.goToIndex(index),
      child: TimelineItem(number: questionNumber.toString(), status: status),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    TrialExamCubit cubit,
    int currentQuestionNo,
    int totalQuestions,
    int currentQuestionId,
  ) {
    final bool isFirst = currentQuestionNo == 1;
    final bool isLast = currentQuestionNo == totalQuestions;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.offwhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            SizeConfig.responsiveValue(phone: 8.r, tablet: 8.r),
          ),
          topRight: Radius.circular(
            SizeConfig.responsiveValue(phone: 8.r, tablet: 8.r),
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(
            text: '< Back',
            onTap: isFirst ? null : cubit.goToPrevious,
          ),

          _buildNavButton(
            text: 'Next >',
            onTap: isLast ? null : cubit.goToNext,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({required String text, VoidCallback? onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.successColor,
        foregroundColor: AppColors.offwhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            SizeConfig.responsiveValue(phone: 100.r, tablet: 60.r),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: SizeConfig.responsiveValue(phone: 8.h, tablet: 8.h),
        ),
      ),
      child: Text(
        text,
        style: interBold.copyWith(
          height: 0,
          fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 20.sp),
        ),
      ),
    );
  }
}

enum UITimelineStatus { current, completed, upcoming }

class TimelineItem extends StatelessWidget {
  const TimelineItem({required this.number, required this.status, super.key});
  final String number;
  final UITimelineStatus status;

  Color get backgroundColor {
    switch (status) {
      case UITimelineStatus.current:
        return AppColors.successColor;
      case UITimelineStatus.completed:
        return AppColors.forthColor;
      case UITimelineStatus.upcoming:
        return AppColors.successColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 70.w,
        height: SizeConfig.responsiveValue(phone: 40.h, tablet: 25.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (status == UITimelineStatus.completed)
              ComplatedItem(
                number: number,
                color: backgroundColor,
                isBookmarked: false,
              ),
            if (status == UITimelineStatus.current)
              CurrentItem(
                text: number,
                color: backgroundColor,
                isBookmarked: false,
              ),
            if (status == UITimelineStatus.upcoming)
              UpcomingItem(
                text: number,
                color: backgroundColor,
                isBookmarked: false,
              ),
          ],
        ),
      ),
    );
  }
}

class ResultsDialog extends StatelessWidget {
  const ResultsDialog({
    super.key,
    required this.cubit, // إضافة: تمرير cubit مباشرة
    required this.state,
  });
  final TrialExamCubit cubit;
  final TrialExamState state;

  @override
  Widget build(BuildContext context) {
    final totalQuestions = state.questions.length;
    int correctAnswers = 0;
    int incorrectAnswers = 0;

    for (var question in state.questions) {
      final userAnswer = state.userAnswers[question.id];
      if (userAnswer != null) {
        if (userAnswer == question.answer) {
          correctAnswers++;
        } else {
          incorrectAnswers++;
        }
      }
    }

    final score = totalQuestions > 0
        ? (correctAnswers / totalQuestions) * 100
        : 0;
    final unanswered = totalQuestions - (correctAnswers + incorrectAnswers);

    return AlertDialog(
      title: Text(
        'Test Finished!',
        textAlign: TextAlign.center,
        style: interRegular.copyWith(
          fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your Score: ${score.toStringAsFixed(1)}%',
            style: interBold.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),

              color: score >= 50
                  ? AppColors.successColor
                  : AppColors.errorColor,
            ),
          ),
          20.verticalSpace,
          ResultRow(
            title: 'Total Questions:',
            value: '$totalQuestions',
            color: AppColors.forthColor,
          ),
          ResultRow(
            title: 'Correct Answers:',
            value: '$correctAnswers',
            color: Colors.green.shade700,
          ),
          ResultRow(
            title: 'Incorrect Answers:',
            value: '$incorrectAnswers',
            color: AppColors.errorColor,
          ),
          ResultRow(
            title: 'Unanswered:',
            value: '$unanswered',
            color: AppColors.darkGreyColor,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: interRegular.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 12.sp, tablet: 16.sp),
              color: AppColors.iconColorBlack,
            ),
          ),
        ),
        // استخدام cubit المُمرر مباشرة بدلاً من context.read
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            cubit.resetExam();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.successColor,
            foregroundColor: AppColors.offwhiteColor,
          ),
          child: Text(
            'Start New Test',
            style: interRegular.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 12.sp, tablet: 16.sp),
            ),
          ),
        ),
      ],
    );
  }
}

class ResultRow extends StatelessWidget {
  const ResultRow({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });
  final String title, value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: interRegular.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 18.sp),
            ),
          ),
          Text(
            value,
            style: interBold.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 18.sp),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
