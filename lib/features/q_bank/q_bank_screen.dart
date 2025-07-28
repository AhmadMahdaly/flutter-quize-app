import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/no_data_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';
import 'package:smle/features/q_bank/data/model/startQuizModel.dart';
import 'package:smle/features/q_bank/widgets/answer_widget.dart';
import 'package:smle/features/q_bank/widgets/q_bank_progress_widget.dart';
import 'package:smle/features/q_bank/widgets/question_button_widget.dart';
import 'package:smle/features/q_bank/widgets/question_widget.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';

class QBankScreen extends StatelessWidget {
  const QBankScreen({super.key, required this.startQuizModel});
  final StartQuizModel startQuizModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'q_bank'.tr(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: BlocBuilder<QBankcubit, QBankStates>(
          builder: (context, state) {
            return context.read<QBankcubit>().qBankModel != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        QBankProgressWidget(
                          currentValue: context.read<QBankcubit>().index,
                          endValue: context
                                  .read<QBankcubit>()
                                  .qBankModel!
                                  .data!
                                  .isNotEmpty
                              ? context
                                  .read<QBankcubit>()
                                  .qBankModel!
                                  .data!
                                  .length
                              : 1,
                          switchValue: context.read<QBankcubit>().isAnswered,
                          switchFun: (value) {
                            context.read<QBankcubit>().setIsAnswered();
                          },
                        ),
                        20.verticalSpace,
                        if (context
                            .read<QBankcubit>()
                            .qBankModel!
                            .data!
                            .isNotEmpty)
                          QuestionWidget(
                            addCircledFun: () {
                              context.pushNamed(Routes.playListScreen,
                                  arguments:
                                     context.read<QBankcubit>().qBankModel!.data![context.read<QBankcubit>().index].id);
                            },
                            currentQuestion:
                                '${context.read<QBankcubit>().index + 1}',
                            isFav:context.read<QBankcubit>().qBankModel!.data![context.read<QBankcubit>().index].isFavourite!,
                            question:
                                '${context.read<QBankcubit>().qBankModel!.data![context.read<QBankcubit>().index].question}',
                            newsExplain:
                                '${context.read<QBankcubit>().qBankModel!.data![context.read<QBankcubit>().index].hint}',
                            questionCircleExplain:
                                '${context.read<QBankcubit>().qBankModel!.data![context.read<QBankcubit>().index].explanation}',
                            lightBulbExplain:
                                '${context.read<QBankcubit>().qBankModel!.data![context.read<QBankcubit>().index].hint}',
                          ),
                        20.verticalSpace,
                        context.read<QBankcubit>().qBankModel!.data!.isNotEmpty
                            ? ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final bool isTrue = context
                                          .read<QBankcubit>()
                                          .qBankModel!
                                          .data![
                                              context.read<QBankcubit>().index]
                                          .answer ==
                                      context
                                          .read<QBankcubit>()
                                          .qBankModel!
                                          .data![
                                              context.read<QBankcubit>().index]
                                          .options[index]
                                          .key;
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<QBankcubit>().selectAnswer(
                                          context
                                              .read<QBankcubit>()
                                              .qBankModel!
                                              .data![context
                                                  .read<QBankcubit>()
                                                  .index]
                                              .options[index]
                                              .key);
                                    },
                                    child:
                                    context.read<QBankcubit>().isAnswered?  AnsweredWidget(
                                      answerText: context
                                          .read<QBankcubit>()
                                          .qBankModel!
                                          .data![
                                      context.read<QBankcubit>().index]
                                          .options[index]
                                          .value!,
                                      isTrue: isTrue,
                                    ):

                                    AnswerWidget(
                                      answerText: context
                                          .read<QBankcubit>()
                                          .qBankModel!
                                          .data![
                                              context.read<QBankcubit>().index]
                                          .options[index]
                                          .value!,
                                      isSelected: context
                                              .read<QBankcubit>()
                                              .qBankModel!
                                              .data![context
                                                  .read<QBankcubit>()
                                                  .index]
                                              .selectedAnswer ==
                                          context
                                              .read<QBankcubit>()
                                              .qBankModel!
                                              .data![context
                                                  .read<QBankcubit>()
                                                  .index]
                                              .options[index]
                                              .key,
                                      isTrue: isTrue,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    15.verticalSpace,
                                itemCount: context
                                    .read<QBankcubit>()
                                    .qBankModel!
                                    .data![context.read<QBankcubit>().index]
                                    .options
                                    .length)
                            : NoDataWidget(
                                noDataImage: '',
                                noDataText: 'no_data_found'.tr(context)),
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (context.read<QBankcubit>().index != 0)
                              GestureDetector(
                                  onTap: () {
                                    context
                                        .read<QBankcubit>()
                                        .setIndexQBank(false);
                                  },
                                  child: QuestionButtonWidget(
                                    text: 'back'.tr(context),
                                  )),
                            if (context.read<QBankcubit>().index == 0)
                              GestureDetector(
                                  onTap: () {},
                                  child: QuestionButtonWidget(
                                    text: 'quit'.tr(context),
                                  )),
                            GestureDetector(
                                onTap: () {
                                  if (context.read<QBankcubit>().index <
                                      context
                                              .read<QBankcubit>()
                                              .qBankModel!
                                              .data!
                                              .length -
                                          1) {
                                    // context.read<QBankcubit>().selectAnswer(null);
                                    context
                                        .read<QBankcubit>()
                                        .setIndexQBank(true);
                                  } else {
                                    context
                                        .read<QBankcubit>()
                                        .setOffsetQBank(true);
                                    context.read<QBankcubit>().startQuiz(
                                        context,
                                        startQuizModel.pickedDate!.month,
                                        startQuizModel.pickedDate!.year,
                                        startQuizModel.selectedSubCategoryId!);
                                  }
                                },
                                child: QuestionButtonWidget(
                                  text: 'next'.tr(context),
                                )),
                          ],
                        ),
                        if (context.read<QBankcubit>().index != 0)
                          20.verticalSpace,
                        if (context.read<QBankcubit>().index != 0)
                          Center(
                            child: GestureDetector(
                                onTap: () {},
                                child: QuestionButtonWidget(
                                  text: 'quit'.tr(context),
                                )),
                          ),
                      ])
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 300.h),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 3.w,
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
