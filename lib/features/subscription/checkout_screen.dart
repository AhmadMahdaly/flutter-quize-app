import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
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
            // Navigator.pop(context);
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
                    color: AppColors.primaryColor,
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

                const Spacer(),
                CustomPrimaryButton(
                  text: 'Pay Now (${data?.totalAfterCodeDiscount ?? 0} SAR)',
                  onPressed: () {
                    if (data != null) {
                      cubit.startPayMobPayment(
                        context,
                        data.offerId!,
                        data.totalAfterCodeDiscount!,
                        codeController.text,
                      );
                    }
                  },
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
