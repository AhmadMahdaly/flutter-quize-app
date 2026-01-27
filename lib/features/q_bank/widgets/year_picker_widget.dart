import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // <--- !! أضف هذا السطر
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';

class YearPickerWidget extends StatefulWidget {
  const YearPickerWidget({super.key});

  @override
  State<YearPickerWidget> createState() => _YearPickerWidgetState();
}

class _YearPickerWidgetState extends State<YearPickerWidget> {
  @override
  void initState() {
    super.initState();
    context.read<QBankCubit>().getYears();
  }

  @override
  Widget build(BuildContext context) {
    // final cubit = context.watch<QBankCubit>();
    // final List<int> allowedYears = [2024, 2025];

    // int dropdownValue = cubit.selectedYearDate.year;
    // if (!allowedYears.contains(dropdownValue)) {
    //   dropdownValue = 2024;
    // }

    return BlocBuilder<QBankCubit, QBankStates>(
      builder: (context, state) {
        final cubit = context.read<QBankCubit>();
        final List<int> allowedYears =
            cubit.yearsModel?.data?.map((e) => e.year!).toList() ?? [];

        int? dropdownValue;
        if (allowedYears.isNotEmpty) {
          dropdownValue = allowedYears.contains(cubit.selectedYearDate.year)
              ? cubit.selectedYearDate.year
              : allowedYears.first;
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
      },
    );
  }
}

class MultiMonthSelector extends StatelessWidget {
  const MultiMonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // تأكد من استخدام الـ Cubit الصحيح (QBankCubit)
    final cubit = context.watch<QBankCubit>();

    return Container(
      padding: EdgeInsets.all(8.r), // إضافة الـ Padding ليطابق التصميم الآخر
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5, // تم التعديل ليطابق التصميم المطلوب
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
        ),
        itemBuilder: (context, index) {
          final monthNumber = index + 1;
          final monthName = DateFormat.MMM(
            'en',
          ).format(DateTime(2000, monthNumber));

          // التحقق من وجود الشهر داخل القائمة (Multi-selection logic)
          final isSelected = cubit.selectedMonths.contains(monthNumber);

          return InkWell(
            onTap: () {
              cubit.toggleMonthSelection(monthNumber);
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey.shade400,
                ),
              ),
              child: Text(
                monthName,
                style: AppTextStyle.style14W500.copyWith(
                  color: isSelected ? Colors.white : AppColors.forthColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
