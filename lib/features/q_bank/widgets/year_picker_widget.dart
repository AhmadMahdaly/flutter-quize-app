import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // <--- !! أضف هذا السطر
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';
import 'package:smle/features/q_bank/widgets/create_quiz_widgets/compact_checkbox.dart';

class YearPickerWidget extends StatelessWidget {
  const YearPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<QBankCubit>();
    final List<int> allowedYears = [2024, 2025];

    int dropdownValue = cubit.selectedYearDate.year;
    if (!allowedYears.contains(dropdownValue)) {
      dropdownValue = 2024;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        border: Border.all(color: AppColors.greyColor, width: 2.w),
        color: AppColors.thirdColor,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: dropdownValue,
          isExpanded: true,
          icon: Icon(
            CupertinoIcons.chevron_down,
            size: SizeConfig.responsiveValue(phone: 20.r, tablet: 24.r),
            color: AppColors.darkGreyColor,
          ),
          dropdownColor: AppColors.thirdColor,
          borderRadius: BorderRadius.circular(12.r),
          items: allowedYears.map((int year) {
            return DropdownMenuItem<int>(
              value: year,
              child: Text(
                year.toString(),
                style: AppTextStyle.style14W500.copyWith(
                  color: AppColors.forthColor,
                ),
              ),
            );
          }).toList(),
          onChanged: (int? newYear) {
            if (newYear != null) {
              cubit.selectYear(DateTime(newYear));
            }
          },
        ),
      ),
    );
  }
}

class MultiMonthSelector extends StatelessWidget {
  const MultiMonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<QBankCubit>();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3.0,
          mainAxisSpacing: 4,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final monthNumber = index + 1;
          final monthName = DateFormat.MMM(
            'en',
          ).format(DateTime(2000, monthNumber));

          return CompactCheckbox(
            title: monthName,
            value: cubit.selectedMonths.contains(monthNumber),
            onChanged: (value) {
              cubit.toggleMonthSelection(monthNumber);
            },
          );
        },
      ),
    );
  }
}
