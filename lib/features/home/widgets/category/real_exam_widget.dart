import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/features/home/widgets/category/base_category_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/views/widgets/confirm_access_dialog.dart';

class RealExamHomeWidget extends StatelessWidget {
  const RealExamHomeWidget({
    super.key,
    required this.isSubscribed,
    required this.availableExam,
  });

  final bool isSubscribed;
  final String availableExam;

  @override
  Widget build(BuildContext context) {
    return CategoryWidget(
      onTap: () {
        if (!isSubscribed) {
          showCustomPrimaryDialog(
            context,
            widget: CustomPrimaryDialog(
              title: 'Subscription Required',
              description: 'Subscribe to access the real exams.',
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
            context.pushNamed(AppRoutes.realExamScreen);
          } else {
            context.pushNamed(
              AppRoutes.confirmAccessToRealExam,
              arguments: {
                'remainingAttempts': availableExam == 'Unlimited'
                    ? 1000
                    : int.tryParse(availableExam) ?? 0,
                'onStart': () {
                  showCustomPrimaryDialog(
                    context,
                    widget: const ConfirmAccessToRealExamDialogWidget(),
                  );
                },
              },
            );
          }
        } else {
          log(availableExam.toString());
          showCustomPrimaryDialog(
            context,
            widget: CustomPrimaryDialog(
              title: 'Your Attempts Have Ended',
              description:
                  'You’ve used all the real exams available to you. Please renew your subscription to continue.',
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
          );
        }
      },
      categoryName: 'real_exam'.tr(context),
      imagePath: Assets.examCategory,
    );
  }
}
