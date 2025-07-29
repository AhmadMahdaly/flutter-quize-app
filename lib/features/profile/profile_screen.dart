import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/login/cubit/login_cubit.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/profile/widgets/profile_app_bar_widgets.dart';
import 'package:smle/features/profile/widgets/profile_button_widget.dart';
import '../../core/routing/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutCubit, MainLayoutState>(
      builder: (context, state) {
        return context.read<MainLayoutCubit>().profileModel == null
            ? Scaffold(
                appBar: const ProfileAppBarWidgets(
                    canBack: false,
                    imagePath:
                        'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'),
                body: Column(
                  children: [
                    Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 10.w,
                    ))
                  ],
                ),
              )
            : Scaffold(
                appBar: ProfileAppBarWidgets(
                  canBack: false,
                  imagePath: context
                              .read<MainLayoutCubit>()
                              .profileModel!
                              .data!
                              .photo ==
                          null
                      ? 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'
                      : '${context.read<MainLayoutCubit>().profileModel!.data!.photo}',
                ),
                body: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                                '${context.read<MainLayoutCubit>().profileModel!.data!.name}',
                                style: interBold.copyWith(fontSize: 16.sp)),
                            Text(
                              '${context.read<MainLayoutCubit>().profileModel!.data!.email}',
                              style: interRegular.copyWith(
                                  color: AppColors.darkGreyColor,
                                  fontSize: 14.sp),
                            ),
                            if(context.read<MainLayoutCubit>().profileModel!.data!.offerName!=null)
                            Text(
                              '${"package_subscribed".tr(context)} ${context.read<MainLayoutCubit>().profileModel!.data!.offerName}',
                              style: interMedium.copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 14.sp),
                            ),
                            if(context.read<MainLayoutCubit>().profileModel!.data!.remainingRealExams!=null)
                              Text(
                              '${"remaining_real_exams".tr(context)} ${context.read<MainLayoutCubit>().profileModel!.data!.remainingRealExams} ${"exams".tr(context)}',
                              style: interMedium.copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 14.sp),
                            ),
                            if(context.read<MainLayoutCubit>().profileModel!.data!.packageExpireAt!=null)
                              Text(
                              '${"expire_date".tr(context)} ${context.read<MainLayoutCubit>().profileModel!.data!.packageExpireAt}',
                              style: interMedium.copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 14.sp),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ProfileButtonWidget(
                              text: 'exams_history'.tr(context),
                              imagePath: Assets.history,
                              onPressed: () {
                                context.pushNamed(Routes.examsHistoryScreen);
                              },
                            ),
                            20.verticalSpace,
                            ProfileButtonWidget(
                              text: 'exams_analysis'.tr(context),
                              imagePath: Assets.lineUp,
                            ),
                            20.verticalSpace,
                            ProfileButtonWidget(
                              text: 'gifts'.tr(context),
                              imagePath: Assets.gift,
                            ),
                            // 20.verticalSpace,
                            // ProfileButtonWidget(text: 'exam_grades'.tr(context),imagePath: Assets.bookCheck,),
                            20.verticalSpace,
                            ProfileButtonWidget(
                              text: 'delete_account'.tr(context),
                              imagePath: Assets.tarsh,
                              onPressed: () {
                                context
                                    .read<MainLayoutCubit>()
                                    .deleteAccount(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
              );
      },
    );
  }
}
