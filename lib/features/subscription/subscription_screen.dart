import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/subscription/cubit/subscription_cubit.dart'
    hide SubscriptionLoading, SubscriptionLoaded;
import 'package:smle/features/subscription/widgets/pay_done_dialog.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key, required this.offerId});
  final int offerId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionStates>(
      listener: (context, state) {
        if (state is PurchaseSuccessState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const PayDoneDialog(),
          );
        } else if (state is PurchaseFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },

      builder: (context, state) {
        final cubit = context.read<SubscriptionCubit>();

        if (state is GetPackagesLoadingState && cubit.packagesModel == null) {
          return Scaffold(
            appBar: CustomAppBar(title: 'subscription'.tr(context)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final allBackendPackages =
            (cubit.packagesModel?.data ?? []) +
            (cubit.extraPackagesModel?.data ?? []);

        allBackendPackages.sort((a, b) {
          final priceA = a.price ?? 0;
          final priceB = b.price ?? 0;
          return priceA.compareTo(priceB);
        });

        if (allBackendPackages.isEmpty && state is! GetPackagesLoadingState) {
          return Scaffold(
            appBar: CustomAppBar(title: 'subscription'.tr(context)),
            body: Center(child: Text('no_packages_found'.tr(context))),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(title: 'subscription'.tr(context)),
          body: Stack(
            children: [
              BlocBuilder<CheckSubscriptionCubit, CheckSubscriptionState>(
                builder: (context, state) {
                  if (state is SubscriptionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is SubscriptionLoaded) {
                    final sub = state.subscription;

                    final isSubscribed = sub.isSubscribed ?? false;

                    final filteredPackages = isSubscribed
                        ? allBackendPackages
                              .where((p) => p.isExtra == true)
                              .toList()
                        : allBackendPackages;

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 15.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          24.verticalSpace,
                          Text(
                            'choose_your_plan'.tr(context),
                            style: AppTextStyle.style16Bold.copyWith(
                              fontSize: SizeConfig.responsiveValue(
                                phone: 14.sp,
                                tablet: 20.sp,
                              ),
                            ),
                          ),
                          24.verticalSpace,

                          ...List.generate(filteredPackages.length, (index) {
                            final backendPackage = filteredPackages[index];
                            final int priceInSAR = backendPackage.price ?? 0;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: GestureDetector(
                                onTap: () {
                                  if (state is! PurchaseLoadingState) {
                                    cubit.startPayMobPayment(
                                      context,
                                      backendPackage,
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: AppColors.secondaryColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 24.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                backendPackage.name ??
                                                    'Package',
                                                style: AppTextStyle.style16Bold
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 18.sp,
                                                    ),
                                              ),
                                              16.verticalSpace,
                                              ...?backendPackage.features?.map(
                                                (feature) => Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: 8.h,
                                                  ),
                                                  child: Text(
                                                    '* ${feature.name}',
                                                    style: AppTextStyle
                                                        .style14W500
                                                        .copyWith(
                                                          fontSize: 14.sp,
                                                          color: AppColors
                                                              .thirdColor,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '$priceInSAR ${'sar'.tr(context)}',
                                          style: AppTextStyle.style16Bold
                                              .copyWith(
                                                color: AppColors.thirdColor,
                                                fontSize: 20.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              if (state is PurchaseLoadingState)
                Container(
                  color: Colors.black.withAlpha(120),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}
