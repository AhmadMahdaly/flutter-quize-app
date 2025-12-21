import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/no_data_widget.dart';
import 'package:smle/features/free_q_bank/cubit/free_q_bank_cubit.dart';
import 'package:smle/features/free_q_bank/data/model/start_quiz_model.dart';
import 'package:smle/features/free_q_bank/widgets/answer_widget.dart';
import 'package:smle/features/free_q_bank/widgets/q_bank_progress_widget.dart';
import 'package:smle/features/free_q_bank/widgets/qbank_add_note_dialog.dart';
import 'package:smle/features/free_q_bank/widgets/question_button_widget.dart';
import 'package:smle/features/free_q_bank/widgets/question_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'q_bank'.tr(context), canBack: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),

        child: BlocBuilder<FreeQBankCubit, FreeQBankStates>(
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
                        addCircledFun: () {
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
                        isFav:
                            cubit.qBankModel!.data![cubit.index].isFavorite ??
                            false,
                        question:
                            '${cubit.qBankModel!.data![cubit.index].question}',
                        newsExplain:
                            '${cubit.qBankModel!.data![cubit.index].hint}',
                        questionCircleExplain:
                            '${cubit.qBankModel!.data![cubit.index].explanation}',
                        lightBulbExplain:
                            '${cubit.qBankModel!.data![cubit.index].hint}',
                        onNoteTap: () {
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
                              if (currentQuestion.selectedAnswer == null) {
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
                        separatorBuilder: (context, index) => 8.verticalSpace,
                        itemCount:
                            cubit.qBankModel!.data![cubit.index].options.length,
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
                              child: QuestionButtonWidget(
                                text: 'back'.tr(context),
                              ),
                            ),
                          if (cubit.index == 0)
                            GestureDetector(
                              onTap: () {
                                context.pushNamedAndRemoveUntil(
                                  AppRoutes.mainLayoutScreen,
                                  (route) => false,
                                );
                              },
                              child: QuestionButtonWidget(
                                text: 'quit'.tr(context),
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              if (cubit.index <
                                  cubit.qBankModel!.data!.length - 1) {
                                cubit.setIndexQBank(true);
                              } else {
                                context.pushNamedAndRemoveUntil(
                                  AppRoutes.mainLayoutScreen,
                                  (route) => false,
                                );
                              }
                            },
                            child: QuestionButtonWidget(
                              text:
                                  cubit.index <
                                      cubit.qBankModel!.data!.length - 1
                                  ? 'next'.tr(context)
                                  : 'Finish',
                            ),
                          ),
                        ],
                      ),
                      if (cubit.index > 0) ...[
                        20.verticalSpace,
                        cubit.index < cubit.qBankModel!.data!.length - 1
                            ? Center(
                                child: GestureDetector(
                                  onTap: () {
                                    context.pushNamedAndRemoveUntil(
                                      AppRoutes.mainLayoutScreen,
                                      (route) => false,
                                    );
                                  },
                                  child: QuestionButtonWidget(
                                    text: 'quit'.tr(context),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ],
                  )
                : NoDataWidget(
                    noDataImage: '',
                    noDataText: 'no_data_found'.tr(context),
                  );
          },
        ),
      ),
    );
  }
}
