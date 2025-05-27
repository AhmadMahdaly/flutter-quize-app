import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/SCFHS_score_calculator/cubit/SCFHS_score_calculator_cubit.dart';
import 'package:smle/features/SCFHS_score_calculator/widgets/calculate_result_dialog.dart';
import 'package:smle/features/SCFHS_score_calculator/widgets/text_row_widget.dart';

import '../../core/shared_widgets/custom_app_bar.dart';

class ScfhsScoreCalculatorScreen extends StatelessWidget {
  ScfhsScoreCalculatorScreen({super.key});
  int? selectedHour; // Move this outside StatefulBuilder to persist the state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'SCFHS_score_calculator'.tr(context),
      ),
      body: SingleChildScrollView(
        child:
            BlocBuilder<ScfhsScoreCalculatorCubit, SCFHSScoreCalculatorStates>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: context
                          .read<ScfhsScoreCalculatorCubit>()
                          .calculatorInfoModel !=
                      null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextRowWidget(
                            firstText:
                                '${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.realExamScore!.name}',
                            secondText:
                                '(${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.realExamScore!.percentage})'),
                        20.verticalSpace,
                        TextFormField(
                          textAlign: TextAlign.center,
                          controller: context.read<ScfhsScoreCalculatorCubit>().realExamController,
                          style: interRegular.copyWith(
                              color: AppColors.darkGreyColor),
                          decoration: InputDecoration(
                              fillColor: AppColors.greyColor
                                  .withOpacity(0.3), // Background color
                              filled: true, // Enables the background color
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.r)),
                                  borderSide: const BorderSide(
                                      color: AppColors.greyColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.r)),
                                  borderSide: const BorderSide(
                                      color: AppColors.greyColor)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.r)),
                                  borderSide: const BorderSide(
                                      color: AppColors.greyColor))),
                        ),
                        20.verticalSpace,
                        Text(
                          '${'maximum_score'.tr(context)} ${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.realExamScore!.maxScore}',
                          style: interRegular.copyWith(
                              fontSize: 14.sp, color: AppColors.darkGreyColor),
                        ),
                        20.verticalSpace,
                        TextRowWidget(
                            firstText:
                                '${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.gPA!.name}',
                            secondText:
                                '(${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.gPA!.percentage})'),
                        20.verticalSpace,
                        TextFormField(
                          controller: context.read<ScfhsScoreCalculatorCubit>().gpaController,
                          textAlign: TextAlign.center,
                          style: interRegular.copyWith(
                              color: AppColors.darkGreyColor),
                          decoration: InputDecoration(
                              fillColor:
                                  AppColors.greyColor, // Background color
                              filled: true, // Enables the background color
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.r)),
                                  borderSide: const BorderSide(
                                      color: AppColors.greyColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.r)),
                                  borderSide: const BorderSide(
                                      color: AppColors.greyColor)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.r)),
                                  borderSide: const BorderSide(
                                      color: AppColors.greyColor))),
                        ),
                        20.verticalSpace,
                        Text(
                          '${'maximum_score'.tr(context)} ${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.gPA!.maxScore}',
                          style: interRegular.copyWith(
                              fontSize: 14.sp, color: AppColors.darkGreyColor),
                        ),
                        20.verticalSpace,
                        TextRowWidget(
                            firstText:
                                '${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.name}',
                            secondText:
                                '(${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.percentage})'),
                        20.verticalSpace,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<ScfhsScoreCalculatorCubit>()
                                              .selectCvCheckList(context
                                                  .read<
                                                      ScfhsScoreCalculatorCubit>()
                                                  .calculatorInfoModel!
                                                  .cVChecklist!
                                                  .items![index]
                                                  .id!);
                                        },
                                        child: Icon(
                                          context.read<ScfhsScoreCalculatorCubit>().selectedCvIds.contains(context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.items![index].id!)?
                                          CupertinoIcons.checkmark_circle:CupertinoIcons.circle,
                                          color: AppColors.secondaryColor,
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      Flexible(
                                          child: Text(
                                        '${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.items![index].name}',
                                        style: interRegular.copyWith(
                                            fontSize: 14.sp),
                                      )),
                                      5.horizontalSpace,
                                      Text(
                                        '(${context.read<ScfhsScoreCalculatorCubit>().calculatorInfoModel!.cVChecklist!.items![index].maxScore} ${"points".tr(context)})',
                                        style: interRegular.copyWith(
                                            fontSize: 14.sp),
                                      )
                                    ],
                                  ),
                              separatorBuilder: (context, index) =>
                                  15.verticalSpace,
                              itemCount: context
                                  .read<ScfhsScoreCalculatorCubit>()
                                  .calculatorInfoModel!
                                  .cVChecklist!
                                  .items!
                                  .length),
                        20.verticalSpace,
                        Center(
                          child: TextButton(
                            onPressed: () {
                              context.read<ScfhsScoreCalculatorCubit>().getCalculateResult().then((onValue){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    if(onValue!=null){
                                      return  CalculateResultDialog(score:
                                      onValue.data!,);
                                    }else
                                      {
                                    return const SizedBox();
                                  }
                                    },
                                );
                              });

                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.secondaryColor),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: MaterialStateProperty.all(
                                  const Size(150, 52)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            child: Text(
                              'calculate'.tr(context),
                              style: interRegular.copyWith(
                                color: AppColors.thirdColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        )
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
