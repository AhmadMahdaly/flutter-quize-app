import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/free_q_bank/cubit/free_q_bank_cubit.dart';

class YearPickerWidget extends StatefulWidget {
  const YearPickerWidget({super.key});

  @override
  State<YearPickerWidget> createState() => _YearPickerWidgetState();
}

class _YearPickerWidgetState extends State<YearPickerWidget> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<FreeQBankCubit>();
    if (cubit.yearsModel == null) {
      cubit.getYears();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FreeQBankCubit, FreeQBankStates>(
      builder: (context, state) {
        final cubit = context.read<FreeQBankCubit>();

        final List<int> allPossibleYears =
            cubit.yearsModel?.data
                ?.map((e) => e.year ?? 0)
                .where((year) => year != 0)
                .toSet()
                .toList() ??
            [];

        allPossibleYears.sort((a, b) => b.compareTo(a));
        final List<int> enabledYears = cubit.availableYears;
        if (allPossibleYears.isEmpty) {
          return Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              border: Border.all(color: AppColors.greyColor, width: 2.w),
              color: AppColors.thirdColor,
            ),
            child: const Center(child: CupertinoActivityIndicator()),
          );
        }

        final int dropdownValue = cubit.selectedYearDate.year;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            border: Border.all(color: AppColors.greyColor, width: 2.w),
            color: AppColors.thirdColor,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: allPossibleYears.contains(dropdownValue)
                  ? dropdownValue
                  : null,
              isExpanded: true,
              icon: Icon(
                CupertinoIcons.chevron_down,
                size: SizeConfig.responsiveValue(phone: 20.r, tablet: 24.r),
                color: AppColors.primaryColor,
              ),
              dropdownColor: AppColors.thirdColor,
              borderRadius: BorderRadius.circular(12.r),

              items: allPossibleYears.map((int year) {
                final bool isAvailable = enabledYears.contains(year);

                return DropdownMenuItem<int>(
                  value: year,

                  child: Text(
                    year.toString(),
                    style: AppTextStyle.style14W500.copyWith(
                      color: isAvailable
                          ? AppColors.forthColor
                          : Colors.grey.shade400,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (int? newYear) {
                if (newYear != null && enabledYears.contains(newYear)) {
                  cubit.selectYear(newYear);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This year is not available right now'),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class SingleMonthSelector extends StatelessWidget {
  const SingleMonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<FreeQBankCubit>();

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

          final isSelected = cubit.selectedMonth == monthNumber;

          final isAvailable = cubit.availableMonths.contains(monthNumber);

          return InkWell(
            onTap: isAvailable
                ? () {
                    cubit.toggleMonthSelection(monthNumber);
                  }
                : null,
            borderRadius: BorderRadius.circular(8.r),
            child: Opacity(
              opacity: isAvailable ? 1.0 : 0.4,
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
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
