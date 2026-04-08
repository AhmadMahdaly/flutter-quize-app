import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/launch_url.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/core/shared_widgets/no_data_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/home/widgets/category/base_category_widget.dart';
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

  String? _pendingPaymentMethod;

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
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }

  void _handleGiftPayment(String paymentMethod) {
    final packages = (cubit.packagesModel?.data ?? [])
      ..sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    final selectedPkg = packages.firstWhere((p) => p.id == selectedPackageId);

    final double finalAmount =
        (cubit.giftCheckoutData?.data?.totalAfterCodeDiscount != null)
        ? cubit.giftCheckoutData!.data!.totalAfterCodeDiscount!.toDouble()
        : (selectedPkg.price?.toDouble() ?? 0.0);

    if (isEmailVerified) {
      cubit.startGiftPaymentFlow(
        context,
        selectedPkg.id!,
        finalAmount,
        codeController.text,
        paymentMethod,
      );
    } else {
      setState(() {
        _isAutoPaying = true;
        _pendingPaymentMethod = paymentMethod;
      });
      cubit.checkGiftEmail(selectedPackageId!, emailController.text);
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Send gift'),
      body: BlocConsumer<SubscriptionCubit, SubscriptionStates>(
        listener: (context, state) {
          if (state is CheckEmailSuccessState) {
            if (_isAutoPaying &&
                selectedPackageId != null &&
                _pendingPaymentMethod != null) {
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
                  _pendingPaymentMethod!,
                );
              }
              setState(() {
                _isAutoPaying = false;
                isEmailVerified = true;
                _pendingPaymentMethod = null;
              });
            } else {
              setState(() => isEmailVerified = true);
            }
          } else if (state is CheckEmailFailedState) {
            setState(() {
              isEmailVerified = false;
              _isAutoPaying = false;
              _pendingPaymentMethod = null;
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
          bool isFormValid() {
            final email = emailController.text.trim();

            if (selectedPackageId == null) return false;
            if (email.isEmpty) return false;

            final isValid = RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            ).hasMatch(email);

            return isValid;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Form(
              key: _formKey,
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

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }

                      if (!isValidEmail(value.trim())) {
                        return 'Enter a valid email';
                      }

                      return null;
                    },

                    onChanged: (val) {
                      setState(() {
                        if (isEmailVerified) {
                          isEmailVerified = false;
                        }
                      });
                    },
                  ),

                  15.verticalSpace,

                  // 25.verticalSpace,
                  Text(
                    '2. Choose gift package',
                    style: AppTextStyle.style16Bold,
                  ),
                  15.verticalSpace,
                  DropdownButtonFormField<int>(
                    dropdownColor: AppColors.primaryColor,
                    initialValue: selectedPackageId,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12.w),
                      filled: true,
                      fillColor: AppColors.offwhiteColor,
                      border: customOutlineInputBorder(),
                      focusedBorder: customOutlineInputBorder(),
                      enabledBorder: customOutlineInputBorder(),
                      disabledBorder: customOutlineInputBorder(),
                    ),
                    hint: Text(
                      'Select a package',
                      style: AppTextStyle.style14W600.copyWith(
                        color: AppColors.darkGreyColor.withAlpha(100),
                      ),
                    ),
                    iconEnabledColor: AppColors.primaryColor,
                    items: packages.map((pkg) {
                      final double priceInSAR = pkg.price ?? 0.0;
                      final double priceBeforeDiscount =
                          pkg.priceBeforeDiscount ?? 0.0;

                      return DropdownMenuItem<int>(
                        value: pkg.id,
                        child: Row(
                          children: [
                            /// الاسم ياخد المساحة المتاحة
                            FittedBox(
                              fit: BoxFit.scaleDown,

                              child: SizedBox(
                                width: SizeConfig.screenWidth / 3,
                                child: Text(
                                  '${pkg.name}: ',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: AppTextStyle.style14W500.copyWith(
                                    color: AppColors.iconColorBlack,
                                  ),
                                ),
                              ),
                            ),

                            8.horizontalSpace,

                            /// السعر
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (priceBeforeDiscount != 0 &&
                                    priceBeforeDiscount > priceInSAR) ...[
                                  Text(
                                    '$priceBeforeDiscount SAR',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.style12Bold.copyWith(
                                      color: AppColors.darkGreyColor,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: AppColors.greenColor,
                                      decorationThickness: 1,
                                    ),
                                  ),
                                  6.horizontalSpace,
                                ],

                                Text(
                                  '$priceInSAR SAR',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.style12Bold.copyWith(
                                    color:
                                        priceBeforeDiscount != 0 &&
                                            priceBeforeDiscount > priceInSAR
                                        ? AppColors.greenColor
                                        : AppColors.iconColorBlack,
                                  ),
                                ),
                              ],
                            ),
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
                      _priceRow(
                        'Original price',
                        "${data.offerPrice} ${'sar'}",
                      ),

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
                      ? const LoadingWidget()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('3. Pay via', style: AppTextStyle.style16Bold),
                            8.verticalSpace,
                            CategoryPaymentWidget(
                              imagePath: null,
                              onTap: () {
                                if (!isFormValid()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter a valid email and select a package',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                _handleGiftPayment('paymob');
                              },
                              // onTap:
                              //     (selectedPackageId != null &&
                              //         emailController.text.isNotEmpty)
                              //     ? () => _handleGiftPayment('paymob')
                              //     : null,
                            ),
                            Center(
                              child: Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: EdgeInsets.all(6.r),
                                    child: Text(
                                      ' Or ',
                                      style: AppTextStyle.style14W500
                                          .copyWith(),
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
                                //     onTap:
                                //         (selectedPackageId != null &&
                                //             emailController.text.isNotEmpty)
                                //         ? () => _handleGiftPayment('tabby')
                                //         : null,
                                //   ),
                                // ),
                                // 8.horizontalSpace,
                                Expanded(
                                  child: CategoryPaymentWidget(
                                    imagePath: 'assets/images/png/tamara-1.png',
                                    onTap: () {
                                      if (!isFormValid()) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please enter a valid email and select a package',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      _handleGiftPayment('tamara');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  20.verticalSpace,
                ],
              ),
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
