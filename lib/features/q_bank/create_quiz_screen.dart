import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';
import 'package:smle/features/q_bank/data/model/start_quiz_model.dart';
import 'package:smle/features/q_bank/widgets/create_quiz_widgets/selected_items.dart';
import 'package:smle/features/q_bank/widgets/create_quiz_widgets/specialty_list.dart';
import 'package:smle/features/q_bank/widgets/create_quiz_widgets/sub_specialty_list.dart';
import 'package:smle/features/q_bank/widgets/question_button_widget.dart';
import 'package:smle/features/q_bank/widgets/year_picker_widget.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key, this.istrial});
  final bool? istrial;
  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QBankCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: widget.istrial ?? false
          ? const CustomAppBar(title: 'Free Trial quiz', canBack: false)
          : const CustomAppBar(title: 'Create quiz'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: BlocBuilder<QBankCubit, QBankStates>(
            builder: (context, state) {
              final bool areAllCategoriesSelected =
                  (cubit.categoriesModel?.data?.isNotEmpty ?? false) &&
                  cubit.selectedCategoryIds.length ==
                      cubit.categoriesModel!.data!.length;

              final bool areAllSubCategoriesSelected =
                  cubit.aggregatedSubcategories.isNotEmpty &&
                  cubit.selectedSubCategoryIds.length ==
                      cubit.aggregatedSubcategories.length;

              final bool isQuestionCountValid =
                  cubit.numberOfQuestionsController.text.isNotEmpty &&
                  (int.tryParse(cubit.numberOfQuestionsController.text) ?? 0) >
                      0 &&
                  (int.tryParse(cubit.numberOfQuestionsController.text) ?? 0) <=
                      cubit.questionsCount;
              final bool isMonthValid =
                  cubit.isAllYearsSelected ||
                  cubit.isAllMonthsSelected ||
                  cubit.selectedMonths.isNotEmpty;
              final bool canStartQuiz =
                  cubit.selectedSubCategoryIds.isNotEmpty &&
                  isQuestionCountValid &&
                  isMonthValid;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  Row(
                    children: [
                      Text('Year', style: AppTextStyle.style16W700),
                      const Spacer(),
                      Text('All Years', style: AppTextStyle.style14W500),
                      Checkbox(
                        value: cubit.isAllYearsSelected,
                        onChanged: (value) {
                          cubit.toggleAllYears(value ?? false);
                        },
                        activeColor: AppColors.primaryColor,
                      ),
                    ],
                  ),
                  if (!cubit.isAllYearsSelected) const YearPickerWidget(),
                  10.verticalSpace,
                  if (!cubit.isAllYearsSelected) ...[
                    // --- صف "All Months" ---
                    Row(
                      children: [
                        Text('Month', style: AppTextStyle.style16W700),
                        const Spacer(),
                        Text('All Months', style: AppTextStyle.style14W500),
                        Checkbox(
                          value: cubit.isAllMonthsSelected,
                          onChanged: (value) {
                            cubit.toggleAllMonths(value ?? false);
                          },
                          activeColor: AppColors.primaryColor,
                        ),
                      ],
                    ),

                    if (!cubit.isAllMonthsSelected) ...[
                      15.verticalSpace,
                      Text(
                        'Select Months:', // (يمكنك ترجمتها)
                        style: AppTextStyle.style14W700.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      10.verticalSpace,
                      const MultiMonthSelector(), // (الـ Widget من الرد السابق)
                    ],
                  ],

                  12.verticalSpace,
                  _buildSectionHeader(
                    context,
                    title: 'Specialty',
                    isAllSelected: areAllCategoriesSelected,
                    isEnabled: cubit.categoriesModel?.data?.isNotEmpty ?? false,
                    onSelectAllChanged: (value) {
                      cubit.selectAllCategories(value ?? false);
                    },
                  ),
                  10.verticalSpace,
                  if (cubit.categoriesModel != null)
                    SpecialtyList(cubit: cubit)
                  else
                    const Center(child: CircularProgressIndicator()),
                  20.verticalSpace,
                  // _buildSectionHeader(
                  //   context,
                  //   title: 'sub_specialty'.tr(context),
                  //   isAllSelected: areAllSubCategoriesSelected,
                  //   isEnabled: cubit.aggregatedSubcategories.isNotEmpty,
                  //   onSelectAllChanged: (value) {
                  //     cubit.selectAllSubCategories(value ?? false);
                  //   },
                  // ),
                  // 10.verticalSpace,
                  if (state is GetSubCategoriesLoadingState)
                    const Center(child: CircularProgressIndicator())
                  else if (cubit.selectedCategoryIds.isNotEmpty &&
                      cubit.aggregatedSubcategories.isEmpty)
                    Center(
                      child: Text(
                        'Not found Sub Specialty',
                        style: AppTextStyle.style14W500.copyWith(
                          color: AppColors.darkGreyColor,
                        ),
                      ),
                    )
                  else
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      collapsedIconColor: AppColors.forthColor,
                      iconColor: AppColors.forthColor,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sub Specialty',
                            style: AppTextStyle.style16W700.copyWith(),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Select all',
                                style: AppTextStyle.style14W500.copyWith(),
                              ),
                              Checkbox(
                                value: areAllSubCategoriesSelected,
                                onChanged:
                                    cubit.aggregatedSubcategories.isNotEmpty
                                    ? (value) => cubit.selectAllSubCategories(
                                        value ?? false,
                                      )
                                    : null,
                                activeColor: AppColors.primaryColor,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          ),
                        ],
                      ),
                      children: [SubSpecialtyList(cubit: cubit)],
                    ),
                  20.verticalSpace,
                  _buildAdvancedFilters(context, cubit, state),
                  20.verticalSpace,
                  ExpansionTile(
                    collapsedIconColor: AppColors.forthColor,
                    iconColor: AppColors.forthColor,
                    title: Text(
                      'Selected items',
                      style: AppTextStyle.style14W700.copyWith(
                        fontSize: SizeConfig.responsiveValue(
                          phone: 16.sp,
                          tablet: 20.sp,
                        ),
                      ),
                    ),
                    children: [SelectedItemsWidget(cubit: cubit)],
                  ),
                  16.verticalSpace,
                  Center(
                    child: GestureDetector(
                      onTap: canStartQuiz
                          ? () {
                              cubit.getQuestions().then((_) {
                                if (cubit.qBankModel != null &&
                                    (cubit.qBankModel?.data?.isNotEmpty ??
                                        false)) {
                                  context.pushReplacementNamed(
                                    AppRoutes.qBankScreen,
                                    arguments: StartQuizModel(
                                      qBankModel: cubit.qBankModel,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No Questions Found'),
                                    ),
                                  );
                                }
                              });
                            }
                          : null,
                      child: Opacity(
                        opacity: canStartQuiz ? 1.0 : 0.2,
                        child: const CustomQuestionButtonWidget(
                          text: 'Start quiz',
                        ),
                      ),
                    ),
                  ),
                  24.verticalSpace,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required bool isAllSelected,
    required bool isEnabled,
    required ValueChanged<bool?> onSelectAllChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.style14W700.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select all', style: AppTextStyle.style14W500.copyWith()),
            Checkbox(
              value: isAllSelected,
              onChanged: isEnabled ? onSelectAllChanged : null,
              activeColor: AppColors.primaryColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvancedFilters(
    BuildContext context,
    QBankCubit cubit,
    QBankStates state,
  ) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cubit.isAllYearsSelected
                ? 'Selected: All Time' // حالة "كل السنوات"
                : 'Selected: ${cubit.isAllMonthsSelected ? 'All Months' : 'Months: ${cubit.selectedMonths.join(', ')}'} / Year: ${cubit.selectedYearDate.year}',
            style: AppTextStyle.style14W700.copyWith(
              fontSize: 14.sp,
              color: AppColors.secondaryColor,
            ),
            textAlign: TextAlign.start,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Unanswered Questions Only',
                style: AppTextStyle.style14W700.copyWith(fontSize: 15.sp),
              ),
              Switch(
                value: cubit.unansweredOnly,
                onChanged: (value) {
                  cubit.toggleUnansweredOnly(value);
                },
                activeThumbColor: AppColors.primaryColor,
              ),
            ],
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (state is GetQuestionsCountLoadingState)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Expanded(
                  child: Text(
                    '${'Available'}: ${cubit.questionsCount}',
                    style: AppTextStyle.style14W700.copyWith(fontSize: 15.sp),
                  ),
                ),
            ],
          ),
          15.verticalSpace,
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: TextField(
              controller: cubit.numberOfQuestionsController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onEditingComplete: () => FocusScope.of(context).unfocus(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Enter Number of questions',
                labelStyle: const TextStyle(color: AppColors.primaryColor),
                hintText: '${'Max'}: ${cubit.questionsCount}',
                hintStyle: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 12.sp,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                ),
                errorText:
                    (cubit.numberOfQuestionsController.text.isNotEmpty &&
                        (int.tryParse(cubit.numberOfQuestionsController.text) ??
                                0) >
                            cubit.questionsCount)
                    ? 'Error: Max questions'
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
