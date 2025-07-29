import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/category_widget.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/home/widgets/drawer_widget.dart';
import 'package:smle/features/home/widgets/home_app_bar_widget.dart';
import 'package:smle/features/home/widgets/user_image_name_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBarWidget(),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserImageNameWidget(
                name:
                    context.watch<MainLayoutCubit>().profileModel?.data?.name ==
                            null
                        ? 'Welcome User'
                        : context
                                .watch<MainLayoutCubit>()
                                .profileModel
                                ?.data
                                ?.name ??
                            '',
                email:
                    context.read<MainLayoutCubit>().profileModel?.data?.email ??
                        '',
                imagePath:
                    context.read<MainLayoutCubit>().profileModel?.data?.photo ??
                        '',
                point: context
                            .read<MainLayoutCubit>()
                            .profileModel
                            ?.data
                            ?.points ==
                        null
                    ? ''
                    : '${context.read<MainLayoutCubit>().profileModel?.data?.points.toString()} ${'points'.tr(context)}',
              ),
              20.verticalSpace,
              Container(
                clipBehavior: Clip.none,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    color: AppColors.darkGreyColor,
                    borderRadius: BorderRadius.all(Radius.circular(100.r))),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(28.r),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width - 175,
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: 'Over ',
                                style: interBold.copyWith(
                                    fontSize: 16.sp,
                                    color: AppColors.thirdColor)),
                            TextSpan(
                                text: '400 ',
                                style: interBold.copyWith(
                                    fontSize: 16.sp,
                                    color: AppColors.secondaryColor)),
                            TextSpan(
                                text:
                                    'questions across all medical specialties',
                                style: interBold.copyWith(
                                    fontSize: 16.sp,
                                    color: AppColors.thirdColor)),
                          ]),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: -20,
                        child: Image.asset(
                          'assets/images/png/home_doctor.png',
                          height: 180.h,
                        ))
                  ],
                ),
              ),
              20.verticalSpace,
              Text(
                'top_category'.tr(context),
                style: interBold.copyWith(
                    fontSize: 16.sp, decoration: TextDecoration.underline),
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryWidget(
                    onTap: () {
                      context.pushNamed(Routes.createQuizScreen);
                    },
                    categoryName: 'question_bank'.tr(context),
                    imagePath: Assets.questionBank,
                  ),
                  CategoryWidget(
                    onTap: () {
                      context.pushNamed(Routes.categoriesScreen);
                    },
                    categoryName: 'revision'.tr(context),
                    imagePath: Assets.revisionCategory,
                  ),
                ],
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryWidget(
                    onTap: () {
                      context.pushNamed(Routes.realExamScreen);
                    },
                    categoryName: 'real_exam'.tr(context),
                    imagePath: Assets.examCategory,
                  ),
                  CategoryWidget(
                    onTap: () {
                      context.pushNamed(Routes.analysisScreen);
                    },
                    categoryName: 'analysis'.tr(context),
                    imagePath: Assets.analysisCategory,
                  ),
                ],
              ),
              30.verticalSpace,
              const EndPageBanner()
            ],
          ),
        ),
      ),
    );
  }
}

class EndPageBanner extends StatelessWidget {
  const EndPageBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior:
          Clip.none, // Ensures the crown can extend beyond the container
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(100.r)),
          ),
          child: GestureDetector(
            onTap: () {
              context.pushNamed(Routes.subscriptionScreen);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 16.h),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: '${'now'.tr(context)}\n',
                    style: interBold.copyWith(fontSize: 16.sp),
                  ),
                  TextSpan(
                    text: "${'flashback_discount'.tr(context)}\n",
                    style: interMedium.copyWith(fontSize: 16.sp),
                  ),
                  TextSpan(
                    text: '             ${'discover_now'.tr(context)}',
                    style: interRegular.copyWith(
                        fontSize: 16.sp, color: AppColors.secondaryColor),
                  ),
                ]),
              ),
            ),
          ),
        ),
        Positioned(
          top: -36.h, // Moves the image slightly above the container
          right: 0, // Aligns it to the right
          child: Image(
            image: const AssetImage(Assets.crownHome),
            width: 100.w, // Adjust width as needed
          ),
        ),
      ],
    );
  }
}
