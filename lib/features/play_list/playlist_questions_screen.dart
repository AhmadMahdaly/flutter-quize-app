import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
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
  State<PlaylistQuestionsScreen> createState() => _PlaylistQuestionsScreenState();
}

class _PlaylistQuestionsScreenState extends State<PlaylistQuestionsScreen> {
  int currentOffset = 0;
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
        limit: 1,
        offset: currentOffset,
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
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error!')),
              );
            });
          } else if (state is RemoveFromPlayListSuccessState) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  currentTotalQuestions--;
                  localSelectedAnswer = null;
                  localIsAnswered = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Removed')),
                );
                context.read<PlayListCubit>().getPlayListDetails(
                  playlistId: widget.playlistId.toString(),
                  limit: 1,
                  offset: currentOffset, // نفس offset
                );
              }
            });


          } else if (state is RemoveFromPlayListFailedState) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error!')),
              );
            });
          }

        },
        builder: (context, state) {
          final cubit = context.read<PlayListCubit>();

          if (state is GetPlayListDetailsLoadingState && cubit.playListQuestionsModel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cubit.playListQuestionsModel == null ||
              cubit.playListQuestionsModel!.data == null ||
              cubit.playListQuestionsModel!.data!.isEmpty) {
            if (currentTotalQuestions == 0) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.playlist_remove_outlined,
                        size: 80,
                        color: AppColors.greyColor,
                      ),
                      16.verticalSpace,
                      Text(
                        'This playlist is empty',
                        style: interBold.copyWith(
                          fontSize: 20.sp,
                          color: AppColors.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      8.verticalSpace,
                      Text(
                        'Add questions to get started and begin your review session.',
                        style: interRegular.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.darkGreyColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      24.verticalSpace,
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }

          final currentQuestion = cubit.playListQuestionsModel!.data![0];
          final bool isAnswered = localIsAnswered;
          final currentQuestionNumber = '${currentOffset + 1} / $currentTotalQuestions';
          final playlistId = widget.playlistId.toString();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.verticalSpace,
                _buildQuestionWithImage(currentQuestion, currentQuestionNumber, cubit, playlistId),

                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, optionIndex) {
                      final currentOption = currentQuestion.options[optionIndex];
                      final bool isCorrectAnswer = currentQuestion.answer == currentOption.key;
                      final bool isSelected = localSelectedAnswer == currentOption.key;

                      return GestureDetector(
                        onTap: isAnswered
                            ? null
                            : () {
                          if (mounted) {
                            setState(() {
                              localSelectedAnswer = currentOption.key;
                              localIsAnswered = true;
                              currentQuestion.selectedAnswer = currentOption.key;
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
                Center(
                  child: GestureDetector(
                    onTap: isAnswered
                        ? () {
                      if (currentOffset + 1 < currentTotalQuestions) {
                        currentOffset++;
                        cubit.getPlayListDetails(
                          playlistId: widget.playlistId.toString(),
                          limit: 1,
                          offset: currentOffset,
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
                        const SnackBar(content: Text('Select Answer first!')),
                      );
                    },
                    child: QuestionButtonWidget(
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

  Widget _buildQuestionWithImage(dynamic question, String currentQuestionNumber, PlayListCubit cubit, String playlistId) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (question.photo != null && question.photo != 'NULL' && question.photo!.isNotEmpty)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: NetworkImage(question.photo!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
                  addCircledFun: () {
                    cubit.removeFromPlayList(
                      playlistId,
                      question.id.toString(),
                      offset: currentOffset ,
                    );
                  },
                  currentQuestion: currentQuestionNumber,
                  isFav: question.isFavorite ?? false,
                  question: '${question.question ?? ''}',
                  newsExplain: '${question.hint ?? ''}',
                  questionCircleExplain: '${question.explanation ?? ''}',
                  lightBulbExplain: '${question.hint ?? ''}',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}