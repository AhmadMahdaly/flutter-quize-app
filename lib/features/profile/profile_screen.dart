import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/action_confirmation_dialog.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/shared_widgets/powered_by_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/auth/cubit/login_cubit.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/home/widgets/drawer/drawer_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/profile/widgets/profile_button_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<LoginCubit>(),
      child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
        builder: (context, state) {
          return context.read<MainLayoutCubit>().profileModel == null
              ? Scaffold(
                  appBar: CustomAppBar(
                    title: 'profile'.tr(context),
                    canBack: false,
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
              : BlocBuilder<CheckSubscriptionCubit, CheckSubscriptionState>(
                  builder: (context, state) {
                    final cubit = context
                        .read<CheckSubscriptionCubit>()
                        .checkSubscriptionModel;
                    if (state is SubscriptionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // if (state is SubscriptionLoaded) {
                    final sub = cubit;

                    final isSubscribed = sub?.isSubscribed ?? false;
                    final hasQBank = sub?.qBank ?? false;
                    final availableExam = sub?.availableRealExam ?? '0';
                    // if (state is SubscriptionLoaded) {
                    // final sub = state.subscription;
                    // final isSubscribed = sub.isSubscribed ?? false;
                    // final hasQBank = sub.qBank ?? false;
                    // final availableExam = sub.availableRealExam;
                    final offerName = sub?.offerName;
                    final createdAt = sub?.createdAt;
                    final expireDate = sub?.expireDate;
                    final data = context
                        .read<MainLayoutCubit>()
                        .profileModel!
                        .data!;
                    return Scaffold(
                      drawer: const DrawerWidget(),
                      appBar: CustomAppBar(
                        title: 'profile'.tr(context),
                        canBack: false,
                        leading: Builder(
                          builder: (context) {
                            return IconButton(
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                              icon: Icon(
                                Icons.menu,
                                color: AppColors.offwhiteColor,
                                size: SizeConfig.responsiveValue(
                                  phone: 24.r,
                                  tablet: 16.r,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      body: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          // vertical: 15.h,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 16.h),
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: AppColors.greyColor,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      '${data.name}',
                                      style: AppTextStyle.style18Bold
                                          .copyWith(),
                                    ),
                                    Text(
                                      '${data.email}',
                                      style: AppTextStyle.style14W500.copyWith(
                                        color: AppColors.darkGreyColor,
                                      ),
                                    ),
                                    12.verticalSpace,
                                    if (offerName != null)
                                      Text(
                                        'Subscription Package: $offerName',
                                        style: AppTextStyle.style12W700
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                            ),
                                      ),
                                    if (createdAt != null)
                                      Text(
                                        '${"Created Date:"} $createdAt',
                                        style: AppTextStyle.style12W700
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                            ),
                                      ),
                                    if (expireDate != null)
                                      Text(
                                        '${"expire_date".tr(context)} $expireDate',
                                        style: AppTextStyle.style12W700
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                            ),
                                      ),
                                    Text(
                                      '${"remaining_real_exams".tr(context)} $availableExam ${"exams".tr(context)}',
                                      style: AppTextStyle.style12W700.copyWith(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                spacing: 8.h,
                                children: [
                                  ProfileButtonWidget(
                                    text: 'Playlist',
                                    imagePath: Icons
                                        .playlist_add_check_circle_outlined,
                                    onPressed: !isSubscribed || !hasQBank
                                        ? () async =>
                                              subscripeDialogQuestionBank(
                                                context,
                                              )
                                        : () async {
                                            await context.pushNamed(
                                              AppRoutes.playListScreen,
                                              arguments: {
                                                'questionId': 0,
                                                'isAdd': true,
                                              },
                                            );
                                          },
                                  ),
                                  // ProfileButtonWidget(
                                  //   text: 'SCFHS Score Calculator',
                                  //   imagePath: Icons.calculate_outlined,
                                  //   onPressed: () async {
                                  //     await context.pushNamed(
                                  //       AppRoutes.sCFHSScoreCalculatorScreen,
                                  //     );
                                  //   },
                                  // ),
                                  ProfileButtonWidget(
                                    text: 'exams_history'.tr(context),
                                    imagePath: Icons.history,
                                    onPressed: !isSubscribed
                                        //   ||   (availableExam != 'Unlimited' ||
                                        //         (int.tryParse(
                                        //                   availableExam,
                                        //                 ) ??
                                        //                 0) <
                                        //             0)
                                        ? () async => subscripeDialog(context)
                                        : () async {
                                            await context.pushNamed(
                                              AppRoutes.examsHistoryScreen,
                                            );
                                          },
                                  ),
                                  // ProfileButtonWidget(
                                  //   text: 'exams_analysis'.tr(context),
                                  //   imagePath: Icons.line_axis_outlined,
                                  //   onPressed: !isSubscribed
                                  //       ? () async => subscripeDialog(context)
                                  //       : () async {
                                  //           await context.pushNamed(
                                  //             AppRoutes.analysisScreen,
                                  //             arguments: false,
                                  //           );
                                  //         },
                                  // ),
                                  ProfileButtonWidget(
                                    text: 'subscription'.tr(context),
                                    imagePath: Icons.payment,
                                    onPressed: () async {
                                      await context.pushNamed(
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
                                  ),
                                  ProfileButtonWidget(
                                    text: 'gifts'.tr(context),
                                    imagePath: Icons.card_giftcard_rounded,
                                    onPressed: () async {
                                      await context.pushNamed(
                                        AppRoutes.giftsScreen,
                                      );
                                    },
                                  ),

                                  ProfileButtonWidget(
                                    text: 'support'.tr(context),
                                    imagePath: Icons.quiz_outlined,
                                    onPressed: () async {
                                      await context.pushNamed(
                                        AppRoutes.supportScreen,
                                      );
                                    },
                                  ),
                                  ProfileButtonWidget(
                                    text: 'privacy_policy'.tr(context),
                                    imagePath: Icons.lock_outlined,
                                    onPressed: () async {
                                      await context.pushNamed(
                                        AppRoutes.privacyPolicyScreen,
                                      );
                                    },
                                  ),
                                  ProfileButtonWidget(
                                    text: 'delete_account'.tr(context),
                                    imagePath: Icons.delete_outline_rounded,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) =>
                                            ActionConfirmationDialog(
                                              title:
                                                  'Are you sure you want to delete your account?',
                                              onConfirm: () async {
                                                try {
                                                  await context
                                                      .read<MainLayoutCubit>()
                                                      .deleteAccount();
                                                } catch (_) {}
                                                if (context.mounted) {
                                                  context
                                                      .read<MainLayoutCubit>()
                                                      .clearDataOnLogOut();
                                                }
                                                await context
                                                    .pushReplacementNamed(
                                                      AppRoutes.loginScreen,
                                                    );
                                              },
                                            ),
                                      );
                                    },
                                  ),

                                  ProfileButtonWidget(
                                    text: 'log_out'.tr(context),
                                    imagePath: Icons.logout,
                                    onPressed: () {
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) =>
                                              ActionConfirmationDialog(
                                                title:
                                                    'Are you sure you want to log out?',
                                                onConfirm: () async {
                                                  try {
                                                    if (dialogContext.mounted) {
                                                      await dialogContext
                                                          .read<LoginCubit>()
                                                          .logOut();
                                                    }
                                                  } catch (_) {}
                                                  if (dialogContext.mounted) {
                                                    dialogContext
                                                        .read<MainLayoutCubit>()
                                                        .clearDataOnLogOut();
                                                  }
                                                  await dialogContext
                                                      .pushReplacementNamed(
                                                        AppRoutes.loginScreen,
                                                      );
                                                },
                                              ),
                                        );
                                      }
                                    },
                                  ),
                                  8.verticalSpace,
                                ],
                              ),
                              16.verticalSpace,
                              const PoweredByWidget(),
                            ],
                          ),
                        ),
                      ),
                    );
                    // }
                    // return const SizedBox.shrink();
                  },
                );
        },
      ),
    );
  }
}

void subscripeDialogQuestionBank(BuildContext context) {
  return showCustomPrimaryDialog(
    context,
    widget: CustomPrimaryDialog(
      title: 'Subscription Required',
      description:
          'You cannot access. Renew your Question bank subscription to enjoy the benefits.',
      confirmText: 'Subscribe Now',
      onConfirm: () {
        context.pushNamed(
          AppRoutes.subscriptionScreen,
          arguments:
              context.read<MainLayoutCubit>().profileModel!.data!.offerId ?? -1,
        );
      },
    ),
  );
}

void subscripeDialog(BuildContext context) {
  return showCustomPrimaryDialog(
    context,
    widget: CustomPrimaryDialog(
      title: 'Subscription Required',
      description:
          'You cannot access. Renew your Realistic Exam Simulation subscription to enjoy the benefits.',
      confirmText: 'Subscribe Now',
      onConfirm: () {
        context.pushNamed(
          AppRoutes.subscriptionScreen,
          arguments:
              context.read<MainLayoutCubit>().profileModel!.data!.offerId ?? -1,
        );
      },
    ),
  );
}
