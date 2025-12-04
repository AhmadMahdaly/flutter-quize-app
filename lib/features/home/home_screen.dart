import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/home/widgets/category/analysis_widget.dart';
import 'package:smle/features/home/widgets/category/q_bank_widget.dart';
import 'package:smle/features/home/widgets/category/real_exam_widget.dart';
import 'package:smle/features/home/widgets/drawer/drawer_widget.dart';
import 'package:smle/features/home/widgets/end_page_banner.dart';
import 'package:smle/features/home/widgets/top/home_app_bar_widget.dart';
import 'package:smle/features/home/widgets/top/user_and_points_header_widget.dart';
import 'package:smle/features/home/widgets/top_banner_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); //, required this.isGuest
  // final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBarWidget(),
      drawer: const DrawerWidget(),
      body: BlocBuilder<CheckSubscriptionCubit, CheckSubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubscriptionLoaded) {
            final sub = state.subscription;

            final isSubscribed = sub.isSubscribed ?? false;
            final hasQBank = sub.qBank ?? false;
            final availableExam = sub.availableRealExam ?? '0';

            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UserAndPointsHeaderWidget(),

                    32.verticalSpace,
                    const TopBannerWidget(),
                    20.verticalSpace,

                    Text('Top Category', style: AppTextStyle.style18Bold),
                    16.verticalSpace,

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
                      ],
                    ),

                    10.verticalSpace,

                    Row(
                      spacing: 8.w,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: RealExamHomeWidget(
                            isSubscribed: isSubscribed,
                            availableExam: availableExam,
                          ),
                        ),
                        Expanded(
                          child: AnalysisHomeWidget(isSubscribed: isSubscribed),
                        ),
                      ],
                    ),

                    20.verticalSpace,
                    const EndPageBanner(),
                    // 30.verticalSpace,
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
