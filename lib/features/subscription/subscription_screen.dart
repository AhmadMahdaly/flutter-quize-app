import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/subscription/cubit/Subscription_cubit.dart';
import 'package:smle/features/subscription/widgets/already_subsciption_dialog.dart';
import '../../core/routing/routes.dart';
import '../../core/shared_widgets/custom_app_bar.dart';
import '../../core/theme/assets.dart';
import '../../core/theme/colors.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key, required this.offerId});
final int offerId;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionStates>(
      builder: (context, state) {
        final cubit = context.read<SubscriptionCubit>();
        final packages = offerId != -1
            ? cubit.extraPackagesModel?.data ?? []
            : cubit.packagesModel?.data ?? [];
        return Scaffold(
          appBar: CustomAppBar(
            title: offerId != -1
                ? 'extra_packages'.tr(context)
                : 'subscription'.tr(context),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                30.verticalSpace,
                Text(
                  offerId != -1
                      ? 'choose_extra_plan'.tr(context)
                      : 'choose_your_plan'.tr(context),
                  style: interBold.copyWith(
                    fontSize: 16.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
                50.verticalSpace,
                // Package list
                ...List.generate(packages.length, (index) {
                  final package = packages[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 25.h),
                    child: GestureDetector(
                      onTap: () {
                        cubit.getYourCheckout('${package.id}').then((_) {
                          if (cubit.yourCheckoutModel?.data != null) {
                            context.pushNamed(Routes.paymentScreen,
                                arguments: '${package.id}');
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlreadySubscriptionDialog(
                                message: cubit.yourCheckoutModel?.message ?? '',
                              ),
                            );
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          color: AppColors.secondaryColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 20.sp, left: 60.sp, top: 15.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Package header
                                  package.name != 'VIP '
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                            color: AppColors.primaryColor,
                                          ),
                                          child: Text('Package ${index + 1}',
                                              style: interBold.copyWith(
                                                  color: Colors.white)),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              Assets.crownIcon,
                                              height: 20.h,
                                            ),
                                            Text('${package.name}Package',
                                                style: interBold.copyWith(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                  20.verticalSpace,

                                  // Features
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      package.features?.length ?? 0,
                                      (i) => Padding(
                                        padding: EdgeInsets.only(bottom: 10.h),
                                        child: Text(
                                          '* ${package.features![i].name}',
                                          style: interRegular.copyWith(
                                              fontSize: 14.sp,
                                              color: AppColors.thirdColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace,
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${package.price} SAR',
                                    style: interBold.copyWith(
                                      color: AppColors.thirdColor,
                                      fontSize: 16.sp,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, SubscriptionStates state) {},
    );
  }
}
