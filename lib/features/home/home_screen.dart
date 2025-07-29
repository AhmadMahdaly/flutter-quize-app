import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/core/shared_widgets/category_widget.dart';
import 'package:smle/features/home/widgets/drawer_widget.dart';
import 'package:smle/features/home/widgets/home_app_bar_widget.dart';
import 'package:smle/features/home/widgets/user_image_name_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

import '../../core/theme/assets.dart';
import '../../core/theme/colors.dart';

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
              BlocBuilder<MainLayoutCubit, MainLayoutState>(
                builder: (context, state) {
                  return context.read<MainLayoutCubit>().profileModel != null
                      ? UserImageNameWidget(
                          name: context
                                  .read<MainLayoutCubit>()
                                  .profileModel!
                                  .data!
                                  .name ??
                              '',
                          email: context
                                  .read<MainLayoutCubit>()
                                  .profileModel!
                                  .data!
                                  .email ??
                              '',
                          imagePath: context
                                  .read<MainLayoutCubit>()
                                  .profileModel!
                                  .data!
                                  .photo ??
                              '',
                          points:
                              '${context.read<MainLayoutCubit>().profileModel!.data!.points}',
                        )
                      : const SizedBox.shrink();
                },
              ),
              20.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.darkGreyColor,
                  borderRadius: BorderRadius.all(Radius.circular(80.r)),
                ),
                child: Row(
                  children: [
                    Expanded( // <-- This lets the text take the remaining space
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Over ',
                              style: interBold.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.thirdColor,
                              ),
                            ),
                            TextSpan(
                              text: '400 ',
                              style: interBold.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            TextSpan(
                              text: 'questions across all medical specialties',
                              style: interBold.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.thirdColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    10.horizontalSpace, // Optional spacing
                    Image.asset(
                      Assets.homeDoctor,
                      width: 100.w, // <-- Constrain image width
                      height: 150.h,
                      fit: BoxFit.fitHeight,
                    ),
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
              Stack(
                clipBehavior: Clip
                    .none, // Ensures the crown can extend beyond the container
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(70.r)),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.pushNamed(Routes.subscriptionScreen,arguments: context.read<MainLayoutCubit>().profileModel!.data!.offerId??-1);
                      },
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '${'now'.tr(context)}\n',
                            style: interBold.copyWith(fontSize: 16.sp),
                          ),
                          TextSpan(
                            text: "${'flashback_discount'.tr(context)}\n",
                            style: interRegular.copyWith(fontSize: 16.sp),
                          ),
                          TextSpan(
                            text:
                                '                      ${'discover_now'.tr(context)}',
                            style: interRegular.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.secondaryColor),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -10.h, // Moves the image slightly above the container
                    right: 0, // Aligns it to the right
                    child: Image(
                      image: const AssetImage(Assets.crownHome),
                      width: 60.w, // Adjust width as needed
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
