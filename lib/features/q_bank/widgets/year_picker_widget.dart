import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';

class YearPickerWidget extends StatelessWidget {
  const YearPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QBankCubit, QBankStates>(
      builder: (context, state) {
        final cubit=context.read<QBankCubit>();
        return GestureDetector(
          onTap: () async {
            final newDate = await showMonthYearPicker(
              context: context,
              initialDate: context.read<QBankCubit>().pickedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              locale: const Locale('en'),
            );
            if (newDate != null) {
              context.read<QBankCubit>().selectDate(newDate);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.r)),
              border: Border.all(color: AppColors.greyColor, width: 2.w),
              color: AppColors.thirdColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(

                  cubit.isAllMonthsSelected && cubit.isAllYearsSelected
                      ? 'All Time'
                      : DateFormat.yMMM().format(cubit.pickedDate),
                  style: interRegular.copyWith(
                    color: AppColors.darkGreyColor,
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
