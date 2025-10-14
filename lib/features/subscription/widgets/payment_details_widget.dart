// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smle/core/functions/responsive_config.dart';
// import 'package:smle/core/helpers/app_localization.dart';
// import 'package:smle/core/theme/colors.dart';
// import 'package:smle/core/theme/text_styles.dart';
// import 'package:smle/features/subscription/cubit/Subscription_cubit.dart';
//
// class PaymentDetailsWidget extends StatelessWidget {
//   const PaymentDetailsWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SubscriptionCubit, SubscriptionStates>(
//       builder: (context, state) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'payment_details'.tr(context),
//               style: interBold.copyWith(
//                 fontSize: SizeConfig.responsiveValue(
//                   phone: 16.sp,
//                   tablet: 20.sp,
//                 ),
//               ),
//             ),
//             30.verticalSpace,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'sub_total'.tr(context),
//                   style: interRegular.copyWith(
//                     color: AppColors.darkGreyColor,
//                     fontSize: SizeConfig.responsiveValue(
//                       phone: 16.sp,
//                       tablet: 20.sp,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '${context.read<SubscriptionCubit>().yourCheckoutModel!.data!.offerPrice} SAR',
//                   style: interRegular.copyWith(
//                     color: AppColors.darkGreyColor,
//                     fontSize: SizeConfig.responsiveValue(
//                       phone: 16.sp,
//                       tablet: 20.sp,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             10.verticalSpace,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'promo_code'.tr(context),
//                   style: interRegular.copyWith(
//                     color: AppColors.darkGreyColor,
//                     fontSize: SizeConfig.responsiveValue(
//                       phone: 16.sp,
//                       tablet: 20.sp,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '${context.read<SubscriptionCubit>().yourCheckoutModel!.data!.offerPrice}',
//                   style: interRegular.copyWith(
//                     color: AppColors.darkGreyColor,
//                     fontSize: SizeConfig.responsiveValue(
//                       phone: 16.sp,
//                       tablet: 20.sp,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             10.verticalSpace,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'discount'.tr(context),
//                   style: interRegular.copyWith(
//                     color: AppColors.darkGreyColor,
//                     fontSize: SizeConfig.responsiveValue(
//                       phone: 16.sp,
//                       tablet: 20.sp,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '${context.read<SubscriptionCubit>().yourCheckoutModel!.data!.codeDiscountPrice} SAR',
//                   style: interRegular.copyWith(
//                     color: AppColors.darkGreyColor,
//                     fontSize: SizeConfig.responsiveValue(
//                       phone: 16.sp,
//                       tablet: 20.sp,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             10.verticalSpace,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'points_discount'.tr(context),
//                   style: interRegular.copyWith(
//                     color: AppColors.darkGreyColor,
//                     fontSize: SizeConfig.responsiveValue(
//                       phone: 16.sp,
//                       tablet: 20.sp,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '${context.read<SubscriptionCubit>().yourCheckoutModel!.data!.deductedPoints} ${'points'.tr(context)}',
//                   style: interRegular.copyWith(
//                     color: AppColors.darkGreyColor,
//                     fontSize: SizeConfig.responsiveValue(
//                       phone: 16.sp,
//                       tablet: 20.sp,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             10.verticalSpace,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'total'.tr(context),
//                   style: interRegular.copyWith(
//                     fontSize: SizeConfig.responsiveValue(
//                       phone: 16.sp,
//                       tablet: 20.sp,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   '${context.read<SubscriptionCubit>().yourCheckoutModel!.data!.payments} SAR',
//                   style: interRegular.copyWith(
//                     fontSize: SizeConfig.responsiveValue(
//                       phone: 16.sp,
//                       tablet: 20.sp,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
