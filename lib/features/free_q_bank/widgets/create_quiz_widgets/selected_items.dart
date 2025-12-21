import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/free_q_bank/cubit/free_q_bank_cubit.dart';

class SelectedItemsWidget extends StatelessWidget {
  const SelectedItemsWidget({super.key, required this.cubit});
  final FreeQBankCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.offwhiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor),
      ),
      constraints: BoxConstraints(minHeight: 100.h),
      child: cubit.selectedSubCategoryNames.isNotEmpty
          ? Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              children: cubit.selectedSubCategoryNames
                  .map(
                    (name) => Chip(
                      label: Text(
                        name,
                        style: AppTextStyle.style14W500.copyWith(),
                      ),
                      onDeleted: () {
                        final subCategory = cubit.aggregatedSubcategories
                            .firstWhere((element) => element.name == name);
                        cubit.toggleSubCategorySelection(
                          subCategory.id!,
                          subCategory.name!,
                        );
                      },
                    ),
                  )
                  .toList(),
            )
          : Center(
              child: Text(
                'no_items_selected'.tr(context),
                style: AppTextStyle.style14W500.copyWith(
                  color: AppColors.darkGreyColor,
                ),
              ),
            ),
    );
  }
}
