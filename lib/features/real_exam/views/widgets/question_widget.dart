import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/data/model/get_real_exam_model.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    required this.onNext,
    required this.onPrevious,
    required this.data,
    this.savedAnswer,
    super.key,
    this.isFirst = false,
    this.isLast = false,
  });
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isFirst;
  final bool isLast;
  final Question data;
  final String? savedAnswer;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedAnswer;
  @override
  void initState() {
    super.initState();
    selectedAnswer = widget.savedAnswer;
  }

  @override
  void didUpdateWidget(covariant QuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.savedAnswer != oldWidget.savedAnswer) {
      selectedAnswer = widget.savedAnswer;
    }
  }

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  Widget buildOption(String optionLetter, String text) {
    final isSelected = selectedAnswer == optionLetter;

    return GestureDetector(
      onTap: () async {
        selectAnswer(optionLetter);

        await context.read<RealExamCubit>().answerQuestion(
          widget.data.id.toString(),
          widget.data.questionNo!,
          optionLetter,
        );
        context.read<RealExamCubit>().goToNext();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: SizeConfig.responsiveValue(phone: 0, tablet: 2.h),
        ),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.successColor
              : AppColors.thirdColor, //AppColors.greenColor
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.successColor
                : AppColors.darkGreyColor,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyle.style12W500.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.offwhiteColor : AppColors.forthColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.data;

    return Container(
      width: 295.w,
      decoration: ShapeDecoration(
        color: AppColors.thirdColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: AppColors.greyColor,
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          8.verticalSpace,
          Expanded(
            child: Container(
              width: 283.w,
              padding: EdgeInsets.all(6.r),
              decoration: ShapeDecoration(
                color: AppColors.offwhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child:
                  /// inside body
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Text(
                              q.questionText ?? '',
                              style: AppTextStyle.style14W700.copyWith(
                                color: AppColors.forthColor,
                              ),
                            ),
                            if (q.photo != null && q.photo!.isNotEmpty ||
                                q.photo != null && q.photo != 'null')
                              Image.network(
                                q.photo!,
                                height: SizeConfig.responsiveValue(
                                  phone: 200.h,
                                  tablet: 140.h,
                                ),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox.shrink(),
                              ),
                            16.verticalSpace,
                            buildOption('a', q.a ?? ''),
                            buildOption('b', q.b ?? ''),
                            buildOption('c', q.c ?? ''),
                            buildOption('d', q.d ?? ''),
                            8.verticalSpace,
                          ],
                        ),
                      ),
                    ],
                  ),
            ),
          ),
          // 8.verticalSpace,

          /// Button
          // InkWell(
          //   onTap: () {
          // //  context.read<RealExamCubit>().postRealExam(
          //  //   PostRealExamModel(
          //  //     status: status,
          //  //     message: data.message,
          //  //     data: [
          //  //       Answer(
          //  //         id: data.data.id,
          //  //         examId: data.examId,
          //  //         section: data.data.section,
          //  //         questionNo: data.data.questionNo,
          //   //        questionText: questionText,
          //   //        a: data.data.a,
          //   //        b: data.data.b,
          //   //        c: data.data.c,
          //   //        d: data.data.d,
          //   //        isBookmarked: data.data.isBookmarked,
          //   //        isAnswered: data.data.isAnswered,
          //  //         realAnswer: '',
          //   //        correct: true,
          //   //      ),
          //   //    ],
          //   //  ),
          //  // );
          //   },
          //   child: Align(
          //     alignment: Alignment.center,
          //     child: Container(
          //       width: 163.w,
          //       height: 34.h,
          //       margin: EdgeInsets.symmetric(horizontal: 20.w),
          //       decoration: ShapeDecoration(
          //         color: AppColors.iconColorBlack.withAlpha(40),
          //         shape: RoundedRectangleBorder(
          //           side: const BorderSide(
          //             width: 1,
          //             strokeAlign: BorderSide.strokeAlignOutside,
          //           ),
          //           borderRadius: BorderRadius.circular(100.r),
          //         ),
          //       ),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Text(
          //             'Calculator',
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               color: AppColors.forthColor,
          //               fontSize: 16.sp,
          //               fontFamily: 'Inter',
          //               fontWeight: FontWeight.w500,
          //               height: 1.50.h,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          8.verticalSpace,
        ],
      ),
    );
  }
}
