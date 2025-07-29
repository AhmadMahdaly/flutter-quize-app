import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/category_widget.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/guest/guest_login_dialog.dart';
import 'package:smle/features/home/widgets/confirm_dialog.dart';
import 'package:smle/features/home/widgets/drawer_widget.dart';
import 'package:smle/features/home/widgets/end_page_banner.dart';
import 'package:smle/features/home/widgets/home_app_bar_widget.dart';
import 'package:smle/features/home/widgets/top_banner_widget.dart';
import 'package:smle/features/home/widgets/user_image_name_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.isGuest});
  final bool isGuest;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBarWidget(),
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
                      style: interBold.copyWith(fontSize: 18.sp),
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
                      imagePath:
                          context
                              .read<MainLayoutCubit>()
                              .profileModel
                              ?.data
                              ?.photo ??
                          '',
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
              20.verticalSpace,
              const TopBannerWidget(),
              20.verticalSpace,
              Text(
                'top_category'.tr(context),
                style: interBold.copyWith(fontSize: 20.sp),
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryWidget(
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
                  CategoryWidget(
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
                ],
              ),
              20.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryWidget(
                    onTap: () {
                      isGuest
                          ? showCustomPrimaryDialog(
                              context,
                              widget: const GuestLoginDialog(),
                            )
                          : showCustomPrimaryDialog(
                              context,
                              widget:
                                  const ConfirmAccessToRealExamDialogWidget(),
                            );
                    },
                    categoryName: 'real_exam'.tr(context),
                    imagePath: Assets.examCategory,
                  ),
                  CategoryWidget(
                    onTap: () {
                      isGuest
                          ? showCustomPrimaryDialog(
                              context,
                              widget: const GuestLoginDialog(),
                            )
                          : context.pushNamed(Routes.analysisScreen);
                    },
                    categoryName: 'analysis'.tr(context),
                    imagePath: Assets.analysisCategory,
                  ),
                ],
              ),
              30.verticalSpace,
              const EndPageBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
