import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';
import 'package:smle/features/q_bank/data/model/startQuizModel.dart';
import 'package:smle/features/q_bank/widgets/create_quiz_widgets/selected_items.dart';
import 'package:smle/features/q_bank/widgets/create_quiz_widgets/specialty_list.dart';
import 'package:smle/features/q_bank/widgets/create_quiz_widgets/sub_specialty_list.dart';
import 'package:smle/features/q_bank/widgets/question_button_widget.dart';
import 'package:smle/features/q_bank/widgets/year_picker_widget.dart';

class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QBankcubit>();

    return Scaffold(
      appBar: CustomAppBar(title: 'create_quiz'.tr(context)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: BlocBuilder<QBankcubit, QBankStates>(
            builder: (context, state) {
              final bool areAllCategoriesSelected =
                  (cubit.categoriesModel?.data?.isNotEmpty ?? false) &&
                  cubit.selectedCategoryIds.length ==
                      cubit.categoriesModel!.data!.length;

              final bool areAllSubCategoriesSelected =
                  cubit.aggregatedSubcategories.isNotEmpty &&
                  cubit.selectedSubCategoryIds.length ==
                      cubit.aggregatedSubcategories.length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  Text(
                    'month'.tr(context),
                    style: interMedium.copyWith(fontSize: 16.sp),
                  ),
                  10.verticalSpace,
                  const YearPickerWidget(),
                  20.verticalSpace,

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

                  _buildSectionHeader(
                    context,
                    title: 'sub_specialty'.tr(context),
                    isAllSelected: areAllSubCategoriesSelected,
                    isEnabled: cubit.aggregatedSubcategories.isNotEmpty,
                    onSelectAllChanged: (value) {
                      cubit.selectAllSubCategories(value ?? false);
                    },
                  ),
                  10.verticalSpace,
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
                    SubSpecialtyList(cubit: cubit),
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
                  50.verticalSpace,

                  Center(
                    child: GestureDetector(
                      onTap: (cubit.selectedSubCategoryIds.isNotEmpty)
                          ? () {
                              context.pushReplacementNamed(
                                Routes.qBankScreen,
                                arguments: StartQuizModel(
                                  context: context,
                                  offset: cubit.offset,
                                  pickedDate: cubit.pickedDate,
                                  selectedSubCategoryId:
                                      cubit.selectedSubCategoryIds,
                                ),
                              );
                            }
                          : null,
                      child: Opacity(
                        opacity: (cubit.selectedSubCategoryIds.isNotEmpty)
                            ? 1.0
                            : 0.5,
                        child: QuestionButtonWidget(
                          text: 'start_quiz'.tr(context),
                        ),
                      ),
                    ),
                  ),
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
}
