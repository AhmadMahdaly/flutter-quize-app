import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/subscription/cubit/subscription_cubit.dart';
import 'package:smle/features/subscription/widgets/gift_subscription_banner.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key, required this.offerId});
  final int offerId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionStates>(
      builder: (context, state) {
        final cubit = context.read<SubscriptionCubit>();

        if (state is GetPackagesLoadingState && cubit.packagesModel == null) {
          return const Scaffold(
            appBar: CustomAppBar(title: 'Subscription'),
            body: Center(child: CircularProgressIndicator()),
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
          return const Scaffold(
            appBar: CustomAppBar(title: 'Subscription'),
            body: Center(child: Text('No packages Found')),
          );
        }

        return Scaffold(
          appBar: const CustomAppBar(title: 'Subscription'),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GiftSubscriptionBanner(
                      onTap: () async {
                        await context.pushNamed(AppRoutes.giftsScreen);
                      },
                    ),
                    16.verticalSpace,
                    Text(
                      'Choose your plan',
                      style: AppTextStyle.style16Bold.copyWith(
                        fontSize: SizeConfig.responsiveValue(
                          phone: 16.sp,
                          tablet: 20.sp,
                        ),
                      ),
                    ),
                    16.verticalSpace,

                    ...List.generate(allBackendPackages.length, (index) {
                      final backendPackage = allBackendPackages[index];
                      final double priceInSAR = backendPackage.price ?? 0.0;
                      final double priceBeforeDiscount =
                          backendPackage.priceBeforeDiscount ?? 0.0;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.checkoutScreen,
                              arguments: {
                                'cubit': context.read<SubscriptionCubit>(),
                                'package': backendPackage,
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.r),
                                    topRight: Radius.circular(16.r),
                                  ),
                                  color: AppColors.secondaryColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
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
                                            12.verticalSpace,
                                            Text(
                                              backendPackage.name ?? 'Package',
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
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16.r),
                                    bottomRight: Radius.circular(16.r),
                                  ),
                                  color: AppColors.primaryColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
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
                                            Align(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  if (priceBeforeDiscount !=
                                                      0) ...[
                                                    Text(
                                                      '$priceBeforeDiscount SAR',
                                                      style: AppTextStyle
                                                          .style16Bold
                                                          .copyWith(
                                                            color: AppColors
                                                                .thirdColor,
                                                            fontSize: 20.sp,
                                                            decorationColor:
                                                                AppColors
                                                                    .errorColor,
                                                            decorationThickness:
                                                                2,
                                                            decoration:
                                                                priceBeforeDiscount !=
                                                                    0
                                                                ? TextDecoration
                                                                      .lineThrough
                                                                : null,
                                                          ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      '$priceInSAR SAR',
                                                      style: AppTextStyle
                                                          .style16Bold
                                                          .copyWith(
                                                            color: AppColors
                                                                .thirdColor,
                                                            fontSize: 22.sp,
                                                          ),
                                                    ),
                                                  ] else ...[
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      '$priceInSAR SAR',
                                                      style: AppTextStyle
                                                          .style16Bold
                                                          .copyWith(
                                                            color: AppColors
                                                                .thirdColor,
                                                            fontSize: 22.sp,
                                                          ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
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
