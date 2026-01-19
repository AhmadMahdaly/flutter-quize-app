import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/subscription/cubit/subscription_cubit.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionCubit>().getPackages();
    context.read<SubscriptionCubit>().currentReceiverId = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Send gift'),
      body: BlocConsumer<SubscriptionCubit, SubscriptionStates>(
        listener: (context, state) {
          if (state is CheckEmailSuccessState) {
            setState(() => isEmailVerified = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User verified'),
                backgroundColor: Colors.green,
              ),
            );

            if (_isAutoPaying && selectedPackageId != null) {
              final cubit = context.read<SubscriptionCubit>();
              final selectedPkg = cubit.packagesModel?.data?.firstWhere(
                (p) => p.id == selectedPackageId,
              );

              if (selectedPkg != null) {
                cubit.startGiftPaymentFlow(
                  context,
                  selectedPkg.id!,
                  selectedPkg.price!,
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your gift is send'),
                backgroundColor: Colors.green,
              ),
            );
            if (context.mounted) context.pop();
          }
        },
        builder: (context, state) {
          final cubit = context.read<SubscriptionCubit>();
          final packages = cubit.packagesModel?.data ?? [];

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
                              : AppColors.primaryColor,
                        ),
                  controller: emailController,
                  text: 'Recipient email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    if (isEmailVerified)
                      setState(() => isEmailVerified = false);
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
                    fillColor: AppColors.darkGreyColor.withOpacity(0.1),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
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
                      child: Text(
                        "${pkg.name} (${pkg.price} ${'sar'.tr(context)})",
                        style: AppTextStyle.style14Bold,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedPackageId = val;
                      isEmailVerified = false;
                    });
                  },
                ),

                80.verticalSpace,

                // الخطوة الثالثة: الدفع
                CustomPrimaryButton(
                  width: double.infinity,
                  text:
                      'Pay & Send Gift (${packages.any((p) => p.id == selectedPackageId) ? packages.firstWhere((p) => p.id == selectedPackageId).price : 0} sar)',
                  onPressed:
                      (selectedPackageId != null &&
                          emailController.text.isNotEmpty)
                      ? () {
                          if (isEmailVerified) {
                            final selectedPkg = packages.firstWhere(
                              (p) => p.id == selectedPackageId,
                            );
                            cubit.startGiftPaymentFlow(
                              context,
                              selectedPkg.id!,
                              selectedPkg.price!,
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
}
