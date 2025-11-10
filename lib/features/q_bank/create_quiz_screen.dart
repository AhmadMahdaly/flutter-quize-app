import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
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
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  @override
  void initState() {
context.read<QBankCubit>().init();    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QBankCubit>();

    return Scaffold( resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: 'create_quiz'.tr(context)),
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
              final bool isMonthValid = cubit.isAllYearsSelected || cubit.isAllMonthsSelected || cubit.selectedMonths.isNotEmpty;
              final bool canStartQuiz = cubit.selectedSubCategoryIds.isNotEmpty &&
                  isQuestionCountValid &&
                  isMonthValid;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  Row(
                    children: [
                      Text(
                        'Year',
                        style: interMedium.copyWith(fontSize: 16.sp),
                      ),
                      const Spacer(),
                      Text(
                        'All Years',
                        style: interRegular.copyWith(fontSize: 14.sp),
                      ),
                      Checkbox(
                        value: cubit.isAllYearsSelected,
                        onChanged: (value) {
                          cubit.toggleAllYears(value ?? false);
                        },
                        activeColor: AppColors.primaryColor,
                      ),
                    ],
                  ), const YearPickerWidget(),  10.verticalSpace,
                  if (!cubit.isAllYearsSelected) ...[
                    // --- صف "All Months" ---
                    Row(
                      children: [
                        Text('Month', style: interMedium.copyWith(fontSize: 16.sp)),
                        const Spacer(),
                        Text('All Months', style: interRegular.copyWith(fontSize: 14.sp)),
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
                        style: interMedium.copyWith(fontSize: 16.sp),
                      ),
                      10.verticalSpace,
                      const MultiMonthSelector(), // (الـ Widget من الرد السابق)
                    ],
                  ],


                  12.verticalSpace,
                  _buildSectionHeader(
                    context,
                    title: 'specialty'.tr(context),
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
                        'not_found_sub_specialty'.tr(context),
                        style: interRegular.copyWith(
                          fontSize: SizeConfig.responsiveValue(
                            phone: 14.sp,
                            tablet: 18.sp,
                          ),
                          color: AppColors.darkGreyColor,
                        ),
                      ),
                    )
                  else
                    ExpansionTile(
                      tilePadding:EdgeInsets.zero,
                      collapsedIconColor: AppColors.forthColor,
                      iconColor: AppColors.forthColor,
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'sub_specialty'.tr(context),
                            style: interMedium.copyWith(
                              fontSize: SizeConfig.responsiveValue(
                                phone: 16.sp,
                                tablet: 20.sp,
                              ),
                            ),
                          ), Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'select_all'.tr(context),
                                style: interRegular.copyWith(
                                  fontSize: SizeConfig.responsiveValue(
                                    phone: 14.sp,
                                    tablet: 16.sp,
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: areAllSubCategoriesSelected,
                                onChanged: cubit.aggregatedSubcategories.isNotEmpty ?(value)=> cubit.selectAllSubCategories(value ?? false) : null,
                                activeColor: AppColors.primaryColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      'selected_items'.tr(context),
                      style: interMedium.copyWith(
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
                                    Routes.qBankScreen,
                                    arguments: StartQuizModel(
                                      qBankModel: cubit.qBankModel,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'no_questions_found'.tr(context),
                                      ),
                                    ),
                                  );
                                }
                              });
                            }
                          : null,
                      child: Opacity(
                        opacity: canStartQuiz ? 1.0 : 0.2,
                        child: QuestionButtonWidget(
                          text: 'start_quiz'.tr(context),
                        ),
                      ),
                    ),
                  ),
               24.verticalSpace ],
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
          style: interMedium.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'select_all'.tr(context),
              style: interRegular.copyWith(
                fontSize: SizeConfig.responsiveValue(
                  phone: 14.sp,
                  tablet: 16.sp,
                ),
              ),
            ),
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
      child: Column(crossAxisAlignment :CrossAxisAlignment.start,
        children: [
          Text(
            cubit.isAllYearsSelected
                ? 'Selected: All Time' // حالة "كل السنوات"
                : 'Selected: ${cubit.isAllMonthsSelected ? 'All Months' : 'Months: ${cubit.selectedMonths.join(', ')}'} / Year: ${cubit.selectedYearDate.year}',
            style: interMedium.copyWith(fontSize: 14.sp, color: AppColors.secondaryColor),
            textAlign: TextAlign.start,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Unanswered Questions Only',
                style: interMedium.copyWith(fontSize: 15.sp),
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
              Expanded(
                child: Text(
                  '${'Available'}: ${cubit.questionsCount}',
                  style: interMedium.copyWith(fontSize: 15.sp),
                ),
              ),
              if (state is GetQuestionsCountLoadingState)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
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
                labelStyle: TextStyle(color: AppColors.primaryColor),
                hintText: '${'Max'}: ${cubit.questionsCount}',
                hintStyle: TextStyle(color:AppColors.secondaryColor, fontSize: 12.sp),
                border:  OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.r))),
                errorText:
                    (cubit.numberOfQuestionsController.text.isNotEmpty &&
                        (int.tryParse(cubit.numberOfQuestionsController.text) ??
                                0) >
                            cubit.questionsCount)
                    ? 'error_max_questions'.tr(context)
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
