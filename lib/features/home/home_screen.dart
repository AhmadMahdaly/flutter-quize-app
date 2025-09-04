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
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      name:
                          context
                                  .watch<MainLayoutCubit>()
                                  .profileModel
                                  ?.data
                                  ?.name ==
                              null
                          ? 'User'
                          : context
                                    .watch<MainLayoutCubit>()
                                    .profileModel
                                    ?.data
                                    ?.name ??
                                '',
                      email:
                          context
                              .read<MainLayoutCubit>()
                              .profileModel
                              ?.data
                              ?.email ??
                          '',
                      imagePath: Assets.logoCircle,
                      // context
                      //     .read<MainLayoutCubit>()
                      //     .profileModel
                      //     ?.data
                      //     ?.photo ??
                      // '',
                      points:
                          context
                                  .read<MainLayoutCubit>()
                                  .profileModel
                                  ?.data
                                  ?.points ==
                              null
                          ? ''
                          : '${context.read<MainLayoutCubit>().profileModel?.data?.points}',
                    ),
              32.verticalSpace,
              const TopBannerWidget(),
              20.verticalSpace,
              Text(
                'top_category'.tr(context),
                style: interBold.copyWith(
                  fontSize: SizeConfig.responsiveValue(
                    phone: 20.sp,
                    tablet: 26.sp,
                  ),
                ),
              ),
              20.verticalSpace,
              Row(
                spacing: 8.w,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CategoryWidget(
                      onTap: () {
                        isGuest
                            ? showCustomPrimaryDialog(
                                context,
                                widget: const GuestLoginDialog(),
                              )
                            : context.pushNamed(Routes.createQuizScreen);
                      },
                      categoryName: 'question_bank'.tr(context),
                      imagePath: Assets.questionBank,
                    ),
                  ),
                  Expanded(
                    child: CategoryWidget(
                      onTap: () {
                        isGuest
                            ? showCustomPrimaryDialog(
                                context,
                                widget: const GuestLoginDialog(),
                              )
                            : context.pushNamed(Routes.categoriesScreen);
                      },
                      categoryName: 'revision'.tr(context),
                      imagePath: Assets.revisionCategory,
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
                    child: CategoryWidget(
                      onTap: () {
                        final examState = getIt<RealExamCubit>().state;

                        final bool isExamInProgress =
                            examState.status == ExamStatus.success ||
                            examState.status == ExamStatus.onBreak;
                        if (isGuest) {
                          showCustomPrimaryDialog(
                            context,
                            widget: const GuestLoginDialog(),
                          );
                        } else if (isExamInProgress) {
                          context.pushNamed(Routes.realExamScreen);
                        } else {
                          showCustomPrimaryDialog(
                            context,
                            widget: const ConfirmAccessToRealExamDialogWidget(),
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
                        isGuest
                            ? showCustomPrimaryDialog(
                                context,
                                widget: const GuestLoginDialog(),
                              )
                            : context.pushNamed(Routes.analysisScreen,arguments: false);
                      },
                      categoryName: 'analysis'.tr(context),
                      imagePath: Assets.analysisCategory,
                    ),
                  ),
                ],
              ),
              30.verticalSpace,
              isGuest
                  ?const SizedBox(): const EndPageBanner(),
              60.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
