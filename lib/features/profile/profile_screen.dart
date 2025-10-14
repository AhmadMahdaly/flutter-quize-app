import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/login/cubit/login_cubit.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/profile/widgets/profile_button_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) =>  LoginCubit(getIt()),
  child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
      builder: (context, state) {
        return context.read<MainLayoutCubit>().profileModel == null
            ? Scaffold(
                appBar: CustomAppBar(title: 'profile'.tr(context),canBack: false,),
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
          appBar: CustomAppBar(title: 'profile'.tr(context),canBack: false,),
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
                              phone: 40.verticalSpace,
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
                            // if (context
                            //         .read<MainLayoutCubit>()
                            //         .profileModel!
                            //         .data!
                            //         .offerName !=
                            //     null)
                            //   Text(
                            //     '${"package_subscribed".tr(context)} ${context.read<MainLayoutCubit>().profileModel!.data!.offerName}',
                            //     style: interMedium.copyWith(
                            //       color: AppColors.primaryColor,
                            //       fontSize: SizeConfig.responsiveValue(
                            //         phone: 14.sp,
                            //         tablet: 18.sp,
                            //       ),
                            //     ),
                            //   ),
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
                            40.verticalSpace,
                          ],
                        ),
                    
                        Column(
                          spacing: 16.h,
                          children: [
                            ProfileButtonWidget(
                              text: 'Playlist',
                              imagePath: Assets.questionLight,
                              onPressed: () {
                                context.pushNamed(Routes.playListScreen, arguments: {
                                  'questionId':0,
                                  'isAdd':true
                                }, );
                              },
                            ),
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
                                context.pushNamed(Routes.analysisScreen,arguments: false);
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
                            ProfileButtonWidget(
                              text: 'log_out'.tr(context),
                              imagePath: Assets.logOut,
                              onPressed: () {
                                context.read<LoginCubit>().logOut().then((value) {
                                  CacheHelper.sharedPreferences.remove(CacheKeys.userToken);
                                  context.pushReplacementNamed(Routes.loginScreen);
                                });
                              },
                            ),
                          ],
                        ),

                        SizeConfig.responsiveValue(
                          phone: 60.verticalSpace,
                          tablet: 60.verticalSpace,
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    ),
);
  }
}
