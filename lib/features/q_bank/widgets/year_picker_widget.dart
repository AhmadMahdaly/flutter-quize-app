import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class YearPickerWidget extends StatelessWidget {
  const YearPickerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QBankcubit, QBankStates>(
  builder: (context, state) {
    return GestureDetector(
      onTap: () async {
        final newDate = await showMonthYearPicker(
          context: context,
          initialDate: context.read<QBankcubit>().pickedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime( 2100),
          locale: const Locale('en'),
        );
        if (newDate != null) {
          context.read<QBankcubit>().selectDate(newDate);
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
            DateFormat.yMMM().format(context.read<QBankcubit>().pickedDate),
              style: interRegular.copyWith(
                color: AppColors.darkGreyColor,
                fontSize: 14.sp,
              ),
            ),
            Icon(
              CupertinoIcons.calendar,
              size: 30.r,
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
