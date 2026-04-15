import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/home/widgets/category/analysis_widget.dart';
import 'package:smle/features/home/widgets/category/q_bank_widget.dart';
import 'package:smle/features/home/widgets/category/real_exam_widget.dart';
import 'package:smle/features/home/widgets/end_page_banner.dart';
import 'package:smle/features/home/widgets/top/home_chat_bar.dart';
import 'package:smle/features/home/widgets/top/user_and_points_header_widget.dart';
import 'package:smle/features/home/widgets/top_banner_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final actionBackground = theme.colorScheme.primary.withAlpha(40);
    final actionIconColor = theme.colorScheme.onSurface.withAlpha(250);
    final screenGradient = isDarkMode
        ? appGradientHelper
        : const LinearGradient(
            colors: [Color(0xFFF7F8FB), Color(0xFFECEFF4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );

    return Container(
      height: SizeConfig.screenHeight,
      decoration: BoxDecoration(gradient: screenGradient),
      child: BlocBuilder<CheckSubscriptionCubit, CheckSubscriptionState>(
        builder: (context, state) {
          final cubit = context
              .read<CheckSubscriptionCubit>()
              .checkSubscriptionModel;
          if (state is CheckSubscriptionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final sub = cubit;

          final isSubscribed = sub?.isSubscribed ?? false;
          final hasQBank = sub?.qBank ?? false;
          final availableExam = sub?.availableRealExam ?? '0';

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  55.verticalSpace,

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: UserAndPointsHeaderWidget()),
                      Container(
                        decoration: BoxDecoration(
                          color: actionBackground,
                          borderRadius: BorderRadius.circular(320.r),
                        ),
                        child: IconButton(
                          onPressed: () async =>
                              await context.pushNamed(AppRoutes.giftsScreen),
                          icon: Icon(
                            Icons.wallet_giftcard_rounded,
                            color: actionIconColor,
                            size: SizeConfig.responsiveValue(
                              phone: 20.r,
                              tablet: 16.r,
                            ),
                          ),
                        ),
                      ),

                      6.horizontalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: actionBackground,
                          borderRadius: BorderRadius.circular(320.r),
                        ),
                        child: Builder(
                          builder: (context) {
                            return IconButton(
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                              icon: Icon(
                                Icons.menu,
                                color: actionIconColor,
                                size: SizeConfig.responsiveValue(
                                  phone: 20.r,
                                  tablet: 16.r,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  48.verticalSpace,
                  const TopBannerWidget(),
                  HomeChatBar(
                    isActive:
                        context
                            .read<CheckSubscriptionCubit>()
                            .checkAiAccessModel
                            ?.status ??
                        false,
                  ),
                  8.verticalSpace,
                  Text(
                    'Top Category',
                    style: AppTextStyle.style18Bold.copyWith(
                      color: actionIconColor,
                    ),
                  ),
                  12.verticalSpace,

                  Row(
                    spacing: 8.w,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: RealExamHomeWidget(
                          isSubscribed: isSubscribed,
                          availableExam: availableExam.toString(),
                        ),
                      ),
                    ],
                  ),

                  12.verticalSpace,

                  Row(
                    spacing: 8.w,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: QBankHomeWidget(
                          isSubscribed: isSubscribed,
                          hasQBank: hasQBank,
                        ),
                      ),
                      Expanded(
                        child: AnalysisHomeWidget(isSubscribed: isSubscribed),
                      ),
                    ],
                  ),

                  32.verticalSpace,
                  const EndPageBanner(),
                  20.verticalSpace,
                ],
              ),
            ),
          );
        },
      ),
      // ),
    );
  }
}
