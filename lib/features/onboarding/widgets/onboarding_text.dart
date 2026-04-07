// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smle/core/helpers/app_localization.dart';
// import 'package:smle/core/theme/colors.dart';
// import 'package:smle/core/theme/text_styles.dart';
// import 'package:smle/features/splash/cubit/global_cubit/global_cubit.dart';

// class OnBoardingText extends StatelessWidget {
//   const OnBoardingText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<GlobalCubit, GlobalStates>(
//       builder: (context, state) {
//         return Align(
//           alignment: Alignment.topLeft,
//           child: Text(
//             textAlign: TextAlign.center,
//             context.read<GlobalCubit>().onBoardingIndex == 0
//                 ? 'onBoarding1'.tr(context)
//                 : context.read<GlobalCubit>().onBoardingIndex == 1
//                 ? 'onBoarding2'.tr(context)
//                 : 'onBoarding3'.tr(context),
//             style: context.read<GlobalCubit>().onBoardingIndex != 2
//                 ? AppTextStyle.style20Bold.copyWith(
//                     color: AppColors.secondaryColor,
//                   )
//                 : AppTextStyle.style16W500.copyWith(
//                     color: AppColors.secondaryColor,
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }
