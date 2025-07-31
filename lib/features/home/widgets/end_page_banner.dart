import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class EndPageBanner extends StatelessWidget {
  const EndPageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(100.r)),
          ),
          child: GestureDetector(
            onTap: () {
              context.pushNamed(Routes.subscriptionScreen ,arguments:
                  context
                  .read<MainLayoutCubit>()
                  .profileModel!
                  .data!
                  .offerId ??
                  -1,);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.responsiveValue(
                  phone: 60.w,
                  tablet: 40.w,
                ),
                vertical: 24.h,
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${'now'.tr(context)}\n',
                      style: interBold.copyWith(
                        fontSize: SizeConfig.responsiveValue(
                          phone: 16.sp,
                          tablet: 20.sp,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: "${'flashback_discount'.tr(context)}\n",
                      style: interMedium.copyWith(
                        fontSize: SizeConfig.responsiveValue(
                          phone: 16.sp,
                          tablet: 20.sp,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: '             ${'discover_now'.tr(context)}',
                      style: interRegular.copyWith(
                        fontSize: SizeConfig.responsiveValue(
                          phone: 16.sp,
                          tablet: 20.sp,
                        ),
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -36.w,
          right: 0,
          child: Image(
            image: const AssetImage(Assets.crownHome),
            width: SizeConfig.responsiveValue(phone: 100.w, tablet: 70.w),
          ),
        ),
      ],
    );
  }
}
