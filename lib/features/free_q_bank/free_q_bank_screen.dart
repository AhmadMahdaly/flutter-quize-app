import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/shared_widgets/no_data_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/free_q_bank/cubit/free_q_bank_cubit.dart';
import 'package:smle/features/free_q_bank/widgets/qbank_add_note_dialog.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/q_bank/data/model/start_quiz_model.dart';
import 'package:smle/features/q_bank/widgets/answer_widget.dart';
import 'package:smle/features/q_bank/widgets/q_bank_progress_widget.dart'
    show QBankProgressWidget;
import 'package:smle/features/q_bank/widgets/question_button_widget.dart';
import 'package:smle/features/q_bank/widgets/question_widget.dart';

class FreeQBankScreen extends StatefulWidget {
  const FreeQBankScreen({super.key, required this.startQuizModel});
  final StartQuizModel startQuizModel;

  @override
  State<FreeQBankScreen> createState() => _FreeQBankScreenState();
}

class _FreeQBankScreenState extends State<FreeQBankScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.startQuizModel.qBankModel != null) {
      context.read<FreeQBankCubit>().setQuizModel(
        widget.startQuizModel.qBankModel!,
      );
    }
  }

  // أضف هذه الدالة داخل _FreeQBankScreenState
  void _showResultDialog(BuildContext context, FreeQBankCubit cubit) {
    final results = cubit.calculateResults();
    final double percentage = results['percentage'];
    final Color progressColor = results['color'];
    showDialog(
      context: context,
      barrierDismissible: false, // لمنع إغلاق النافذة عند الضغط خارجها
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Quiz Results',
            textAlign: TextAlign.center,
            style: AppTextStyle.style20Bold.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              20.verticalSpace,

              // تصميم الدائرة التحليلية للنسبة المئوية
              SizedBox(
                height: 120.h,
                width: 120.w,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: percentage / 100),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, _) => Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: value,
                        color: progressColor,
                        backgroundColor: AppColors.greyColor.withAlpha(50),
                        strokeWidth: 10.w,
                      ),
                      Center(
                        child: Text(
                          '${(value * 100).toInt()}%',
                          style: AppTextStyle.style16Bold.copyWith(
                            color: progressColor.withAlpha(200),
                            fontSize: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // رسالة التقييم
              20.verticalSpace,
              const Divider(color: AppColors.iconColorGray),
              10.verticalSpace,
              Text(
                'Total Questions: ${results['total']}',
                style: AppTextStyle.style14W500,
              ),
              15.verticalSpace,
              Text(
                'Correct Answers: ${results['correct']}',
                style: AppTextStyle.style14Bold.copyWith(
                  color: AppColors.successColor,
                ),
              ),
              10.verticalSpace,
              Text(
                'Wrong Answers: ${results['wrong']}',
                style: AppTextStyle.style14Bold.copyWith(color: Colors.red),
              ),
              10.verticalSpace,
              Text(
                'Skipped: ${results['skipped']}',
                style: AppTextStyle.style14Bold.copyWith(color: Colors.orange),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {
                  // الخروج للرئيسية بعد رؤية النتيجة
                  context.pushNamedAndRemoveUntil(
                    AppRoutes.mainLayoutScreen,
                    (route) => false,
                  );
                },
                child: Text(
                  'Go to Home',
                  style: AppTextStyle.style16Bold.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (mounted) {
          context.pushNamedAndRemoveUntil(
            AppRoutes.mainLayoutScreen,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Free Trial quiz', canBack: false),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),

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

              return BlocBuilder<FreeQBankCubit, FreeQBankStates>(
                builder: (context, state) {
                  final cubit = context.read<FreeQBankCubit>();

                  if (cubit.qBankModel == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return (cubit.qBankModel!.data?.isNotEmpty ?? false)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            QBankProgressWidget(
                              currentValue: cubit.index,
                              endValue: cubit.qBankModel!.data!.length,
                              switchValue: cubit.isAnswered,
                              switchFun: (value) {
                                cubit.setIsAnswered();
                              },
                            ),
                            20.verticalSpace,
                            QuestionWidget(
                              addToPlaylistFun: () {
                                if (!isSubscribed || !hasQBank) {
                                  showCustomPrimaryDialog(
                                    context,
                                    widget: CustomPrimaryDialog(
                                      title: 'Subscription Required',
                                      description:
                                          'You cannot access the Question bank. Renew your subscription to enjoy the benefits.',
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
                                context.pushNamed(
                                  AppRoutes.playListScreen,

                                  arguments: {
                                    'questionId':
                                        cubit.qBankModel!.data![cubit.index].id,
                                    'asAdd': false,
                                  },
                                );
                              },
                              currentQuestion: '${cubit.index + 1}',
                              isRepeated:
                                  cubit
                                      .qBankModel!
                                      .data![cubit.index]
                                      .isFavorite ??
                                  false,
                              question:
                                  '${cubit.qBankModel!.data![cubit.index].question}',

                              explainText:
                                  '${cubit.qBankModel!.data![cubit.index].explanation}',
                              explainPhoto:
                                  '${cubit.qBankModel!.data![cubit.index].explanationPhoto}',
                              qPhoto:
                                  '${cubit.qBankModel!.data![cubit.index].photo}',
                              hintText:
                                  '${cubit.qBankModel!.data![cubit.index].hint}',

                              onNoteTap: () {
                                // if (!isSubscribed || !hasQBank) {
                                //   showCustomPrimaryDialog(
                                //     context,
                                //     widget: CustomPrimaryDialog(
                                //       title: 'Subscription Required',
                                //       description:
                                //           'You cannot access the Question bank. Renew your subscription to enjoy the benefits.',
                                //       confirmText: 'Subscribe Now',
                                //       onConfirm: () {
                                //         context.pushNamed(
                                //           AppRoutes.subscriptionScreen,
                                //           arguments:
                                //               context
                                //                   .read<MainLayoutCubit>()
                                //                   .profileModel!
                                //                   .data!
                                //                   .offerId ??
                                //               -1,
                                //         );
                                //       },
                                //     ),
                                //   );
                                //   return;
                                // }
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      QBankAddNoteDialog(cubit: cubit),
                                );
                              },
                            ),
                            20.verticalSpace,
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, optionIndex) {
                                final currentQuestion =
                                    cubit.qBankModel!.data![cubit.index];
                                final currentOption =
                                    currentQuestion.options[optionIndex];
                                final bool isCorrectAnswer =
                                    currentQuestion.answer == currentOption.key;

                                return GestureDetector(
                                  onTap: () {
                                    if (currentQuestion.selectedAnswer ==
                                        null) {
                                      cubit.selectAnswer(
                                        currentOption.key!,
                                        currentQuestion.id ?? 0,
                                      );
                                    }
                                  },
                                  child:
                                      cubit.isAnswered ||
                                          currentQuestion.selectedAnswer != null
                                      ? AnsweredWidget(
                                          answerText: currentOption.value!,
                                          isTrue: isCorrectAnswer,
                                          isSelected:
                                              currentQuestion.selectedAnswer ==
                                              currentOption.key,
                                        )
                                      : AnswerWidget(
                                          answerText: currentOption.value!,
                                          isSelected:
                                              currentQuestion.selectedAnswer ==
                                              currentOption.key,
                                        ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  8.verticalSpace,
                              itemCount: cubit
                                  .qBankModel!
                                  .data![cubit.index]
                                  .options
                                  .length,
                            ),
                            20.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (cubit.index > 0)
                                  GestureDetector(
                                    onTap: () {
                                      cubit.setIndexQBank(false);
                                    },
                                    child: const QuestionButtonWidget(
                                      text: 'Back',
                                    ),
                                  ),
                                // استبدل الكود القديم لزر Quit بهذا الكود
                                if (cubit.index == 0)
                                  GestureDetector(
                                    onTap: () {
                                      _showResultDialog(
                                        context,
                                        cubit,
                                      ); // عرض النتيجة
                                    },
                                    child: const QuestionButtonWidget(
                                      text: 'Quit',
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    if (cubit.index <
                                        cubit.qBankModel!.data!.length - 1) {
                                      cubit.setIndexQBank(true);
                                    } else {
                                      _showResultDialog(context, cubit);
                                    }
                                  },
                                  child: QuestionButtonWidget(
                                    text:
                                        cubit.index <
                                            cubit.qBankModel!.data!.length - 1
                                        ? 'Next'
                                        : 'Finish',
                                  ),
                                ),
                              ],
                            ),
                            if (cubit.index > 0) ...[
                              20.verticalSpace,
                              // استبدل الكود القديم بهذا الكود
                              cubit.index < cubit.qBankModel!.data!.length - 1
                                  ? Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          _showResultDialog(
                                            context,
                                            cubit,
                                          ); // عرض النتيجة
                                        },
                                        child: const QuestionButtonWidget(
                                          text: 'Quit',
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ],
                        )
                      : const NoDataWidget(
                          noDataImage: '',
                          noDataText: 'No data found',
                        );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
