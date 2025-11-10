import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // <--- !! أضف هذا السطر
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';
import 'package:smle/features/q_bank/widgets/create_quiz_widgets/compact_checkbox.dart';

class YearPickerWidget extends StatelessWidget {
  const YearPickerWidget({super.key});

  Future<void> pickYear(BuildContext context, Function(DateTime) onYearSelected) async {
    final currentYear = DateTime(2024);
    final selectedYear = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            // حجم مناسب لعرض السنوات
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              selectedDate: currentYear,
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime);
              },
            ),
          ),
        );
      },
    );

    if (selectedYear != null) {
      onYearSelected(selectedYear);
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QBankCubit, QBankStates>(
      builder: (context, state) {
        final cubit = context.read<QBankCubit>();
        return GestureDetector(
          onTap: () async {
            await pickYear(context, (year) {
              cubit.selectedYearDate = year;
            });

          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              border: Border.all(color: AppColors.greyColor, width: 2.w),
              color: AppColors.thirdColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cubit.selectedYearDate.year}',
                  style: interRegular.copyWith(
                    color: AppColors.forthColor,
                    fontSize: SizeConfig.responsiveValue(
                      phone: 14.sp,
                      tablet: 18.sp,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.calendar,
                  size: SizeConfig.responsiveValue(phone: 30.r, tablet: 24.r),
                  color: AppColors.darkGreyColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}// [ multi_month_selector.dart ] (ملف جديد)


class MultiMonthSelector extends StatelessWidget {
  const MultiMonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم watch ليعاد بناء هذه الـ widget عند تغيير الشهور
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
          final monthName = DateFormat.MMM('en').format(DateTime(2000, monthNumber));

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