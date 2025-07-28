import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/onboarding/widgets/app_journey_dot.dart';
import 'package:smle/features/onboarding/widgets/next_button.dart';
import 'package:smle/features/onboarding/widgets/onboarding_text.dart';
import 'package:smle/features/onboarding/widgets/skip_button.dart';
import 'package:smle/features/splash/cubit/global_cubit/global_cubit.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/constants.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/assets.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlobalCubit, GlobalStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return SafeArea(
              child: Scaffold(
                  body: PageView.builder(
            itemCount: 3,
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                context.read<GlobalCubit>().onBoardingIndex == 0
                                    ? Assets.onBoarding1
                                    : context
                                                .read<GlobalCubit>()
                                                .onBoardingIndex ==
                                            1
                                        ? Assets.onBoarding2
                                        : Assets.onBoarding3),
                            fit: BoxFit.fill)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 15.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if(context.read<GlobalCubit>().onBoardingIndex==2)
                            Align(
                              alignment:Alignment.topLeft,
                              child: Text('sign_up'.tr(context),
                                  style:  interBold.copyWith(
                                    color: AppColors.secondaryColor,
                                    fontSize: 20.sp,
                                  )),
                            ),
                          const OnBoardingText(),
                          20.verticalSpace,
                          SizedBox(
                            height: 15.h,
                            child: CustomJourneyDot(activeIndex: context.read<GlobalCubit>().onBoardingIndex,
                              count: 3,),
                          ),
                        20.verticalSpace,
                           NextButton(
                             onTap: (){
                               if (context
                                   .read<GlobalCubit>()
                                   .onBoardingIndex ==
                                   2) {
                                 context.pushReplacementNamed(Routes.loginScreen);
                                 CacheHelper.sharedPreferences
                                     .setBool(
                                    firstTimeRun,
                                     true);
                               } else if (context
                                   .read<GlobalCubit>()
                                   .onBoardingIndex ==
                                   0) {
                                 _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.ease);
                               } else if (context
                                   .read<GlobalCubit>()
                                   .onBoardingIndex ==
                                   1) {
                                 _pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.ease);
                               }
                             },)
                        ],
                      ),
                    ),
                  ),
                  const SkipButton()
                ],
              );
            },
            onPageChanged: (index) {
              debugPrint('$index');
              context.read<GlobalCubit>().setOnBoardingIndex(index);
            },
          )));
        });
  }
}
