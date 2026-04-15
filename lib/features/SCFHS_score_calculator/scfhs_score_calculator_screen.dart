import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/SCFHS_score_calculator/widgets/calculate_result_dialog.dart';
import 'package:smle/features/SCFHS_score_calculator/widgets/text_row_widget.dart';
import 'package:smle/features/scfhs_score_calculator/cubit/scfhs_score_calculator_cubit_cubit.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'SCFHS score calculator'),
      body: SingleChildScrollView(
        child: BlocBuilder<ScfhsScoreCalculatorCubit, ScfhsScoreCalculatorStates>(
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
                        GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: TextAlign.center,
                            controller: context
                                .read<ScfhsScoreCalculatorCubit>()
                                .realExamController,
                            style: AppTextStyle.style14W500.copyWith(
                              color: AppColors.iconColorBlack,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty &&
                                  (int.tryParse(value) ?? 0) > 800) {
                                context
                                    .read<ScfhsScoreCalculatorCubit>()
                                    .realExamController
                                    .text = context
                                    .read<ScfhsScoreCalculatorCubit>()
                                    .calculatorInfoModel!
                                    .realExamScore!
                                    .maxScore!
                                    .toString();
                                context
                                    .read<ScfhsScoreCalculatorCubit>()
                                    .realExamController
                                    .selection = TextSelection.fromPosition(
                                  TextPosition(
                                    offset: context
                                        .read<ScfhsScoreCalculatorCubit>()
                                        .realExamController
                                        .text
                                        .length,
                                  ),
                                );
                              }

                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: customOutlineInputBorder(),
                              focusedBorder: customOutlineInputBorder(),
                              enabledBorder: customOutlineInputBorder(),
                              disabledBorder: customOutlineInputBorder(),
                              errorText:
                                  (context
                                          .read<ScfhsScoreCalculatorCubit>()
                                          .realExamController
                                          .text
                                          .isNotEmpty &&
                                      (int.tryParse(
                                                context
                                                    .read<
                                                      ScfhsScoreCalculatorCubit
                                                    >()
                                                    .realExamController
                                                    .text,
                                              ) ??
                                              0) >
                                          (context
                                                  .read<
                                                    ScfhsScoreCalculatorCubit
                                                  >()
                                                  .calculatorInfoModel!
                                                  .realExamScore!
                                                  .maxScore)!
                                              .toInt())
                                  ? 'Maximum allowed is ${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.realExamScore!.maxScore}' // رسالة الخطأ
                                  : null,
                              hintText:
                                  '${'Maximum score'} ${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.realExamScore!.maxScore}',
                              hintStyle: AppTextStyle.style12W500.copyWith(
                                color: AppColors.darkGreyColor,
                              ),
                              fillColor: AppColors.offwhiteColor,
                              filled: true,
                            ),
                          ),
                        ),

                        TextRowWidget(
                          firstText:
                              '${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.gPA!.name}',
                          secondText:
                              '(${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.gPA!.percentage})',
                        ),
                        GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () =>
                                FocusScope.of(context).unfocus(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: context
                                .read<ScfhsScoreCalculatorCubit>()
                                .gpaController,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.style14W500.copyWith(
                              color: AppColors.iconColorBlack,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty &&
                                  (int.tryParse(value) ?? 0) > 5) {
                                context
                                        .read<ScfhsScoreCalculatorCubit>()
                                        .gpaController
                                        .text =
                                    '5';
                                context
                                    .read<ScfhsScoreCalculatorCubit>()
                                    .gpaController
                                    .selection = TextSelection.fromPosition(
                                  TextPosition(
                                    offset: context
                                        .read<ScfhsScoreCalculatorCubit>()
                                        .gpaController
                                        .text
                                        .length,
                                  ),
                                );
                              }

                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: customOutlineInputBorder(),
                              focusedBorder: customOutlineInputBorder(),
                              enabledBorder: customOutlineInputBorder(),
                              disabledBorder: customOutlineInputBorder(),
                              hintText:
                                  '${'Maximum score'} ${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.gPA!.maxScore}',
                              hintStyle: AppTextStyle.style12W500.copyWith(
                                color: AppColors.darkGreyColor,
                              ),
                              errorText:
                                  (context
                                          .read<ScfhsScoreCalculatorCubit>()
                                          .gpaController
                                          .text
                                          .isNotEmpty &&
                                      (int.tryParse(
                                                context
                                                    .read<
                                                      ScfhsScoreCalculatorCubit
                                                    >()
                                                    .gpaController
                                                    .text,
                                              ) ??
                                              0) >
                                          5)
                                  ? 'Maximum allowed is 5' // رسالة الخطأ
                                  : null,
                              fillColor: AppColors.offwhiteColor,

                              filled: true, // Enables the background color
                            ),
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
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                5.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    '${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.items![index].name}',
                                    style: AppTextStyle.style14W500.copyWith(
                                      fontSize: SizeConfig.responsiveValue(
                                        phone: 14.sp,
                                        tablet: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                5.horizontalSpace,
                                Text(
                                  '(${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.items![index].maxScore} ${"points"})',
                                  style: AppTextStyle.style14W500.copyWith(
                                    color: theme.colorScheme.secondary
                                        .withAlpha(200),
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
                        24.verticalSpace,
                        CustomPrimaryButton(
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
                          text: 'Calculate',
                        ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
