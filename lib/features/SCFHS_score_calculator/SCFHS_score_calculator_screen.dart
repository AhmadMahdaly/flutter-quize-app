import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/SCFHS_score_calculator/cubit/SCFHS_score_calculator_cubit.dart';
import 'package:smle/features/SCFHS_score_calculator/widgets/calculate_result_dialog.dart';
import 'package:smle/features/SCFHS_score_calculator/widgets/text_row_widget.dart';

class ScfhsScoreCalculatorScreen extends StatefulWidget {
  const ScfhsScoreCalculatorScreen({super.key});

  @override
  State<ScfhsScoreCalculatorScreen> createState() =>
      _ScfhsScoreCalculatorScreenState();
}

class _ScfhsScoreCalculatorScreenState
    extends State<ScfhsScoreCalculatorScreen> {
  int? selectedHour;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'SCFHS_score_calculator'.tr(context)),
      body: SingleChildScrollView(
        child: BlocBuilder<ScfhsScoreCalculatorCubit, SCFHSScoreCalculatorStates>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child:
                  context
                          .read<ScfhsScoreCalculatorCubit>()
                          .calculatorInfoModel !=
                      null
                  ? Column(
                      spacing: 16.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextRowWidget(
                          firstText:
                              '${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.realExamScore!.name}',
                          secondText:
                              '(${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.realExamScore!.percentage})',
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          controller: context
                              .read<ScfhsScoreCalculatorCubit>()
                              .realExamController,
                          style: interRegular.copyWith(
                            color: AppColors.darkGreyColor,
                          ),
                          decoration: InputDecoration(
                            fillColor: AppColors.greyColor.withOpacity(
                              0.3,
                            ), // Background color
                            filled: true, // Enables the background color
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.r),
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.r),
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.r),
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '${'maximum_score'.tr(context)} ${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.realExamScore!.maxScore}',
                          style: interRegular.copyWith(
                            fontSize: SizeConfig.responsiveValue(
                              phone: 14.sp,
                              tablet: 18.sp,
                            ),
                            color: AppColors.darkGreyColor,
                          ),
                        ),
                        TextRowWidget(
                          firstText:
                              '${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.gPA!.name}',
                          secondText:
                              '(${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.gPA!.percentage})',
                        ),
                        TextFormField(
                          controller: context
                              .read<ScfhsScoreCalculatorCubit>()
                              .gpaController,
                          textAlign: TextAlign.center,
                          style: interRegular.copyWith(
                            color: AppColors.darkGreyColor,
                          ),
                          decoration: InputDecoration(
                            fillColor: AppColors.greyColor, // Background color
                            filled: true, // Enables the background color
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.r),
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.r),
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.r),
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.greyColor,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '${'maximum_score'.tr(context)} ${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.gPA!.maxScore}',
                          style: interRegular.copyWith(
                            fontSize: SizeConfig.responsiveValue(
                              phone: 14.sp,
                              tablet: 18.sp,
                            ),
                            color: AppColors.darkGreyColor,
                          ),
                        ),
                        TextRowWidget(
                          firstText:
                              '${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.name}',
                          secondText:
                              '(${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.percentage})',
                        ),
                        if (context
                                .read<ScfhsScoreCalculatorCubit>()
                                .calculatorInfoModel!
                                .cVChecklist!
                                .items !=
                            null)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<ScfhsScoreCalculatorCubit>()
                                        .selectCvCheckList(
                                          context
                                              .read<ScfhsScoreCalculatorCubit>()
                                              .calculatorInfoModel!
                                              .cVChecklist!
                                              .items![index]
                                              .id!,
                                        );
                                  },
                                  child: Icon(
                                    context
                                            .read<ScfhsScoreCalculatorCubit>()
                                            .selectedCvIds
                                            .contains(
                                              context
                                                  .read<
                                                    ScfhsScoreCalculatorCubit
                                                  >()
                                                  .calculatorInfoModel!
                                                  .cVChecklist!
                                                  .items![index]
                                                  .id!,
                                            )
                                        ? CupertinoIcons.checkmark_circle
                                        : CupertinoIcons.circle,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                                5.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    '${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.items![index].name}',
                                    style: interRegular.copyWith(
                                      fontSize: SizeConfig.responsiveValue(
                                        phone: 14.sp,
                                        tablet: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                5.horizontalSpace,
                                Text(
                                  '(${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.items![index].maxScore} ${"points".tr(context)})',
                                  style: interRegular.copyWith(
                                    fontSize: SizeConfig.responsiveValue(
                                      phone: 14.sp,
                                      tablet: 18.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            separatorBuilder: (context, index) =>
                                15.verticalSpace,
                            itemCount: context
                                .read<ScfhsScoreCalculatorCubit>()
                                .calculatorInfoModel!
                                .cVChecklist!
                                .items!
                                .length,
                          ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              if (context
                                      .read<ScfhsScoreCalculatorCubit>()
                                      .gpaController
                                      .text
                                      .isNotEmpty &&
                                  context
                                      .read<ScfhsScoreCalculatorCubit>()
                                      .realExamController
                                      .text
                                      .isNotEmpty) {
                                context
                                    .read<ScfhsScoreCalculatorCubit>()
                                    .getCalculateResult()
                                    .then((onValue) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          if (onValue != null) {
                                            return CalculateResultDialog(
                                              score: onValue.data!,
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      );
                                    });
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                AppColors.secondaryColor,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: WidgetStateProperty.all(
                                Size(150.w, 52.h),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                            ),
                            child: Text(
                              'calculate'.tr(context),
                              style: interBold.copyWith(
                                color: AppColors.thirdColor,
                                fontSize: SizeConfig.responsiveValue(
                                  phone: 14.sp,
                                  tablet: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
