import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final cubit = context.read<QBankCubit>();
    if (cubit.yearsModel == null) {
      cubit.getYears();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QBankCubit, QBankStates>(
      builder: (context, state) {
        final cubit = context.read<QBankCubit>();
        final List<int> allowedYears = cubit.availableYears;

        // 1. عرض مؤشر تحميل أثناء جلب البيانات
        if (state is GetYearsLoadingState || allowedYears.isEmpty) {
          return Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              border: Border.all(color: AppColors.greyColor, width: 2.w),
              color: AppColors.thirdColor.withAlpha(50),
            ),
            child: const Center(child: CupertinoActivityIndicator()),
          );
        }

        // 2. تحديد السنة المحددة برمجياً لتجنب الأخطاء
        final int dropdownValue = cubit.selectedYearDate.year;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            // border: Border.all(color: AppColors.greyColor, width: 2.w),
            color: AppColors.offwhiteColor,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: dropdownValue,
              isExpanded: true,
              icon: Icon(
                CupertinoIcons.chevron_down,
                size: SizeConfig.responsiveValue(phone: 20.r, tablet: 24.r),
                color: AppColors.primaryColor,
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
    final cubit = context.watch<QBankCubit>();
    final List<int> availableMonths = cubit.availableMonthsForSelectedYear;

    // عرض اللودينج إذا لم يتم تحميل السنوات والشهور بعد
    if (cubit.yearsModel == null) {
      return const Center(child: CupertinoActivityIndicator());
    }

    return Container(
      padding: EdgeInsets.all(8.r),
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
          childAspectRatio: 2.5,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
        ),
        itemBuilder: (context, index) {
          final monthNumber = index + 1;
          final monthName = DateFormat.MMM().format(
            DateTime(2000, monthNumber),
          );

          final isSelected = cubit.selectedMonths.contains(monthNumber);
          final isAvailable = availableMonths.contains(monthNumber);

          return InkWell(
            onTap: isAvailable
                ? () {
                    cubit.toggleMonthSelection(monthNumber);
                  }
                : null,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : (isAvailable
                          ? Colors.transparent
                          : AppColors.offwhiteColor.withAlpha(50)),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : (isAvailable
                            ? AppColors.primaryColor.withAlpha(200)
                            : Colors.grey.shade200),
                ),
              ),
              child: Text(
                monthName,
                style: AppTextStyle.style14W500.copyWith(
                  color: isSelected
                      ? AppColors.thirdColor
                      : (isAvailable
                            ? AppColors.primaryColor
                            : Colors.grey.shade400),
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
