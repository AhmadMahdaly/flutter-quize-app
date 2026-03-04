import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/date_format.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/action_confirmation_dialog.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/core/shared_widgets/powered_by_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/auth/cubit/login_cubit.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/home/widgets/drawer/drawer_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/profile/widgets/profile_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  appBar: const CustomAppBar(title: 'Profile', canBack: false),
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
                        title: 'Profile',
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

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${data.email}',
                                            style: AppTextStyle.style14W500
                                                .copyWith(
                                                  color:
                                                      AppColors.darkGreyColor,
                                                ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.copy, size: 18.r),
                                          onPressed: () {
                                            Clipboard.setData(
                                              ClipboardData(
                                                text: data.email ?? '',
                                              ),
                                            );

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text('Email copied'),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    10.verticalSpace,
                                    if (!isSubscribed)
                                      Text(
                                        'You don’t have an active subscription.',
                                        // textAlign: TextAlign.center,
                                        style: AppTextStyle.style14W900
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                            ),
                                      ),
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
                                        '${"Expire Date:"} $expireDate',
                                        style: AppTextStyle.style12W700
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                            ),
                                      ),
                                    if (expireDate != null)
                                      Text(
                                        '${"Remaining subscription days:"} ${calculateRemainingDaysFromString(expireDate)} ${"days"}',
                                        style: AppTextStyle.style12W700
                                            .copyWith(
                                              color: AppColors.primaryColor,
                                            ),
                                      ),
                                    if (availableExam != '0')
                                      Text(
                                        '${"Remaining Realistic Exams Simulation:"} $availableExam ${"exams"}',
                                        style: AppTextStyle.style12W700
                                            .copyWith(
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
                                    text: 'Exams history',
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
                                    text: 'Subscription',
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
                                    text: 'Gifts',
                                    imagePath: Icons.card_giftcard_rounded,
                                    onPressed: () async {
                                      await context.pushNamed(
                                        AppRoutes.giftsScreen,
                                      );
                                    },
                                  ),

                                  ProfileButtonWidget(
                                    text: 'Support',
                                    imagePath: Icons.quiz_outlined,
                                    onPressed: () async {
                                      await context.pushNamed(
                                        AppRoutes.supportScreen,
                                      );
                                    },
                                  ),
                                  ProfileButtonWidget(
                                    text: 'Privacy Policy',
                                    imagePath: Icons.lock_outlined,
                                    onPressed: () async {
                                      await context.pushNamed(
                                        AppRoutes.privacyPolicyScreen,
                                      );
                                    },
                                  ),
                                  ProfileButtonWidget(
                                    text: 'Delete account',
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
                                    text: 'Log out',
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
                              8.verticalSpace,
                              Center(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12.r),
                                  onTap: _launchUpdateUrl,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    height: SizeConfig.responsiveValue(
                                      phone: 50.h,
                                      tablet: 48.h,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: AppColors.darkGreyColor
                                            .withAlpha(100),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/icons/telegram_logo.png',
                                          height: 40.h,
                                        ),
                                        8.horizontalSpace,
                                        Text(
                                          'Join us on Telegram to stay updated',
                                          style: AppTextStyle.style14Bold
                                              .copyWith(
                                                color: AppColors.darkGreyColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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

Future<void> _launchUpdateUrl() async {
  final Uri url = Uri.parse(
    'https://t.me/SmleGateChannel',
    // Theme.of(context).platform == TargetPlatform.iOS
    //     ? UpdateScreen.iosUrl
    //     : UpdateScreen.androidUrl,
  );
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    debugPrintWidget('Could not launch $url');
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
