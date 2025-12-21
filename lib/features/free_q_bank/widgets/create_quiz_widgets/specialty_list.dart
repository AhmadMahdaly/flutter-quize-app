import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/free_q_bank/cubit/free_q_bank_cubit.dart';
import 'package:smle/features/free_q_bank/widgets/create_quiz_widgets/compact_checkbox.dart';

class SpecialtyList extends StatelessWidget {
  const SpecialtyList({super.key, required this.cubit});
  final FreeQBankCubit cubit;
  @override
  Widget build(BuildContext context) {
    final categories = cubit.categoriesModel!.data!;
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CompactCheckbox(
            title: category.name ?? '',
            value: cubit.selectedCategoryIds.contains(category.id),
            onChanged: (bool? value) {
              cubit.toggleCategorySelection(category.id!, category.name!);
            },
          );
        },
      ),
    );
  }
}
