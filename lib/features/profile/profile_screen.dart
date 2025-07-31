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
import 'package:smle/features/profile/widgets/profile_app_bar_widgets.dart';
import 'package:smle/features/profile/widgets/profile_button_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutCubit, MainLayoutState>(
      builder: (context, state) {
        return context.read<MainLayoutCubit>().profileModel == null
            ? Scaffold(
                appBar: const ProfileAppBarWidgets(
                  canBack: false,
                  imagePath:
                      'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                ),
                body: Column(
                  children: [
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 10.w,
                      ),
                    ),
                  ],
                ),
              )
            : Scaffold(
                appBar: ProfileAppBarWidgets(
                  canBack: false,
                  imagePath:
                      context
                              .read<MainLayoutCubit>()
                              .profileModel!
                              .data!
                              .photo ==
                          null
                      ? 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'
                      : '${context.read<MainLayoutCubit>().profileModel!.data!.photo}',
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 15.h,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizeConfig.responsiveValue(
                              phone: 90.verticalSpace,
                              tablet: 50.verticalSpace,
                            ),
                            Text(
                              '${context.read<MainLayoutCubit>().profileModel!.data!.name}',
                              style: interBold.copyWith(
                                fontSize: SizeConfig.responsiveValue(
                                  phone: 18.sp,
                                  tablet: 22.sp,
                                ),
                              ),
                            ),
                            Text(
                              '${context.read<MainLayoutCubit>().profileModel!.data!.email}',
                              style: interRegular.copyWith(
                                color: AppColors.darkGreyColor,
                                fontSize: SizeConfig.responsiveValue(
                                  phone: 14.sp,
                                  tablet: 18.sp,
                                ),
                              ),
                            ),
                            if (context
                                    .read<MainLayoutCubit>()
                                    .profileModel!
                                    .data!
                                    .offerName !=
                                null)
                              Text(
                                '${"package_subscribed".tr(context)} ${context.read<MainLayoutCubit>().profileModel!.data!.offerName}',
                                style: interMedium.copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: SizeConfig.responsiveValue(
                                    phone: 14.sp,
                                    tablet: 18.sp,
                                  ),
                                ),
                              ),
                            if (context
                                    .read<MainLayoutCubit>()
                                    .profileModel!
                                    .data!
                                    .remainingRealExams !=
                                null)
                              Text(
                                '${"remaining_real_exams".tr(context)} ${context.read<MainLayoutCubit>().profileModel!.data!.remainingRealExams} ${"exams".tr(context)}',
                                style: interMedium.copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: SizeConfig.responsiveValue(
                                    phone: 14.sp,
                                    tablet: 18.sp,
                                  ),
                                ),
                              ),
                    
                            if (context
                                    .read<MainLayoutCubit>()
                                    .profileModel!
                                    .data!
                                    .packageExpireAt !=
                                null)
                              Text(
                                '${"expire_date".tr(context)} ${context.read<MainLayoutCubit>().profileModel!.data!.packageExpireAt}',
                                style: interMedium.copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: SizeConfig.responsiveValue(
                                    phone: 14.sp,
                                    tablet: 18.sp,
                                  ),
                                ),
                              ),
                            62.verticalSpace,
                          ],
                        ),
                    
                        Column(
                          spacing: 16.h,
                          children: [
                            ProfileButtonWidget(
                              text: 'exams_history'.tr(context),
                              imagePath: Assets.history,
                              onPressed: () {
                                context.pushNamed(Routes.examsHistoryScreen);
                              },
                            ),
                            ProfileButtonWidget(
                              text: 'exams_analysis'.tr(context),
                              imagePath: Assets.lineUp,
                              onPressed: (){
                                context.pushNamed(Routes.analysisScreen);
                              },
                            ),
                            ProfileButtonWidget(
                              text: 'gifts'.tr(context),
                              imagePath: Assets.gift,
                              onPressed: (){
                                context.pushNamed(Routes.giftsScreen);
                              },
                            ),
                            // 20.verticalSpace,
                            // ProfileButtonWidget(text: 'exam_grades'.tr(context),imagePath: Assets.bookCheck,),
                            ProfileButtonWidget(
                              text: 'delete_account'.tr(context),
                              imagePath: Assets.tarsh,
                              onPressed: () {
                                context.read<MainLayoutCubit>().deleteAccount(
                                  context,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
