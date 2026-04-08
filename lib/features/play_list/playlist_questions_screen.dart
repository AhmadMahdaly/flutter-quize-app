import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/shared_widgets/action_confirmation_dialog.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/core/shared_widgets/no_data_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';
import 'package:smle/features/q_bank/widgets/answer_widget.dart';
import 'package:smle/features/q_bank/widgets/question_button_widget.dart';
import 'package:smle/features/q_bank/widgets/question_widget.dart';

class PlaylistQuestionsScreen extends StatefulWidget {
  const PlaylistQuestionsScreen({
    super.key,
    required this.playlistId,
    required this.totalQuestions,
    this.isAdd = false,
  });
  final int playlistId;
  final int totalQuestions;
  final bool isAdd;
  @override
  State<PlaylistQuestionsScreen> createState() =>
      _PlaylistQuestionsScreenState();
}

class _PlaylistQuestionsScreenState extends State<PlaylistQuestionsScreen> {
  int currentPage = 1; // تم التعديل إلى currentPage بدلاً من offset
  String? localSelectedAnswer;
  bool localIsAnswered = false;
  int currentTotalQuestions = 0;

  @override
  void initState() {
    super.initState();
    currentTotalQuestions = widget.totalQuestions;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<PlayListCubit>().getPlayListDetails(
        playlistId: widget.playlistId.toString(),
        page: currentPage, // تمرير الصفحة
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Playlist Questions'),
      body: BlocConsumer<PlayListCubit, PlayListStates>(
        listener: (context, state) {
          if (state is GetPlayListDetailsSuccessState) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  localSelectedAnswer = null;
                  localIsAnswered = false;
                });
              }
            });
          } else if (state is GetPlayListDetailsFailedState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Error!')));
          } else if (state is RemoveFromPlayListSuccessState) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  // 1. تقليل عدد الأسئلة الإجمالي
                  if (currentTotalQuestions > 0) {
                    currentTotalQuestions--;
                  }

                  // 2. تصفير الإجابات لتجهيز السؤال القادم
                  localSelectedAnswer = null;
                  localIsAnswered = false;

                  // 3. معالجة الصفحة الحالية (Page) لتجنب طلب صفحة غير موجودة
                  // إذا حذفت السؤال الأخير، ستصبح الصفحة الحالية أكبر من إجمالي الأسئلة المتبقية
                  if (currentPage > currentTotalQuestions &&
                      currentTotalQuestions > 0) {
                    currentPage = currentTotalQuestions;
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Question removed from playlist'),
                  ),
                );

                // 4. جلب البيانات الجديدة فقط إذا كان هناك أسئلة متبقية
                if (currentTotalQuestions > 0) {
                  context.read<PlayListCubit>().getPlayListDetails(
                    playlistId: widget.playlistId.toString(),
                    page: currentPage,
                  );
                }
              }
            });
          }
        },
        builder: (context, state) {
          final cubit = context.read<PlayListCubit>();

          if (state is GetPlayListDetailsLoadingState &&
              cubit.playListQuestionsModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // التحقق من الهيكل الجديد: model.data.data
          if (cubit.playListQuestionsModel?.data?.data == null ||
              cubit.playListQuestionsModel!.data!.data!.isEmpty) {
            // يمكننا أيضاً أخذ التوتال من السيرفر مباشرة لو فضلنا:
            // currentTotalQuestions = cubit.playListQuestionsModel?.data?.total ?? 0;

            if (currentTotalQuestions <= 0) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.playlist_remove_outlined,
                        size: 80.r,
                        color: AppColors.primaryColor,
                      ),
                      16.verticalSpace,
                      Text(
                        'This playlist is empty',
                        style: AppTextStyle.style20Bold.copyWith(
                          color: AppColors.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      8.verticalSpace,
                      Text(
                        'Add questions to get started and begin your review session.',
                        style: AppTextStyle.style16W500.copyWith(
                          color: AppColors.thirdColor.withAlpha(200),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      46.verticalSpace,
                      CustomPrimaryHButton(
                        onPressed: () => Navigator.pop(context),
                        text: 'Go Back',
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: LoadingDataWidget());
          }

          // جلب السؤال الأول من مصفوفة البيانات في الهيكل الجديد
          final currentQuestion = cubit.playListQuestionsModel!.data!.data![0];
          final bool isAnswered = localIsAnswered;
          // تحديث رقم السؤال استناداً للصفحة (لأننا نجلب سؤالاً واحداً لكل صفحة)
          final currentQuestionNumber = '$currentPage / $currentTotalQuestions';
          final playlistId = widget.playlistId.toString();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.verticalSpace,
                _buildQuestionWithImage(
                  currentQuestion,
                  currentQuestionNumber,
                  cubit,
                  playlistId,
                ),

                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // استخدام دالة الـ get options التي أنشأناها في الموديل
                    itemBuilder: (context, optionIndex) {
                      final currentOption =
                          currentQuestion.options[optionIndex];
                      final bool isCorrectAnswer =
                          currentQuestion.answer == currentOption.key;
                      final bool isSelected =
                          localSelectedAnswer == currentOption.key;

                      return GestureDetector(
                        onTap: isAnswered
                            ? null
                            : () {
                                if (mounted) {
                                  setState(() {
                                    localSelectedAnswer = currentOption.key;
                                    localIsAnswered = true;
                                    currentQuestion.selectedAnswer =
                                        currentOption.key;
                                  });
                                }
                              },
                        child: isAnswered
                            ? AnsweredWidget(
                                answerText: currentOption.value!,
                                isTrue: isCorrectAnswer,
                                isSelected: isSelected,
                              )
                            : AnswerWidget(
                                answerText: currentOption.value!,
                                isSelected: isSelected,
                              ),
                      );
                    },
                    separatorBuilder: (context, index) => 8.verticalSpace,
                    itemCount: currentQuestion.options.length,
                  ),
                ),
                30.verticalSpace,
                Center(
                  child: GestureDetector(
                    onTap: isAnswered
                        ? () {
                            if (currentPage < currentTotalQuestions) {
                              currentPage++; // الانتقال للصفحة التالية
                              cubit.getPlayListDetails(
                                playlistId: widget.playlistId.toString(),
                                page: currentPage,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ended!')),
                              );
                              Navigator.pop(context);
                            }
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Select Answer first!'),
                              ),
                            );
                          },
                    child: CustomQuestionButtonWidget(
                      text: isAnswered ? 'Next' : 'Answer to continue',
                    ),
                  ),
                ),
                40.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionWithImage(
    dynamic question,
    String currentQuestionNumber,
    PlayListCubit cubit,
    String playlistId,
  ) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: QuestionWidget(
                  isAdd: widget.isAdd,
                  addToPlaylistFun: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => ActionConfirmationDialog(
                        title: 'Are you sure you want to delete this question?',
                        onConfirm: () async {
                          try {
                            cubit.removeFromPlayList(
                              playlistId,
                              question.id.toString(),
                              offset: 0,
                            );
                          } catch (_) {}
                        },
                      ),
                    );
                  },
                  onNoteTap: () => showDialog(
                    context: context,
                    builder: (context) => QBankAddNoteDialog(
                      cubit: getIt<PlayListCubit>(),
                      questionId: question.id,
                    ),
                  ),
                  currentQuestion: currentQuestionNumber,
                  isRepeated: question.isFavourite ?? false, // تمت إضافة حرف u
                  question: '${question.question ?? ''}',
                  explainPhoto: '${question.explanationPhoto}',
                  qPhoto: '${question.photo}',
                  explainText: '${question.explanation ?? ''}',
                  hintText: '${question.hint ?? ''}',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class QBankAddNoteDialog extends StatefulWidget {
  const QBankAddNoteDialog({
    super.key,
    required this.cubit,
    required this.questionId,
  });
  final PlayListCubit cubit;
  final int questionId;

  @override
  State<QBankAddNoteDialog> createState() => _QBankAddNoteDialogState();
}

class _QBankAddNoteDialogState extends State<QBankAddNoteDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayListCubit, PlayListStates>(
      bloc: widget.cubit,
      listener: (context, state) {
        if (state is AddNoteSuccessState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.toString()),
              backgroundColor: AppColors.greenLightColor,
            ),
          );
        } else if (state is AddNoteFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.toString()),
              backgroundColor: AppColors.errorLightColor,
            ),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Send Notes To Admin for this Question',
                  style: AppTextStyle.style16Bold,
                ),
                12.verticalSpace,
                CustomPrimaryTextfield(
                  maxLines: 7,
                  controller: controller,
                  text: 'Type your note here...',
                ),
                12.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: state is AddNoteLoadingState
                            ? null // تعطيل الزر أثناء التحميل
                            : () {
                                if (controller.text.isNotEmpty) {
                                  widget.cubit.addQuestionNote(
                                    controller.text,
                                    widget.questionId,
                                  );
                                }
                              },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.r,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greenColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: state is AddNoteLoadingState
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Send',
                                  style: AppTextStyle.style14Bold.copyWith(
                                    color: AppColors.offwhiteColor,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: TextButton(
                        onPressed: () => context.pop(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.r,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreyColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTextStyle.style14Bold.copyWith(
                              color: AppColors.offwhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
