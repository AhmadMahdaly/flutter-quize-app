import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class EndPageBanner extends StatelessWidget {
  const EndPageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(55),
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.responsiveValue(phone: 20.w, tablet: 40.w),
              vertical: 32.h,
            ),
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  'Now, Get a Flashback discount code after subscribing when your referred friends use it.',
                  style: AppTextStyle.style14W500.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),

                  // TextSpan(
                  //   text: 'Discover now!',
                  //   style: AppTextStyle.style16Bold.copyWith(
                  //     color: AppColors.primaryColor,
                  //     decoration: TextDecoration.underline,
                  //     decorationColor: AppColors.primaryColor,
                  //   ),
                  // ),
                ),
                8.verticalSpace,
                CustomPrimaryVButton(
                  text: 'Discover now!',
                  onPressed: () => context.pushNamed(
                    AppRoutes.subscriptionScreen,
                    arguments:
                        context
                            .read<MainLayoutCubit>()
                            .profileModel!
                            .data!
                            .offerId ??
                        -1,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -46.w,
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
