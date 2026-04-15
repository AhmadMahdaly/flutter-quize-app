import 'package:flutter/cupertino.dart';
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
import 'package:smle/core/shared_widgets/custom_cache_image.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/core/shared_widgets/powered_by_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/core/theme/theme_controller.dart';
import 'package:smle/features/auth/cubit/login_cubit.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/home/widgets/drawer/drawer_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/main%20layout/data/model/profile_model.dart';
import 'package:smle/features/profile/widgets/profile_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenGradient = isDarkMode
        ? appGradientHelper
        : const LinearGradient(
            colors: [Color(0xFFF7F8FB), Color(0xFFECEFF4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );
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
                    if (state is CheckSubscriptionsLoading) {
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
                                color: theme.colorScheme.secondary,
                                size: SizeConfig.responsiveValue(
                                  phone: 24.r,
                                  tablet: 16.r,
                                ),
                              ),
                            );
                          },
                        ),
                        iconAction: InkWell(
                          borderRadius: BorderRadius.circular(50.r),
                          onTap: () async {
                            await context.pushNamed(
                              AppRoutes.updateProfileScreen,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Icon(
                              CupertinoIcons.settings_solid,
                              size: 24.r,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      body: Container(
                        decoration: BoxDecoration(gradient: screenGradient),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            // vertical: 16.h,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UserDataWidget(theme: theme, data: data),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12.h,
                                    horizontal: 16.w,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: theme.colorScheme.primary.withAlpha(
                                      40,
                                    ),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withAlpha(
                                    //       isDarkMode ? 55 : 20,
                                    //     ),
                                    //     blurRadius: 10,
                                    //     offset: const Offset(0, 5),
                                    //   ),
                                    // ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!isSubscribed)
                                        Text(
                                          'You don’t have an active subscription.',
                                          // textAlign: TextAlign.center,
                                          style: AppTextStyle.style14W900
                                              .copyWith(
                                                color:
                                                    theme.colorScheme.secondary,
                                              ),
                                        )
                                      else
                                        Text(
                                          'Subscription Info:',
                                          style: AppTextStyle.style18Bold
                                              .copyWith(
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                        ),

                                      12.verticalSpace,

                                      /// Data Items
                                      if (offerName != null)
                                        _buildItem(
                                          context,
                                          Icons.calendar_today,
                                          'Package',
                                          offerName,
                                        ),
                                      if (createdAt != null)
                                        _buildItem(
                                          context,
                                          Icons.date_range,
                                          'Created',
                                          createdAt,
                                        ),
                                      if (expireDate != null)
                                        _buildItem(
                                          context,
                                          Icons.event_busy,
                                          'Expires',
                                          expireDate,
                                        ),

                                      // Divider(
                                      //   color: theme.colorScheme.onSurface
                                      //       .withAlpha(120),
                                      //   height: 12.h,
                                      // ),

                                      /// Highlighted Section
                                      if (expireDate != null)
                                        _buildHighlightItem(
                                          context,
                                          Icons.timer,
                                          'Remaining Days',
                                          '${calculateRemainingDaysFromString(expireDate)} days',
                                        ),
                                      if (availableExam != '0')
                                        _buildHighlightItem(
                                          context,
                                          Icons.school,
                                          'Exams Left',
                                          '$availableExam exams',
                                        ),
                                    ],
                                  ),
                                ),
                                12.verticalSpace,
                                Column(
                                  spacing: 8.h,
                                  children: [
                                    DarkModeButton(
                                      isDarkMode: isDarkMode,
                                      theme: theme,
                                    ),
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
                                    // ProfileButtonWidget(
                                    //   text: 'Edit Account',
                                    //   imagePath: Icons.verified_user_outlined,
                                    //   onPressed: () async {
                                    //     await context.pushNamed(
                                    //       AppRoutes.updateProfileScreen,
                                    //     );
                                    //   },
                                    // ),
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
                                                      if (dialogContext
                                                          .mounted) {
                                                        await dialogContext
                                                            .read<LoginCubit>()
                                                            .logOut();
                                                      }
                                                    } catch (_) {}
                                                    if (dialogContext.mounted) {
                                                      dialogContext
                                                          .read<
                                                            MainLayoutCubit
                                                          >()
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

                                // 8.verticalSpace,
                                // Center(
                                //   child: InkWell(
                                //     borderRadius: BorderRadius.circular(12.r),
                                //     onTap: _launchUpdateUrl,
                                //     child: Container(
                                //       padding: EdgeInsets.symmetric(
                                //         horizontal: 16.w,
                                //       ),
                                //       height: SizeConfig.responsiveValue(
                                //         phone: 50.h,
                                //         tablet: 48.h,
                                //       ),
                                //       width: double.infinity,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(12.r),
                                //         border: Border.all(
                                //           color: AppColors.darkGreyColor
                                //               .withAlpha(100),
                                //         ),
                                //       ),
                                //       child: Row(
                                //         children: [
                                //           Image.asset(
                                //             'assets/images/icons/telegram_logo.png',
                                //             height: 40.h,
                                //           ),
                                //           8.horizontalSpace,
                                //           Text(
                                //             'Join us on Telegram to stay updated',
                                //             style: AppTextStyle.style14Bold
                                //                 .copyWith(
                                //                   color: AppColors.darkGreyColor,
                                //                 ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                16.verticalSpace,
                                const PoweredByWidget(),
                              ],
                            ),
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

class UserDataWidget extends StatelessWidget {
  const UserDataWidget({super.key, required this.theme, required this.data});

  final ThemeData theme;
  final Data data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: theme.colorScheme.primary.withAlpha(77),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: theme.colorScheme.surface.withAlpha(190),
                // backgroundImage:
                //     (data.photo != null &&
                //         data.photo!.isNotEmpty)
                //     ?
                //     : null,
                child: (data.photo == null || data.photo!.isEmpty)
                    ? Icon(
                        Icons.person,
                        size: 25.r,
                        color: theme.colorScheme.onSurface.withAlpha(160),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(320.r),
                        child: CustomCacheImageWidget(imageUrl: data.photo!),
                      ),
              ),

              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.name}',
                      style: AppTextStyle.style18Bold.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(210),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '${data.points} ',
                          style: AppTextStyle.style14Bold.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        Text(
                          'Points',
                          style: AppTextStyle.style12Bold.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(170),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              12.horizontalSpace,

              Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: _launchUpdateUrl,
                  child: Image.asset(
                    'assets/images/icons/telegram_logo.png',
                    height: 40.h,
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: data.email ?? ''));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Email copied'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.secondary.withAlpha(120),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${data.email}',
                      style: AppTextStyle.style14W700.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.copy,
                    size: 20.r,
                    color: theme.colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ),
          // 6.verticalSpace,
        ],
      ),
    );
  }
}

class DarkModeButton extends StatelessWidget {
  const DarkModeButton({
    super.key,
    required this.isDarkMode,
    required this.theme,
  });

  final bool isDarkMode;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ProfileButtonWidget(
      text: 'Dark Mode',
      imagePath: Icons.palette_outlined,
      onPressed: ThemeController.toggle,
      trailing: SizedBox(
        width: 70.w,
        height: 30.h,
        child: GestureDetector(
          onTap: ThemeController.toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? theme.colorScheme.secondary.withAlpha(50)
                  : theme.colorScheme.surface.withAlpha(220),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: isDarkMode
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.onSurface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  size: 16.r,
                  color: isDarkMode
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                ),
              ),
            ),
          ),
        ),
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

Widget _buildItem(
  BuildContext context,
  IconData icon,
  String title,
  String value,
) {
  final theme = Theme.of(context);
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      children: [
        Icon(icon, color: theme.colorScheme.secondary, size: 20.r),
        10.horizontalSpace,
        Text(
          '$title:',
          style: AppTextStyle.style12W500.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyle.style12Bold.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(210),
          ),
        ),
      ],
    ),
  );
}

Widget _buildHighlightItem(
  BuildContext context,
  IconData icon,
  String title,
  String value,
) {
  final theme = Theme.of(context);
  return Container(
    margin: EdgeInsets.symmetric(vertical: 4.h),
    padding: EdgeInsets.all(8.r),
    decoration: BoxDecoration(
      border: Border.all(color: theme.colorScheme.primary.withAlpha(77)),

      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        Icon(icon, color: theme.colorScheme.secondary),
        10.horizontalSpace,
        Text(
          title,
          style: AppTextStyle.style12W500.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyle.style12Bold.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    ),
  );
}
