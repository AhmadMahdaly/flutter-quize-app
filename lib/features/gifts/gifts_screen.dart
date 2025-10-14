import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/no_data_widget.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class GiftsScreen extends StatelessWidget {
  const GiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'gifts'.tr(context)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
          builder: (context, state) {
            return context.read<MainLayoutCubit>().giftsModel != null
                ? context.read<MainLayoutCubit>().giftsModel!.data != null
                      ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors
                                    .darkGreyColor, // grey background
                                borderRadius: BorderRadius.all(
                                  Radius.circular(140.r),
                                ),
                              ),
                              child: Column(
                                children: [
                                  30.verticalSpace,

                                  // Gift image
                                  SizedBox(
                                    height: 250.h,
                                    child: Image.asset(
                                      Assets
                                          .present, // Replace with your gift image
                                      fit: BoxFit.contain,
                                    ),
                                  ),

                                  20.verticalSpace,

                                  // Points Text
                                  Text(
                                    'in_your_wallet'.tr(context),
                                    style: interBold.copyWith(
                                      fontSize: 20.sp,
                                      color: AppColors.forthColor,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    '${context.read<MainLayoutCubit>().giftsModel!.data!.points} ${"points".tr(context)}',
                                    style: interBold.copyWith(
                                      fontSize: 20.sp,
                                      color: AppColors.forthColor,
                                    ),
                                  ),

                                  20.verticalSpace,
                                  if (context
                                      .read<MainLayoutCubit>()
                                      .giftsModel!
                                      .data!
                                      .code !=
                                      null)
                                  // Promo Code
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                            '${"promo_code".tr(context)} ',
                                            style: interBold.copyWith(
                                              fontSize: 16.sp,
                                              color: AppColors.forthColor,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            context
                                                .read<MainLayoutCubit>()
                                                .giftsModel!
                                                .data!
                                                .code ??
                                                '',
                                            style: interRegular.copyWith(
                                              fontSize: 16.sp,
                                              color: AppColors.forthColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (context
                                      .read<MainLayoutCubit>()
                                      .giftsModel!
                                      .data!
                                      .code !=
                                      null)
                                    const Spacer(),
                                  if (context
                                      .read<MainLayoutCubit>()
                                      .giftsModel!
                                      .data!
                                      .code !=
                                      null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 30,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            Assets
                                                .crownGifts, // Replace with your gift image
                                            fit: BoxFit.contain,
                                          ),
                                          10.horizontalSpace,
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'gifts'.tr(context),
                                                style: interBold.copyWith(
                                                  fontSize: 16.sp,
                                                  color: AppColors.forthColor,
                                                ),
                                              ),
                                              5.verticalSpace,
                                              Text(
                                                'sharing_with_friends'.tr(
                                                  context,
                                                ),
                                                style: interRegular.copyWith(
                                                  fontSize: 16.sp,
                                                  color:
                                                  AppColors.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : NoDataWidget(
                          noDataImage: '',
                          noDataText: 'no_data_found'.tr(context),
                        )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
