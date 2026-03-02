import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart'; // 1. استيراد المكتبة
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/free_q_bank/cubit/free_q_bank_cubit.dart';
import 'package:smle/features/free_q_bank/widgets/create_quiz_widgets/selected_items.dart';
import 'package:smle/features/free_q_bank/widgets/create_quiz_widgets/specialty_list.dart';
import 'package:smle/features/free_q_bank/widgets/create_quiz_widgets/sub_specialty_list.dart';
import 'package:smle/features/free_q_bank/widgets/year_picker_widget.dart';
import 'package:smle/features/home/widgets/drawer/drawer_widget.dart';
import 'package:smle/features/q_bank/data/model/start_quiz_model.dart';
import 'package:smle/features/q_bank/widgets/question_button_widget.dart';

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
          : const CustomAppBar(title: 'Create quiz'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: BlocBuilder<FreeQBankCubit, FreeQBankStates>(
            builder: (context, state) {
              // تحديد حالة التحميل الكلية للشاشة
              final bool isLoading = state is GetCategoriesLoadingState
              //  || state is GetSubCategoriesLoadingState
              ;

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

              // 2. تغليف المحتوى بـ Skeletonizer
              return Skeletonizer(
                enabled: isLoading,
                child: Column(
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
                      title: 'Specialty',
                      isAllSelected: areAllCategoriesSelected,
                      isEnabled:
                          cubit.categoriesModel?.data?.isNotEmpty ?? false,
                      onSelectAllChanged: (value) {
                        cubit.selectAllCategories(value ?? false);
                      },
                    ),
                    10.verticalSpace,

                    if (cubit.categoriesModel != null)
                      SpecialtyList(cubit: cubit)
                    else
                      const Center(child: LinearProgressIndicator()),

                    20.verticalSpace,
                    if (state is GetSubCategoriesLoadingState)
                      const Center(child: LinearProgressIndicator())
                    else if (cubit.selectedCategoryIds.isNotEmpty &&
                        cubit.aggregatedSubcategories.isEmpty &&
                        !isLoading)
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
                        onTap: (canStartQuiz && !isLoading)
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
                          child: const CustomQuestionButtonWidget(
                            text: 'Start quiz',
                          ),
                        ),
                      ),
                    ),
                    24.verticalSpace,
                  ],
                ),
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
            'Selected: ${DateFormat.MMMM().format(DateTime(2024, cubit.selectedMonth))} / Year: ${cubit.selectedYearDate.year}',
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
              // إضافة الـ Formatter لمنع إدخال غير الأرقام
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Enter Number of questions',
                labelStyle: const TextStyle(color: AppColors.primaryColor),
                hintText: 'Max: 10', // تحديث النص التوضيحي ليظهر 10
                hintStyle: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 12.sp,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                ),
                // منطق التحقق من القيمة (لا تزيد عن 10)
                errorText:
                    (cubit.numberOfQuestionsController.text.isNotEmpty &&
                        (int.tryParse(cubit.numberOfQuestionsController.text) ??
                                0) >
                            10)
                    ? 'Maximum allowed is 10' // رسالة الخطأ
                    : null,
              ),
              onChanged: (value) {
                if (value.isNotEmpty && (int.tryParse(value) ?? 0) > 10) {
                  cubit.numberOfQuestionsController.text = '10';
                  cubit.numberOfQuestionsController.selection =
                      TextSelection.fromPosition(
                        TextPosition(
                          offset: cubit.numberOfQuestionsController.text.length,
                        ),
                      );
                }

                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
