import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../splash/cubit/global_cubit/global_cubit.dart';

class OnBoardingText extends StatelessWidget {
  const OnBoardingText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalStates>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.topLeft,
          child: Text(
              context
                  .read<GlobalCubit>()
                  .onBoardingIndex == 0
                  ? 'onBoarding1'.tr(context)
                  : context
                  .read<GlobalCubit>()
                  .onBoardingIndex ==
                  1
                  ? 'onBoarding2'.tr(context)
                  : 'onBoarding3'.tr(context),
              style: context
                  .read<GlobalCubit>()
                  .onBoardingIndex !=
                  2
                  ? interBold.copyWith(
                color: AppColors.secondaryColor,
                fontSize: 20.sp,
              )
                  : interRegular.copyWith(
                color: AppColors.secondaryColor,
                fontSize: 16.sp,
              )),
        );
      },
    );
  }
}
