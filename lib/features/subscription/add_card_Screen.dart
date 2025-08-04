import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/subscription/cubit/Subscription_cubit.dart';

class AddCardScreen extends StatelessWidget {
  AddCardScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubscriptionCubit>();

    return Scaffold(
      appBar: CustomAppBar(title: 'new_card'.tr(context)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.verticalSpace,
                Text(
                  'enter_credit_card_info'.tr(context),
                  style: interBold.copyWith(
                    fontSize: SizeConfig.responsiveValue(
                      phone: 16.sp,
                      tablet: 20.sp,
                    ),
                  ),
                ),
                24.verticalSpace,
                Center(
                  child: TextButton(
                    onPressed: () => cubit.scanCard(context),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        AppColors.secondaryColor,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: WidgetStateProperty.all(
                        Size(double.infinity, 52.h),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.camera,
                          color: AppColors.greyColor,
                          size: 30.sp,
                        ),
                        5.horizontalSpace,
                        Text(
                          'scan_card'.tr(context),
                          style: interBold.copyWith(
                            color: AppColors.greyColor,
                            fontSize: SizeConfig.responsiveValue(
                              phone: 16.sp,
                              tablet: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                30.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 1.sp,
                        color: AppColors.darkGreyColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        'or'.tr(context),
                        style: interRegular.copyWith(
                          color: AppColors.darkGreyColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        height: 1.sp,
                        color: AppColors.darkGreyColor,
                      ),
                    ),
                  ],
                ),
                30.verticalSpace,
                _buildLabeledField(
                  context,
                  label: 'card_number'.tr(context),
                  controller: cubit.cardIdController,
                  validator: (value) => value!.isEmpty
                      ? "${'card_number'.tr(context)} ${'must_entered'.tr(context)}"
                      : null,
                ),
                20.verticalSpace,
                _buildLabeledField(
                  context,
                  label: 'password'.tr(context),
                  controller: cubit.passwordController,
                  obscureText: true,
                  validator: (value) => value!.isEmpty
                      ? "${'password'.tr(context)} ${'must_entered'.tr(context)}"
                      : null,
                ),
                20.verticalSpace,
                _buildLabeledField(
                  context,
                  label: 'cvv'.tr(context),
                  controller: cubit.cvvController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty
                      ? "${'cvv'.tr(context)} ${'must_entered'.tr(context)}"
                      : null,
                ),
                20.verticalSpace,
                TextFormField(
                  controller: cubit.expiryDateController,
                  readOnly: true, // يمنع الكتابة اليدوية
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      final String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(pickedDate);
                      cubit.expiryDateController.text = formattedDate;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '2025-03-23', // شكل التاريخ المتوقع
                    labelText: 'expiration_date'.tr(context),
                    fillColor: AppColors.greyColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                  ),
                  style: interRegular.copyWith(color: AppColors.darkGreyColor),
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "${'expiration_date'.tr(context)} ${'must_entered'.tr(context)}";
                    }
                    return null;
                  },
                ),
                30.verticalSpace,
                Center(
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cubit.addCard();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        AppColors.secondaryColor,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: WidgetStateProperty.all(Size(150.w, 52.h)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                    ),
                    child: Text(
                      'add_card'.tr(context),
                      style: interBold.copyWith(
                        color: AppColors.greyColor,
                        fontSize: SizeConfig.responsiveValue(
                          phone: 16.sp,
                          tablet: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: interMedium.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
          ),
        ),
        10.verticalSpace,
        TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          style: interRegular.copyWith(color: AppColors.darkGreyColor),
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            fillColor: AppColors.greyColor.withOpacity(0.3),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
              borderSide: const BorderSide(color: AppColors.greyColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
              borderSide: const BorderSide(color: AppColors.greyColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
              borderSide: const BorderSide(color: AppColors.greyColor),
            ),
          ),
        ),
      ],
    );
  }
}
