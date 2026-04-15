import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/real_exam/views/widgets/confirm_access_dialog.dart';

class ConfirmAccessToRealExam extends StatelessWidget {
  const ConfirmAccessToRealExam({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Before You Start'),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attempts Counter
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withAlpha(20),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.secondaryColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer, color: AppColors.greenColor, size: 24.r),
                  12.horizontalSpace,
                  Expanded(
                    child:
                        BlocBuilder<
                          CheckSubscriptionCubit,
                          CheckSubscriptionState
                        >(
                          builder: (context, state) {
                            if (state is CheckSubscriptionsLoading) {
                              return const Center(
                                child: LinearProgressIndicator(),
                              );
                            }

                            final sub = context.read<CheckSubscriptionCubit>();

                            final availableExam = sub.availableExam;
                            return Text(
                              availableExam == '1000'
                                  ? 'You have Unlimited attempts'
                                  : 'Remaining Attempts: $availableExam',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greenColor,
                              ),
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),

            30.verticalSpace,

            // Warning 1
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.errorLightColor,
                  size: 28.r,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'Each attempt will be deducted from your balance once you start the exam.',
                    style: AppTextStyle.style16W500,
                  ),
                ),
              ],
            ),

            20.verticalSpace,
            // Warning 2
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.errorLightColor,
                  size: 28.r,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'Do NOT close the page, exit the app, or interrupt the exam. Doing so will cost you an attempt.',
                    style: AppTextStyle.style16W500,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Start Button
            BlocBuilder<CheckSubscriptionCubit, CheckSubscriptionState>(
              builder: (context, state) {
                return CustomPrimaryButton(
                  width: double.infinity,
                  onPressed: () =>
                      state is CheckSubscriptionsLoaded &&
                          context.mounted &&
                          context
                                  .read<CheckSubscriptionCubit>()
                                  .availableExam !=
                              '0' &&
                          context
                              .read<CheckSubscriptionCubit>()
                              .availableExam
                              .isNotEmpty
                      ? showCustomPrimaryDialog(
                          context,
                          widget: const ConfirmAccessToRealExamDialogWidget(),
                        )
                      : null,
                  text: 'Start Exam',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
