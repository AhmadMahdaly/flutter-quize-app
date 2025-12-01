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

  Future<void> pickYear(
    BuildContext context,
    Function(DateTime) onYearSelected,
  ) async {
    // 1. نأخذ السنة الحالية من الكيوبت لكي يفتح عليها الـ Picker
    final cubit = context.read<QBankCubit>();

    final selectedYear = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              // 2. هنا نحدد البداية والنهاية كما طلبت (2024 و 2025 فقط)
              firstDate: DateTime(2024),
              lastDate: DateTime(2025),

              // جعل الـ Picker يفتح على السنة المختارة حالياً
              selectedDate: cubit.selectedYearDate,

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
              // 3. (مهم جداً) نستخدم الدالة الموجودة في الكيوبت بدلاً من التساوي المباشر
              // هذه الدالة تقوم بعمل emit وتحديث الواجهة
              cubit.selectYear(year);
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
                  // عرض السنة المختارة
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
}

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
