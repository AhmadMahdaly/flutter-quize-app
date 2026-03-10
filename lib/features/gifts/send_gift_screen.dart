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
                final double finalAmount =
                    (cubit.giftCheckoutData?.data?.totalAfterCodeDiscount !=
                        null)
                    ? cubit.giftCheckoutData!.data!.totalAfterCodeDiscount!
                          .toDouble()
                    : (selectedPkg.price?.toDouble() ?? 0.0);

                cubit.startGiftPaymentFlow(
                  context,
                  selectedPkg.id!,
                  finalAmount,
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
          }
        },
        builder: (context, state) {
          final packages = (cubit.packagesModel?.data ?? [])
            ..sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
          final data = cubit.giftCheckoutData?.data;

          double displayPrice = 0.0;
          if (selectedPackageId != null) {
            final selectedPkg = packages
                .where((p) => p.id == selectedPackageId)
                .firstOrNull;

            displayPrice = (data?.totalAfterCodeDiscount != null)
                ? data!.totalAfterCodeDiscount!.toDouble()
                : (selectedPkg?.price?.toDouble() ?? 0.0);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.verticalSpace,

                Text('1. Recipient info', style: AppTextStyle.style16Bold),
                15.verticalSpace,
                CustomPrimaryTextfield(
                  controller: emailController,
                  text: 'Recipient email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    setState(() {
                      if (isEmailVerified) {
                        isEmailVerified = false;
                      }
                    });
                  },
                ),
                15.verticalSpace,

                25.verticalSpace,

                Text('2. Choose gift package', style: AppTextStyle.style16Bold),
                15.verticalSpace,
                DropdownButtonFormField<int>(
                  initialValue: selectedPackageId,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.darkGreyColor.withAlpha(25),
                    contentPadding: EdgeInsets.only(left: 12.w),
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
                    final double priceInSAR = pkg.price ?? 0.0;
                    final double priceBeforeDiscount =
                        pkg.priceBeforeDiscount ?? 0.0;

                    return DropdownMenuItem<int>(
                      value: pkg.id,
                      child: Row(
                        children: [
                          Text(
                            '${pkg.name}: ',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.style12Bold,
                          ),
                          if (priceBeforeDiscount != 0 &&
                              priceBeforeDiscount > priceInSAR) ...[
                            Text(
                              textAlign: TextAlign.end,

                              '$priceBeforeDiscount SAR',
                              style: AppTextStyle.style12Bold.copyWith(
                                color: AppColors.darkGreyColor,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: AppColors.greenColor,
                                decorationThickness: 2,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              textAlign: TextAlign.end,

                              '$priceInSAR SAR',
                              style: AppTextStyle.style12Bold.copyWith(
                                color: AppColors.greenColor,
                              ),
                            ),
                          ] else ...[
                            Text(
                              textAlign: TextAlign.end,
                              '$priceInSAR SAR',
                              style: AppTextStyle.style12Bold.copyWith(
                                color: AppColors.iconColorBlack,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    selectedPackageId = val;

                    setState(() {});
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
                        valueColor: AppColors.greenColor,
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
                        valueColor: AppColors.greenColor,
                      ),
                    ],

                    const Divider(height: 30, thickness: 1),

                    _priceRow(
                      'Total payment',
                      "${data.payments} ${'sar'}",
                      isTotal: true,
                    ),
                  ],
                ],
                25.verticalSpace,

                state is CheckEmailLoadingState
                    ? const LinearProgressIndicator()
                    : CustomPrimaryButton(
                        width: double.infinity,
                        text: 'Pay & Send Gift ($displayPrice sar)',
                        onPressed:
                            (selectedPackageId != null &&
                                emailController.text.isNotEmpty)
                            ? () {
                                final selectedPkg = packages.firstWhere(
                                  (p) => p.id == selectedPackageId,
                                );

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
                                    finalAmount,
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
