import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/real_exam/data/model/get_real_exam_model.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    // required this.questionText,
    required this.onNext,
    required this.onPrevious,
    required this.data,
    super.key,
    this.isFirst = false,
    this.isLast = false,
  });
  // final String questionText;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isFirst;
  final bool isLast;
  final Question data;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedAnswer;

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  Widget buildOption(String optionLetter, String text) {
    final isSelected = selectedAnswer == optionLetter;

    return GestureDetector(
      onTap: () => selectAnswer(optionLetter),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.successColor : AppColors.thirdColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
          color: AppColors.forthColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: AppColors.thirdColor,
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        child: Column(children: [
          SizedBox(height: 8.h),
          Container(
            width: 283.w,
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.h),
            height: 328.h,
            decoration: ShapeDecoration(
              color: AppColors.thirdColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child:

                /// inside body
                Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 140.h,
                  child: ListView(children: [
                    Text(
                      q.questionText ?? '',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: AppColors.forthColor,
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.20.h,
                      ),
                    ),
                    if (q.photo != null && q.photo!.isNotEmpty)
                      Image.network(q.photo!, height: 200, fit: BoxFit.cover),
                  ]),
                ),
                const Spacer(),

                buildOption('A', q.a ?? ''),
                buildOption('B', q.b ?? ''),
                buildOption('C', q.c ?? ''),
                buildOption('D', q.d ?? ''),
                const SizedBox(height: 8),

                /// Button
                InkWell(
                  onTap: () {
                    // context.read<RealExamCubit>().postRealExam(
                    //   PostRealExamModel(
                    //     status: status,
                    //     message: data.message,
                    //     data: [
                    //       Answer(
                    //         id: data.data.id,
                    //         examId: data.examId,
                    //         section: data.data.section,
                    //         questionNo: data.data.questionNo,
                    //         questionText: questionText,
                    //         a: data.data.a,
                    //         b: data.data.b,
                    //         c: data.data.c,
                    //         d: data.data.d,
                    //         isBookmarked: data.data.isBookmarked,
                    //         isAnswered: data.data.isAnswered,
                    //         realAnswer: '',
                    //         correct: true,
                    //       ),
                    //     ],
                    //   ),
                    // );
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 163.w,
                      height: 34.h,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: ShapeDecoration(
                        color: AppColors.iconColorBlack,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Calculator',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.forthColor,
                              fontSize: 16.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.50.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          )
        ]));
  }
}
