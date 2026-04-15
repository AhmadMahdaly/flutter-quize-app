import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/action_confirmation_dialog.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/auth/cubit/login_cubit.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/home/widgets/drawer/drawer_item_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/profile/profile_screen.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      width: MediaQuery.of(context).size.width / 1.2,
      child: BlocBuilder<CheckSubscriptionCubit, CheckSubscriptionState>(
        builder: (context, state) {
          final cubit = context.read<CheckSubscriptionCubit>();
          return ListView(
            children: [
              32.verticalSpace,
              Padding(
                padding: EdgeInsets.only(right: 40.w, left: 16.w),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/png/logo.png',
                      height: SizeConfig.responsiveValue(
                        phone: 60.h,
                        tablet: 30.h,
                      ),
                      // color: AppColors.secondaryColor.withAlpha(100),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Text(
                        'Get a seamless experience for your tests.',
                        style: AppTextStyle.style18Bold.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              16.verticalSpace,
              Divider(color: theme.colorScheme.secondary.withAlpha(100)),
              DrawerItemWidget(
                text: 'Question Bank',
                imagePath: Icons.ballot_outlined,
                onPressed: () {
                  if (!cubit.isSubscribed || !cubit.hasQBank) {
                    showCustomPrimaryDialog(
                      context,
                      widget: CustomPrimaryDialog(
                        title: 'Subscription Required',
                        description:
                            'You cannot access the Question bank. Renew your subscription to enjoy the benefits.',
                        confirmText: 'Subscribe Now',
                        onConfirm: () {
                          context.pushNamed(
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
                    );
                    return;
                  }
                  context.pop();
                  if (context.mounted) {
                    context.pushNamed(AppRoutes.createQuizScreen);
                  }
                },
              ),
              DrawerItemWidget(
                text: 'Realistic Exam Simulation',
                imagePath: Icons.edit_note_rounded,
                onPressed: () {
                  if (!cubit.isSubscribed) {
                    showCustomPrimaryDialog(
                      context,
                      widget: CustomPrimaryDialog(
                        title: 'Subscription Required',
                        description: 'Subscribe to access the real exams.',
                        confirmText: 'Subscribe Now',
                        onConfirm: () {
                          context.pushNamed(
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
                    );
                    return;
                  }

                  if (cubit.availableExam == 'Unlimited' ||
                      (int.tryParse(cubit.availableExam) ?? 0) > 0) {
                    final examState = getIt<RealExamCubit>().state;
                    final bool isExamInProgress =
                        examState.status == ExamStatus.success ||
                        examState.status == ExamStatus.onBreak;

                    if (isExamInProgress) {
                      context.pop();
                      if (context.mounted) {
                        context.pushNamed(AppRoutes.realExamScreen);
                      }
                    } else {
                      context.pop();
                      if (context.mounted) {
                        context.pushNamed(AppRoutes.confirmAccessToRealExam);
                      }
                    }
                  } else {
                    showCustomPrimaryDialog(
                      context,
                      widget: CustomPrimaryDialog(
                        title: 'Your Attempts Have Ended',
                        description:
                            'You’ve used all the real exams available to you. Please renew your subscription to continue.',
                        confirmText: 'Subscribe Now',
                        onConfirm: () {
                          context.pop();
                          if (context.mounted) {
                            context.pushNamed(
                              AppRoutes.subscriptionScreen,
                              arguments:
                                  context
                                      .read<MainLayoutCubit>()
                                      .profileModel!
                                      .data!
                                      .offerId ??
                                  -1,
                            );
                          }
                        },
                      ),
                    );
                  }
                },
              ),
              DrawerItemWidget(
                text: 'SCFHS Score Calculator',
                imagePath: Icons.calculate_outlined,
                onPressed: () async {
                  context.pop();

                  if (context.mounted) {
                    await context.pushNamed(
                      AppRoutes.sCFHSScoreCalculatorScreen,
                    );
                  }
                },
              ),
              DrawerItemWidget(
                text: 'Leaderboard',
                imagePath: Icons.leaderboard_outlined,
                onPressed: () {
                  if (!cubit.isSubscribed) {
                    showCustomPrimaryDialog(
                      context,
                      widget: CustomPrimaryDialog(
                        title: 'Subscription Required',
                        description:
                            'You cannot access the Leaderboard. Renew your subscription to enjoy the benefits.',
                        confirmText: 'Subscribe Now',
                        onConfirm: () {
                          context.pushNamed(
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
                    );
                    return;
                  }
                  context.pop();
                  if (context.mounted) {
                    context.pushNamed(AppRoutes.leaderboardScreen);
                  }
                },
              ),
              DrawerItemWidget(
                text: 'Playlist',
                imagePath: Icons.playlist_add_check_circle_outlined,
                onPressed: !cubit.isSubscribed
                    ? () async => subscripeDialogQuestionBank(context)
                    : () async {
                        context.pop();
                        if (context.mounted) {
                          await context.pushNamed(
                            AppRoutes.playListScreen,
                            arguments: {'questionId': 0, 'isAdd': true},
                          );
                        }
                      },
              ),
              DrawerItemWidget(
                text: 'Exams History',
                imagePath: Icons.history,
                onPressed: !cubit.isSubscribed
                    ? () async => subscripeDialog(context)
                    : () async {
                        context.pop();
                        if (context.mounted) {
                          await context.pushNamed(AppRoutes.examsHistoryScreen);
                        }
                      },
              ),
              DrawerItemWidget(
                text: 'Exams Analysis',
                imagePath: Icons.line_axis_outlined,
                onPressed: !cubit.isSubscribed
                    ? () async => subscripeDialog(context)
                    : () async {
                        context.pop();
                        if (context.mounted) {
                          await context.pushNamed(
                            AppRoutes.analysisDashboardScreen,
                          );
                        }
                      },
              ),
              DrawerItemWidget(
                text: 'Subscription',
                imagePath: Icons.payment,
                onPressed: () async {
                  context.pop();
                  if (context.mounted) {
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
                  }
                },
              ),
              DrawerItemWidget(
                text: 'Gifts',
                imagePath: Icons.card_giftcard_rounded,
                onPressed: () async {
                  context.pop();
                  if (context.mounted) {
                    await context.pushNamed(AppRoutes.giftsScreen);
                  }
                },
              ),
              DrawerItemWidget(
                text: 'Edit Account',
                imagePath: Icons.verified_user_outlined,
                onPressed: () async {
                  context.pop();
                  if (context.mounted) {
                    await context.pushNamed(AppRoutes.updateProfileScreen);
                  }
                },
              ),
              BlocProvider.value(
                value: getIt<LoginCubit>(),
                child: BlocBuilder<LoginCubit, LoginStates>(
                  builder: (context, state) {
                    return DrawerItemWidget(
                      imagePath: Icons.logout,
                      text: 'Log out',
                      onPressed: () async {
                        context.pop();
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (dialogContext) =>
                                ActionConfirmationDialog(
                                  title: 'Are you sure you want to log out?',
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
                                    await dialogContext.pushReplacementNamed(
                                      AppRoutes.loginScreen,
                                    );
                                  },
                                ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
