import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/action_confirmation_dialog.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/home/widgets/drawer/drawer_item_widget.dart';
import 'package:smle/features/login/cubit/login_cubit.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.thirdColor,
      width: MediaQuery.of(context).size.width / 1.2,
      child: ListView(
        children: [
          // Drawer Items
          // DrawerItemWidget(
          //   iconAsset: Assets.userCircleLight,
          //   title: 'profile'.tr(context),
          //   onTap: () {
          //     context.pushNamed(Routes.profileScreen);
          //   },
          // ),
          DrawerItemWidget(
            iconAsset: Assets.mortarboardLight,
            title: 'SCFHS_score_calculator'.tr(context),
            onTap: () {
              context.pushNamed(AppRoutes.sCFHSScoreCalculatorScreen);
            },
          ),
          // if (Platform.isIOS)
          DrawerItemWidget(
            iconAsset: Assets.trophyLight,
            title: 'subscription'.tr(context),
            onTap: () {
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

          BlocBuilder<CheckSubscriptionCubit, CheckSubscriptionState>(
            builder: (context, state) {
              if (state is SubscriptionLoaded) {
                final sub = state.subscription;

                final isSubscribed = sub.isSubscribed ?? false;

                return DrawerItemWidget(
                  iconAsset: Assets.columUpLight,
                  title: 'analysis'.tr(context),
                  onTap: !isSubscribed
                      ? () => showCustomPrimaryDialog(
                          context,
                          widget: CustomPrimaryDialog(
                            title: 'Subscription Required',
                            description: 'Subscribe to access.',
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
                        )
                      : () {
                          context.pushNamed(
                            AppRoutes.analysisScreen,
                            arguments: false,
                          );
                        },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          DrawerItemWidget(
            iconAsset: Assets.questionLight,
            title: 'support'.tr(context),
            onTap: () {
              context.pushNamed(AppRoutes.supportScreen);
            },
          ),
          DrawerItemWidget(
            iconAsset: Assets.privacyPolicy,
            title: 'privacy_policy'.tr(context),
            onTap: () {
              context.pushNamed(AppRoutes.privacyPolicyScreen);
            },
          ),
          BlocProvider(
            create: (context) => LoginCubit(getIt()),
            child: BlocBuilder<LoginCubit, LoginStates>(
              builder: (context, state) {
                return DrawerItemWidget(
                  iconAsset: Assets.logOut,
                  title: 'log_out'.tr(context),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => ActionConfirmationDialog(
                        title: 'Are you sure you want to log out?',
                        onConfirm: () async {
                          try {
                            await context.read<LoginCubit>().logOut();
                          } catch (_) {}

                          CacheHelper.sharedPreferences.remove(
                            CacheKeys.userToken,
                          );
                          context.pushReplacementNamed(AppRoutes.loginScreen);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
