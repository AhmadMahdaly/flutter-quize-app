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
import 'package:smle/features/free_q_bank/cubit/free_q_bank_cubit.dart';
import 'package:smle/features/free_q_bank/widgets/create_quiz_widgets/selected_items.dart';
import 'package:smle/features/free_q_bank/widgets/create_quiz_widgets/specialty_list.dart';
import 'package:smle/features/free_q_bank/widgets/create_quiz_widgets/sub_specialty_list.dart';
import 'package:smle/features/free_q_bank/widgets/question_button_widget.dart';
import 'package:smle/features/free_q_bank/widgets/year_picker_widget.dart';
import 'package:smle/features/home/widgets/drawer/drawer_widget.dart';
import 'package:smle/features/q_bank/data/model/start_quiz_model.dart';

class FreeCreateQuizScreen extends StatefulWidget {
  const FreeCreateQuizScreen({super.key, this.istrial});
  final bool? istrial;
  @override
  State<FreeCreateQuizScreen> createState() => _FreeCreateQuizScreenState();
}

class _FreeCreateQuizScreenState extends State<FreeCreateQuizScreen> {
  @override
  void initState() {
    context.read<FreeQBankCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FreeQBankCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const DrawerWidget(),
      appBar: widget.istrial ?? false
          ? CustomAppBar(
              title: 'Free Trial quiz',
              canBack: false,
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: Icon(
                      Icons.menu,
                      color: AppColors.offwhiteColor,
                      size: SizeConfig.responsiveValue(
                        phone: 24.r,
                        tablet: 16.r,
                      ),
                    ),
                  );
                },
              ),
            )
          : CustomAppBar(title: 'create_quiz'.tr(context)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: BlocBuilder<FreeQBankCubit, FreeQBankStates>(
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
              final bool isMonthValid = cubit.selectedMonth > 0;

              final bool canStartQuiz =
                  cubit.selectedSubCategoryIds.isNotEmpty &&
                  isQuestionCountValid &&
                  isMonthValid;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  Text('Select Year:', style: AppTextStyle.style16W700),
                  10.verticalSpace,
                  const YearPickerWidget(),

                  15.verticalSpace,
                  Text('Select Month:', style: AppTextStyle.style16W700),
                  10.verticalSpace,
                  const SingleMonthSelector(),

                  15.verticalSpace,
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

                  if (state is GetSubCategoriesLoadingState)
                    const Center(child: CircularProgressIndicator())
                  else if (cubit.selectedCategoryIds.isNotEmpty &&
                      cubit.aggregatedSubcategories.isEmpty)
                    Center(
                      child: Text(
                        'not_found_sub_specialty'.tr(context),
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
                            'sub_specialty'.tr(context),
                            style: AppTextStyle.style16W700.copyWith(),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'select_all'.tr(context),
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
                      'selected_items'.tr(context),
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
                                    AppRoutes.freeqBankScreen,
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
                        child: QuestionButtonWidget(
                          text: 'start_quiz'.tr(context),
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
            Text(
              'select_all'.tr(context),
              style: AppTextStyle.style14W500.copyWith(),
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
    FreeQBankCubit cubit,
    FreeQBankStates state,
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
            'Selected: ${DateFormat.MMMM('en').format(DateTime(2024, cubit.selectedMonth))} / Year: ${cubit.selectedYearDate.year}',
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
                style: AppTextStyle.style14W500.copyWith(
                  color: AppColors.darkGreyColor.withAlpha(200),
                ),
              ),
              Switch(
                value: cubit.unansweredOnly,
                onChanged: null,
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
