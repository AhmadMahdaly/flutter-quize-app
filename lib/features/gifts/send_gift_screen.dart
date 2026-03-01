import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/subscription/cubit/subscription_cubit.dart';
import 'package:smle/features/subscription/widgets/pay_done_dialog.dart';

class SendGiftScreen extends StatefulWidget {
  const SendGiftScreen({super.key});

  @override
  State<SendGiftScreen> createState() => _SendGiftScreenState();
}

class _SendGiftScreenState extends State<SendGiftScreen> {
  final TextEditingController emailController = TextEditingController();
  int? selectedPackageId;
  bool isEmailVerified = false;
  bool _isAutoPaying = false;
  final TextEditingController codeController = TextEditingController();
  late SubscriptionCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = context.read<SubscriptionCubit>();
    cubit.getPackages();
    cubit.currentReceiverId = null;
  }

  @override
  void dispose() {
    cubit.giftCheckoutData = null;
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Send gift'),
      body: BlocConsumer<SubscriptionCubit, SubscriptionStates>(
        listener: (context, state) {
          if (state is CheckEmailSuccessState) {
            if (_isAutoPaying && selectedPackageId != null) {
              final selectedPkg = cubit.packagesModel?.data?.firstWhere(
                (p) => p.id == selectedPackageId,
              );

              if (selectedPkg != null) {
                // 1. إضافة نفس عملية التحقق من السعر بعد الخصم هنا أيضاً
                final double finalAmount =
                    (cubit.giftCheckoutData?.data?.totalAfterCodeDiscount !=
                        null)
                    ? cubit.giftCheckoutData!.data!.totalAfterCodeDiscount!
                          .toDouble()
                    : (selectedPkg.price?.toDouble() ?? 0.0);

                cubit.startGiftPaymentFlow(
                  context,
                  selectedPkg.id!,
                  finalAmount, // 2. تمرير السعر النهائي بعد الحسبة
                  codeController.text,
                );
              }
              setState(() => _isAutoPaying = false);
            }
          } else if (state is CheckEmailFailedState) {
            setState(() {
              isEmailVerified = false;
              _isAutoPaying = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PurchaseSuccessState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const PayDoneDialog(title: 'Your gift is send'),
            );

            // if (context.mounted) context.pop();
          }
        },
        builder: (context, state) {
          final packages = (cubit.packagesModel?.data ?? [])
            ..sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
          final data = cubit.giftCheckoutData?.data;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.verticalSpace,
                // الخطوة الثانية: إدخال الإيميل والتحقق
                Text('1. Recipient info', style: AppTextStyle.style16Bold),
                15.verticalSpace,
                CustomPrimaryTextfield(
                  suffix: state is CheckEmailLoadingState
                      ? SizedBox(
                          width: 5.w,
                          height: 5.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          isEmailVerified
                              ? Icons.check_circle
                              : Icons.verified_user_outlined,
                          color: isEmailVerified
                              ? Colors.green
                              : AppColors.darkGreyColor.withAlpha(150),
                        ),
                  controller: emailController,
                  text: 'Recipient email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    if (isEmailVerified) {
                      setState(() => isEmailVerified = false);
                    }
                  },
                ),
                15.verticalSpace,

                // زر التحقق
                // SizedBox(
                //   width: double.infinity,
                //   child: OutlinedButton.icon(
                //     style: OutlinedButton.styleFrom(
                //       padding: EdgeInsets.symmetric(vertical: 12.h),
                //       side: BorderSide(
                //         color: isEmailVerified
                //             ? Colors.green
                //             : AppColors.primaryColor,
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10.r),
                //       ),
                //     ),
                //     onPressed: (emailController.text.isNotEmpty)
                //         ? () {
                //             if (selectedPackageId == null) {
                //               ScaffoldMessenger.of(context).showSnackBar(
                //                 const SnackBar(
                //                   content: Text(
                //                     'Please select a package first',
                //                   ),
                //                   backgroundColor: Colors.orange,
                //                 ),
                //               );
                //               return;
                //             }
                //             cubit.checkGiftEmail(
                //               selectedPackageId!,
                //               emailController.text,
                //             );
                //           }
                //         : null,
                //     icon: state is CheckEmailLoadingState
                //         ? SizedBox(
                //             width: 20.w,
                //             height: 20.h,
                //             child: const CircularProgressIndicator(
                //               strokeWidth: 2,
                //             ),
                //           )
                //         : Icon(
                //             isEmailVerified
                //                 ? Icons.check_circle
                //                 : Icons.verified_user_outlined,
                //             color: isEmailVerified
                //                 ? Colors.green
                //                 : AppColors.primaryColor,
                //           ),
                //     label: Text(
                //       isEmailVerified ? 'Verified' : 'Verify recipient',
                //       style: TextStyle(
                //         color: isEmailVerified
                //             ? Colors.green
                //             : AppColors.primaryColor,
                //         fontWeight: isEmailVerified
                //             ? FontWeight.bold
                //             : FontWeight.normal,
                //       ),
                //     ),
                //   ),
                // ),
                25.verticalSpace,

                // الخطوة الأولى: اختيار الباقة (Dropdown)
                Text('2. Choose gift package', style: AppTextStyle.style16Bold),
                15.verticalSpace,
                DropdownButtonFormField<int>(
                  initialValue: selectedPackageId,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.darkGreyColor.withAlpha(25),
                    contentPadding: EdgeInsets.only(
                      left: 12.w,
                      // vertical: 12.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: selectedPackageId != null
                            ? AppColors.primaryColor
                            : Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                  hint: const Text('Select a package'),
                  items: packages.map((pkg) {
                    return DropdownMenuItem<int>(
                      value: pkg.id,
                      child: Row(
                        children: [
                          Text(
                            '${pkg.name}: ${pkg.price} SAR',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.style12Bold,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedPackageId = val;
                      // isEmailVerified = false;
                    });
                  },
                ),
                25.verticalSpace,

                ...[
                  CustomPrimaryTextfield(
                    controller: codeController,
                    text: 'Enter Promo Code',
                    suffix: IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        cubit.getGiftCheckoutDetails(
                          offerId: selectedPackageId!,
                          code: codeController.text,
                        );
                      },
                    ),
                  ),

                  Text(
                    'Press ✓ to promo code apply.',
                    style: AppTextStyle.style12W600.copyWith(
                      color: AppColors.darkGreyColor.withAlpha(100),
                    ),
                  ),

                  30.verticalSpace,

                  if (data != null) ...[
                    _priceRow('Original price', "${data.offerPrice} ${'sar'}"),

                    if (data.codeDiscountPrice != null &&
                        data.codeDiscountPrice! > 0)
                      _priceRow(
                        '${'Code discount'} (${data.codeDiscount})',
                        "- ${data.codeDiscountPrice} ${'sar'}",
                        valueColor: Colors.red,
                      ),

                    if (data.deductedPoints != null &&
                        data.deductedPoints! > 0) ...[
                      const Divider(height: 20),
                      _priceRow(
                        'Points used',
                        "${data.deductedPoints} ${'point'}",
                        valueColor: AppColors.secondaryColor,
                      ),
                      _priceRow(
                        'Points discount',
                        "- ${data.deductedPoints} ${'sar'}",
                        valueColor: Colors.red,
                      ),
                    ],

                    const Divider(height: 30, thickness: 1),

                    _priceRow(
                      'Total payment',
                      "${data.payments} ${'sar'}",
                      isTotal: true,
                    ),
                  ],

                  //   // const Spacer(),
                  //   CustomPrimaryButton(
                  //     text: 'Pay Now (${data?.totalAfterCodeDiscount ?? 0} SAR)',
                  //     onPressed: () {
                  //       if (data != null) {
                  //         cubit.startPayMobPayment(
                  //           context,
                  //           data.offerId!,
                  //           data.totalAfterCodeDiscount!,
                  //           codeController.text,
                  //         );
                  //       }
                  //     },
                  //   ),
                ],
                25.verticalSpace,
                // الخطوة الثالثة: الدفع
                CustomPrimaryButton(
                  width: double.infinity,
                  text:
                      'Pay & Send Gift (${data?.totalAfterCodeDiscount ?? 0} sar)',
                  onPressed:
                      (selectedPackageId != null &&
                          emailController.text.isNotEmpty)
                      ? () {
                          final selectedPkg = packages.firstWhere(
                            (p) => p.id == selectedPackageId,
                          );

                          // التحقق من السعر: الأولوية لسعر الخصم إذا وجد، وإلا سعر الباقة
                          final double finalAmount =
                              (cubit
                                      .giftCheckoutData
                                      ?.data
                                      ?.totalAfterCodeDiscount !=
                                  null)
                              ? cubit
                                    .giftCheckoutData!
                                    .data!
                                    .totalAfterCodeDiscount!
                                    .toDouble()
                              : (selectedPkg.price?.toDouble() ?? 0.0);

                          if (isEmailVerified) {
                            cubit.startGiftPaymentFlow(
                              context,
                              selectedPkg.id!,
                              finalAmount, // نمرر السعر النهائي هنا
                              codeController.text,
                            );
                          } else {
                            setState(() => _isAutoPaying = true);
                            cubit.checkGiftEmail(
                              selectedPackageId!,
                              emailController.text,
                            );
                          }
                        }
                      : null,
                ),
                20.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyle.style16Bold
                : AppTextStyle.style14W500.copyWith(color: Colors.grey[700]),
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyle.style18Bold.copyWith(
                    color: AppColors.primaryColor,
                  )
                : AppTextStyle.style14W500.copyWith(
                    color: valueColor ?? Colors.black,
                    fontWeight: valueColor != null
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
          ),
        ],
      ),
    );
  }
}
