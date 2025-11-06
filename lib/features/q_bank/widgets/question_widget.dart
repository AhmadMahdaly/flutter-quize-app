import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    super.key,
    required this.currentQuestion,
    required this.isFav,
    required this.question,
    this.addCircledFun,
    required this.newsExplain,
    required this.lightBulbExplain,
    required this.questionCircleExplain,
    this.isAdd = false,
  });
  final String currentQuestion, question;
  final bool isFav;
  final GestureTapCallback? addCircledFun;
  final String newsExplain, lightBulbExplain, questionCircleExplain;
  final bool isAdd;
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
                  fontSize: SizeConfig.responsiveValue(
                    phone: 16.sp,
                    tablet: 20.sp,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: addCircledFun,
                    child: ExcludeSemantics(
                      child: Icon(
                        isAdd
                            ? CupertinoIcons.delete
                            : CupertinoIcons.add_circled,
                        color: AppColors.forthColor.withAlpha(170),
                        size: SizeConfig.responsiveValue(
                          phone: 20.sp,
                          tablet: 40.sp,
                        ),
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Icon(
                    isFav ? CupertinoIcons.star_fill : CupertinoIcons.star,
                    color: isFav
                        ? Colors.amber
                        : AppColors.forthColor.withAlpha(170),
                    size: SizeConfig.responsiveValue(
                      phone: 20.sp,
                      tablet: 40.sp,
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
                          color: AppColors.darkGreyColor,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    showDuration: const Duration(milliseconds: 5000),
                    richMessage: TextSpan(
                      children: [
                        TextSpan(
                          text: '${'note'.tr(context)}\n',
                          style: interBold.copyWith(
                            fontSize: 16.sp,
                            color: AppColors.forthColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: newsExplain == 'null' || newsExplain == 'NULL'
                              ? ''
                              : newsExplain,
                          style: interRegular.copyWith(
                            fontSize: 16.sp,
                            color: AppColors.forthColor,
                          ),
                        ),
                      ],
                    ),
                    child: Icon(
                      CupertinoIcons.news,
                      size: SizeConfig.responsiveValue(
                        phone: 20.sp,
                        tablet: 40.sp,
                      ),
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
                          color: AppColors.darkGreyColor,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    showDuration: const Duration(milliseconds: 5000),
                    richMessage: TextSpan(
                      children: [
                        TextSpan(
                          text: '${'hint'.tr(context)}\n',
                          style: interBold.copyWith(
                            fontSize: 16.sp,
                            color: AppColors.forthColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text:
                              lightBulbExplain == 'null' ||
                                  lightBulbExplain == 'NULL'
                              ? ''
                              : lightBulbExplain,
                          style: interRegular.copyWith(
                            fontSize: SizeConfig.responsiveValue(
                              phone: 16.sp,
                              tablet: 20.sp,
                            ),
                            color: AppColors.forthColor,
                          ),
                        ),
                      ],
                    ),
                    child: Icon(
                      lightBulbExplain == 'null' || lightBulbExplain == 'NULL'
                          ? CupertinoIcons.lightbulb_slash
                          : CupertinoIcons.lightbulb_fill,
                      size: SizeConfig.responsiveValue(
                        phone: 20.sp,
                        tablet: 40.sp,
                      ),
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
                          color: AppColors.darkGreyColor,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    showDuration: const Duration(minutes: 10),
                    richMessage: TextSpan(
                      children: [
                        TextSpan(
                          text: '${'explanation'.tr(context)}\n',
                          style: interBold.copyWith(
                            fontSize: 16.sp,
                            color: AppColors.forthColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: questionCircleExplain == 'null'
                              ? ''
                              : questionCircleExplain,
                          style: interRegular.copyWith(
                            fontSize: SizeConfig.responsiveValue(
                              phone: 16.sp,
                              tablet: 20.sp,
                            ),
                            color: AppColors.forthColor,
                          ),
                        ),
                      ],
                    ),
                    child: Icon(
                      CupertinoIcons.question_circle,
                      size: SizeConfig.responsiveValue(
                        phone: 20.sp,
                        tablet: 40.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          15.verticalSpace,
          Text(
            question,
            style: interRegular.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}
