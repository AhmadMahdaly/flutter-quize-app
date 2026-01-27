import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/home/widgets/category/analysis_widget.dart';
import 'package:smle/features/home/widgets/category/q_bank_widget.dart';
import 'package:smle/features/home/widgets/category/real_exam_widget.dart';
import 'package:smle/features/home/widgets/drawer/drawer_widget.dart';
import 'package:smle/features/home/widgets/end_page_banner.dart';
import 'package:smle/features/home/widgets/top/user_and_points_header_widget.dart';
import 'package:smle/features/home/widgets/top_banner_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); //, required this.isGuest
  // final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: const HomeAppBarWidget(),
        drawer: const DrawerWidget(),
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(
                  Icons.menu,
                  color: AppColors.iconColorGray,
                  size: SizeConfig.responsiveValue(phone: 24.r, tablet: 16.r),
                ),
              );
            },
          ),
        ),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                            child: RealExamHomeWidget(
                              isSubscribed: isSubscribed,
                              availableExam: availableExam.toString(),
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
                            child: QBankHomeWidget(
                              isSubscribed: isSubscribed,
                              hasQBank: hasQBank,
                            ),
                          ),
                          Expanded(
                            child: AnalysisHomeWidget(
                              isSubscribed: isSubscribed,
                            ),
                          ),
                        ],
                      ),

                      20.verticalSpace,
                      const EndPageBanner(),
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
