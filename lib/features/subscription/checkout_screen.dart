import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/home/widgets/category/base_category_widget.dart';
import 'package:smle/features/subscription/cubit/subscription_cubit.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import 'package:smle/features/subscription/widgets/pay_done_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.package, required this.cubit});
  final Data package;
  final SubscriptionCubit cubit;
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.cubit.getCheckoutDetails(offerId: widget.package.id!);
  }

  @override
  void dispose() {
    codeController.dispose();
    widget.cubit.checkoutData = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Checkout'),
      body: BlocConsumer<SubscriptionCubit, SubscriptionStates>(
        bloc: widget.cubit,
        listener: (context, state) {
          if (state is PurchaseSuccessState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const PayDoneDialog(title: 'Done'),
            );
          } else if (state is PurchaseFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PurchaseCancelledState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment cancelled'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = widget.cubit;
          final data = cubit.checkoutData?.data;
          final offerPrice = cubit.checkoutData?.data?.offerPrice;
          final offerPriceBefore =
              cubit.checkoutData?.data?.priceBeforeDiscount;

          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomPrimaryTextfield(
                  controller: codeController,
                  text: 'Enter Promo Code',
                  suffix: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      cubit.getCheckoutDetails(
                        offerId: widget.package.id!,
                        code: codeController.text,
                      );
                    },
                  ),
                ),
                Text(
                  'Press ✓ to promo code apply.',
                  textAlign: TextAlign.start,
                  style: AppTextStyle.style12W600.copyWith(
                    color: AppColors.primaryColor.withAlpha(200),
                  ),
                ),
                30.verticalSpace,

                if (data != null) ...[
                  if (offerPriceBefore != null && offerPriceBefore != '0') ...[
                    _priceRow(
                      'Original price',
                      "$offerPriceBefore ${'sar'}",
                      isNotActive: true,
                    ),
                    _priceRow('Price after discount', "$offerPrice ${'sar'}"),
                  ] else
                    _priceRow('Original price', "$offerPrice ${'sar'}"),
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
                      '${data.deductedPoints} point',
                      valueColor: AppColors.secondaryColor,
                    ),

                    _priceRow(
                      'Points discount',
                      '- ${(data.deductedPoints! / 100).toStringAsFixed(2)} sar',
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

                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pay via:',
                      style: AppTextStyle.style16Bold.copyWith(
                        color: AppColors.iconColorGray,
                      ),
                    ),
                    8.verticalSpace,
                    CategoryPaymentWidget(
                      imagePath: null,
                      onTap: () {
                        if (data != null) {
                          cubit.startPayment(
                            context,
                            data.offerId!,
                            cubit.finalPayment,
                            codeController.text,
                            'paymob',
                          );
                        }
                      },
                    ),
                    Center(
                      child: Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.all(6.r),
                            child: Text(
                              ' Or ',
                              style: AppTextStyle.style14W500.copyWith(),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        // Expanded(
                        //   child: CategoryPaymentWidget(
                        //     imagePath: 'assets/images/png/Tabby-logo.png',
                        //     onTap: () {
                        //       if (data != null) {
                        //         cubit.startPayment(
                        //           context,
                        //           data.offerId!,
                        //           cubit.finalPayment,
                        //           codeController.text,
                        //           'tabby',
                        //         );
                        //       }
                        //     },
                        //   ),
                        // ),
                        // 8.horizontalSpace,
                        Expanded(
                          child: CategoryPaymentWidget(
                            imagePath: 'assets/images/png/tamara-1.png',
                            onTap: () {
                              if (data != null) {
                                cubit.startPayment(
                                  context,
                                  data.offerId!,
                                  cubit.finalPayment,
                                  codeController.text,
                                  'tamara',
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,
                  ],
                ),
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
    bool isNotActive = false,
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
                ? AppTextStyle.style16Bold.copyWith(
                    color: AppColors.primaryColor,
                  )
                : AppTextStyle.style14W500.copyWith(
                    color: AppColors.thirdColor,
                  ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyle.style18Bold.copyWith(
                    color: AppColors.primaryColor,
                  )
                : AppTextStyle.style14W500.copyWith(
                    color:
                        valueColor ??
                        (isNotActive
                            ? AppColors.thirdColor
                            : AppColors.greenColor),
                    decoration: isNotActive ? TextDecoration.lineThrough : null,
                    decorationColor: isNotActive ? AppColors.errorColor : null,
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
