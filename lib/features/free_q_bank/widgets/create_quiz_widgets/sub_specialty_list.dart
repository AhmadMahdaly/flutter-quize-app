import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/free_q_bank/cubit/free_q_bank_cubit.dart';
import 'package:smle/features/free_q_bank/widgets/create_quiz_widgets/compact_checkbox.dart';

class SubSpecialtyList extends StatelessWidget {
  const SubSpecialtyList({super.key, required this.cubit});
  final FreeQBankCubit cubit;
  @override
  Widget build(BuildContext context) {
    final subCategories = cubit.aggregatedSubcategories;
    if (cubit.selectedCategoryIds.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20.h),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            'Select Specialty first',
            style: AppTextStyle.style14W500.copyWith(
              color: AppColors.darkGreyColor,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          final subCategory = subCategories[index];
          return CompactCheckbox(
            title: subCategory.name ?? '',
            value: cubit.selectedSubCategoryIds.contains(subCategory.id),
            onChanged: (bool? value) {
              cubit.toggleSubCategorySelection(
                subCategory.id!,
                subCategory.name!,
              );
            },
          );
        },
      ),
    );
  }
}
