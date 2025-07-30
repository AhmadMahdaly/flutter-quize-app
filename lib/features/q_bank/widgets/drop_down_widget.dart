import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    super.key,
    this.onChangeFun,
    required this.onChangeFunMulti,
    this.selectedValue,
    this.selectedValueList,
    required this.selectValueList,
  });
  final ValueChanged? onChangeFun;
  final Function(List<String>) onChangeFunMulti;
  final String? selectedValue;
  final List<String> selectValueList;
  final List<String>? selectedValueList;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.greyColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: selectedValueList != null
          ? DropDownMultiSelect(
              hintStyle: interRegular.copyWith(
                color: AppColors.forthColor,
                fontSize: SizeConfig.responsiveValue(
                  phone: 14.sp,
                  tablet: 18.sp,
                ),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: interRegular.copyWith(
                  color: AppColors.forthColor,
                  fontSize: SizeConfig.responsiveValue(
                    phone: 14.sp,
                    tablet: 18.sp,
                  ),
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down_sharp,
                color: AppColors.darkGreyColor,
                size: SizeConfig.responsiveValue(phone: 30.r, tablet: 24.r),
              ),
              onChanged: onChangeFunMulti,
              options: selectValueList,

              selectedValues: selectedValueList!,
              // whenEmpty: 'select_sub_specialty'.tr(context),
              //   hintStyle: interRegular.copyWith(
              //       color: AppColors.darkGreyColor, fontSize: 14.sp),
              //   selectedValuesStyle: interRegular.copyWith(
              //     overflow: TextOverflow.clip,
              //       color: AppColors.darkGreyColor, fontSize: 14.sp),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedValue,
                icon: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: AppColors.darkGreyColor,
                  size: SizeConfig.responsiveValue(phone: 30.r, tablet: 24.r),
                ),
                items: selectValueList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: interRegular.copyWith(
                        color: AppColors.darkGreyColor,
                        fontSize: SizeConfig.responsiveValue(
                          phone: 14.sp,
                          tablet: 18.sp,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChangeFun,
              ),
            ),
    );
  }
}
