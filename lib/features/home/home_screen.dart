import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/category_widget.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/guest/guest_login_dialog.dart';
import 'package:smle/features/home/widgets/confirm_dialog.dart';
import 'package:smle/features/home/widgets/drawer_widget.dart';
import 'package:smle/features/home/widgets/end_page_banner.dart';
import 'package:smle/features/home/widgets/home_app_bar_widget.dart';
import 'package:smle/features/home/widgets/top_banner_widget.dart';
import 'package:smle/features/home/widgets/user_image_name_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.isGuest});
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckSubscriptionCubit(getIt())..loadSubscription(),
      child: Scaffold(
        appBar: isGuest
            ? AppBar(
          leading: IconButton(
            onPressed: () {
              context.pushReplacementNamed(Routes.loginScreen);
            },
            icon: const RotatedBox(
              quarterTurns: 2,
              child: Icon(Icons.logout_outlined),
            ),
          ),
          iconTheme: IconThemeData(
            color: AppColors.iconColorBlack,
            size: SizeConfig.responsiveValue(phone: 24.sp, tablet: 28.sp),
          ),
        )
            : const HomeAppBarWidget(),
        drawer: isGuest ? null : const DrawerWidget(),
        body: BlocBuilder<CheckSubscriptionCubit, CheckSubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SubscriptionLoaded) {
              final sub = state.subscription;

              // 👇 الحالة unsubscribed أو data == null
              final isSubscribed = sub.isSubscribed ?? false;
              final hasQBank = sub.qBank ?? false;
              final availableExam = sub.availableRealExam ?? "0";

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==== Header ====
                      isGuest
                          ? Text(
                        '${'welcome'.tr(context)} Guest',
                        style: interBold.copyWith(
                          fontSize: SizeConfig.responsiveValue(
                            phone: 18.sp,
                            tablet: 24.sp,
                          ),
                        ),
                      )
                          : UserImageNameWidget(
                        name: context
                            .watch<MainLayoutCubit>()
                            .profileModel
                            ?.data
                            ?.name ??
                            'User',
                        email: context
                            .read<MainLayoutCubit>()
                            .profileModel
                            ?.data
                            ?.email ??
                            '',
                        imagePath: Assets.logoCircle,
                        points: '${context.read<MainLayoutCubit>().profileModel?.data?.points ?? ''}',
                      ),

                      32.verticalSpace,
                      const TopBannerWidget(),
                      20.verticalSpace,

                      // ==== Category Title ====
                      Text(
                        'top_category'.tr(context),
                        style: interBold.copyWith(
                          fontSize: SizeConfig.responsiveValue(
                            phone: 18.sp,
                            tablet: 24.sp,
                          ),
                        ),
                      ),
                      20.verticalSpace,

                      // ==== Question Bank Category ====
                      Row(
                        spacing: 8.w,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CategoryWidget(
                              onTap: () {
                                if (isGuest) {
                                  showCustomPrimaryDialog(
                                    context,
                                    widget: const GuestLoginDialog(),
                                  );
                                  return;
                                }

                                // ✅ إذا غير مشترك أو الـ data null
                                if (!isSubscribed || !hasQBank) {
                                  showCustomPrimaryDialog(
                                    context,
                                    widget: CustomPrimaryDialog(
                                      title: 'Subscription Required',
                                      description:
                                      'You cannot access the Question bank. Renew your subscription to enjoy the benefits.',
                                      confirmText: 'Subscribe Now',
                                      onConfirm: () {
                                        context.pushNamed(
                                          Routes.subscriptionScreen,
                                          arguments: context
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

                                context.pushNamed(Routes.createQuizScreen);
                              },
                              categoryName: 'question_bank'.tr(context),
                              imagePath: Assets.questionBank,
                            ),
                          ),
                        ],
                      ),

                      10.verticalSpace,

                      // ==== Real Exam & Analysis ====
                      Row(
                        spacing: 8.w,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CategoryWidget(
                              onTap: () {
                                if (isGuest) {
                                  showCustomPrimaryDialog(
                                    context,
                                    widget: const GuestLoginDialog(),
                                  );
                                  return;
                                }

                                if (!isSubscribed) {
                                  showCustomPrimaryDialog(
                                    context,
                                    widget: CustomPrimaryDialog(
                                      title: 'Subscription Required',
                                      description:
                                      'Subscribe to access the real exams.',
                                      confirmText: 'Subscribe Now',
                                      onConfirm: () {
                                        context.pushNamed(
                                          Routes.subscriptionScreen,
                                          arguments: context
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

                                // ✅ حالة الامتحانات
                                if (availableExam == 'Unlimited' ||
                                    (int.tryParse(availableExam) ?? 0) > 0) {
                                  final examState = getIt<RealExamCubit>().state;
                                  final bool isExamInProgress =
                                      examState.status == ExamStatus.success ||
                                          examState.status == ExamStatus.onBreak;

                                  if (isExamInProgress) {
                                    context.pushNamed(Routes.realExamScreen);
                                  } else {
                                    showCustomPrimaryDialog(
                                      context,
                                      widget:
                                      const ConfirmAccessToRealExamDialogWidget(),
                                    );
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
                                        context.pushNamed(
                                          Routes.subscriptionScreen,
                                          arguments: context
                                              .read<MainLayoutCubit>()
                                              .profileModel!
                                              .data!
                                              .offerId ??
                                              -1,
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              categoryName: 'real_exam'.tr(context),
                              imagePath: Assets.examCategory,
                            ),
                          ),
                          Expanded(
                            child: CategoryWidget(
                              onTap: () {
                                if (isGuest) {
                                  showCustomPrimaryDialog(
                                    context,
                                    widget: const GuestLoginDialog(),
                                  );
                                } else if (!isSubscribed) {
    showCustomPrimaryDialog(
    context,
    widget: CustomPrimaryDialog(
    title: 'Subscription Required',
    description:
    'Subscribe to access the analysis.',
    confirmText: 'Subscribe Now',
    onConfirm: () {
    context.pushNamed(
    Routes.subscriptionScreen,
    arguments: context
        .read<MainLayoutCubit>()
        .profileModel!
        .data!
        .offerId ??
    -1,
    );
    },
    ),
    );}else{
                                  context.pushNamed(
                                    Routes.analysisScreen,
                                    arguments: false,
                                  );
                                }
                              },
                              categoryName: 'analysis'.tr(context),
                              imagePath: Assets.analysisCategory,
                            ),
                          ),
                        ],
                      ),

                      30.verticalSpace,
                      if (!isGuest) const EndPageBanner(),
                      60.verticalSpace,
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
