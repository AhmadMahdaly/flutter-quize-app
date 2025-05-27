import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget(
      {super.key,
      required this.currentQuestion,
      required this.isFav,
      required this.question,
      this.addCircledFun,
      required this.newsExplain,
        required this.lightBulbExplain,
        required this.questionCircleExplain});
  final String currentQuestion, question;
  final bool isFav;
  final GestureTapCallback? addCircledFun;
   final String   newsExplain,
      lightBulbExplain,
      questionCircleExplain;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${'question'.tr(context)} $currentQuestion",
                style: interBold.copyWith(
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  GestureDetector(
                      onTap: addCircledFun,
                      child: Icon(
                        CupertinoIcons.add_circled,
                        color: AppColors.forthColor.withOpacity(0.7),
                        size: 30.r,
                      )),
                  10.horizontalSpace,
                  Icon(
                    isFav?CupertinoIcons.star_fill:CupertinoIcons.star,
                    color:isFav?Colors.amber: AppColors.forthColor.withOpacity(0.7),
                    size: 30.r,
                  ),
                  10.horizontalSpace,
                   Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    decoration: BoxDecoration(
                        color: AppColors.thirdColor,
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.darkGreyColor, blurRadius: 5)
                        ]),
                    showDuration: const Duration(milliseconds: 5000),
                    richMessage: TextSpan(children: [
                      TextSpan(
                          text: '${'note'.tr(context)}\n',
                          style: interBold.copyWith(
                              fontSize: 16.sp,
                              color: AppColors.forthColor,
                              decoration: TextDecoration.underline)),
                      TextSpan(
                          text: newsExplain=='null'?'':newsExplain,
                          style: interRegular.copyWith(fontSize: 16.sp,color: AppColors.forthColor,))
                    ]),
                    child: const Icon(
                      CupertinoIcons.news,
                    ),
                  ),
                  10.horizontalSpace,
                  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    decoration: BoxDecoration(
                        color: AppColors.thirdColor,
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.darkGreyColor, blurRadius: 5)
                        ]),
                    showDuration: const Duration(milliseconds: 5000),
                    richMessage: TextSpan(children: [
                      TextSpan(
                          text: '${'hint'.tr(context)}\n',
                          style: interBold.copyWith(
                              fontSize: 16.sp,
                              color: AppColors.forthColor,
                              decoration: TextDecoration.underline)),
                      TextSpan(
                          text: lightBulbExplain=='null'?'':lightBulbExplain,
                          style: interRegular.copyWith(fontSize: 16.sp,color: AppColors.forthColor,))
                    ]),
                    child: const Icon(
                      CupertinoIcons.lightbulb,
                    ),
                  ),

                  10.horizontalSpace,
                  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    decoration: BoxDecoration(
                        color: AppColors.thirdColor,
                        borderRadius: BorderRadius.all(Radius.circular(30.r)),
                        boxShadow: const [
                          BoxShadow(
                              color: AppColors.darkGreyColor, blurRadius: 5)
                        ]),
                    showDuration: const Duration(milliseconds: 5000),
                    richMessage: TextSpan(children: [
                      TextSpan(
                          text: '${'explanation'.tr(context)}\n',
                          style: interBold.copyWith(
                              fontSize: 16.sp,
                              color: AppColors.forthColor,
                              decoration: TextDecoration.underline)),
                      TextSpan(
                          text: questionCircleExplain=='null'?'':questionCircleExplain,
                          style: interRegular.copyWith(fontSize: 16.sp,color: AppColors.forthColor,))
                    ]),
                    child: const Icon(
                      CupertinoIcons.question_circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          15.verticalSpace,
          Text(
            question,
            style: interRegular.copyWith(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
