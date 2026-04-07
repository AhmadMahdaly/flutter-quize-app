import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
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
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
          ),
          child: GestureDetector(
            onTap: () {
              context.pushNamed(
                AppRoutes.subscriptionScreen,
                arguments:
                    context
                        .read<MainLayoutCubit>()
                        .profileModel!
                        .data!
                        .offerId ??
                    -1,
              );
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
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${'Now'}\n',
                      style: AppTextStyle.style18Bold,
                    ),
                    TextSpan(
                      text:
                          "${'Get a Flashback discount code after subscribing when your referred friends use it.'}\n",
                      style: AppTextStyle.style16W700.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    TextSpan(
                      text: 'Discover now!',
                      style: AppTextStyle.style16Bold.copyWith(
                        color: AppColors.thirdColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.offwhiteColor,
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
