import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_cache_image.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    super.key,
    required this.currentQuestion,
    required this.isRepeated,
    required this.question,
    this.addToPlaylistFun,
    required this.hintText,
    required this.explainText,
    this.isAdd = false,
    this.onNoteTap,
    this.qPhoto,
    this.explainPhoto,
  });
  final VoidCallback? onNoteTap;
  final String currentQuestion, question;
  final bool isRepeated;
  final GestureTapCallback? addToPlaylistFun;
  final String hintText, explainText;
  final bool isAdd;
  final String? qPhoto;
  final String? explainPhoto;
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
                "${'Question'} $currentQuestion",
                style: AppTextStyle.style16Bold,
              ),
              10.verticalSpace,
              Row(
                children: [
                  /// Add to favorite
                  InkWell(
                    onTap: addToPlaylistFun,
                    child: ExcludeSemantics(
                      child: Icon(
                        semanticLabel: 'Add to favorite',
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

                  /// is Repeated
                  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    decoration: BoxDecoration(
                      color: AppColors.thirdColor,
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
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
                          text: isRepeated
                              ? 'This Question Is Repeated More Than One Time.'
                              : '',
                          style: AppTextStyle.style16W500.copyWith(
                            color: AppColors.forthColor,
                          ),
                        ),
                      ],
                    ),

                    child: Icon(
                      isRepeated
                          ? CupertinoIcons.star_fill
                          : CupertinoIcons.star,
                      color: isRepeated
                          ? Colors.amber
                          : AppColors.forthColor.withAlpha(170),
                      size: SizeConfig.responsiveValue(
                        phone: 20.sp,
                        tablet: 40.sp,
                      ),
                    ),
                  ),
                  10.horizontalSpace,

                  /// Add Note
                  GestureDetector(
                    onTap: onNoteTap,
                    child: Icon(
                      semanticLabel: 'Send note',
                      CupertinoIcons.news,
                      color: AppColors.forthColor,
                      size: SizeConfig.responsiveValue(
                        phone: 20.sp,
                        tablet: 40.sp,
                      ),
                    ),
                  ),
                  10.horizontalSpace,

                  /// Hint
                  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    decoration: BoxDecoration(
                      color: AppColors.thirdColor,
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
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
                          text: '${'Hint'}\n',
                          style: AppTextStyle.style16Bold.copyWith(
                            color: AppColors.forthColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: hintText == 'null' || hintText == 'NULL'
                              ? ''
                              : hintText,
                          style: AppTextStyle.style16W500.copyWith(
                            color: AppColors.forthColor,
                          ),
                        ),
                      ],
                    ),
                    child: Icon(
                      hintText == 'null' || hintText == 'NULL'
                          ? CupertinoIcons.lightbulb_slash
                          : CupertinoIcons.lightbulb_fill,
                      color: hintText == 'null' || hintText == 'NULL'
                          ? null
                          : Colors.amber,
                      size: SizeConfig.responsiveValue(
                        phone: 20.sp,
                        tablet: 40.sp,
                      ),
                    ),
                  ),
                  10.horizontalSpace,

                  /// Explanation
                  Tooltip(
                    enableTapToDismiss: false,
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: const Duration(minutes: 30),
                    waitDuration: Duration.zero,
                    decoration: BoxDecoration(
                      color: AppColors.thirdColor,
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.darkGreyColor,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    richMessage: WidgetSpan(
                      child: GestureDetector(
                        onTap: () {},
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.6,
                            maxWidth: SizeConfig.screenWidth,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Explanation',
                                      style: AppTextStyle.style16Bold.copyWith(
                                        color: AppColors.forthColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Tooltip.dismissAllToolTips();
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: AppColors.forthColor,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.white24),
                                if (explainPhoto != null &&
                                    explainPhoto != 'null' &&
                                    explainPhoto != 'NULL')
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CustomCacheImageWidget(
                                        imageUrl: explainPhoto!,
                                      ),
                                    ),
                                  ),

                                Text(
                                  explainText == 'null' ? '' : explainText,
                                  style: AppTextStyle.style16W500.copyWith(
                                    color: AppColors.forthColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
          (qPhoto != null && qPhoto != 'null' && qPhoto != 'NULL')
              ? CustomCacheImageWidget(imageUrl: qPhoto!)
              : const SizedBox.shrink(),
          10.verticalSpace,
          Text(question, style: AppTextStyle.style14W500),
        ],
      ),
    );
  }
}
