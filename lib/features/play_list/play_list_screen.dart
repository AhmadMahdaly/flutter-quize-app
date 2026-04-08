import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';
import 'package:smle/features/play_list/widgets/play_list_widget.dart';
import 'package:smle/features/play_list/widgets/playlist_alert_widget.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key, this.questionId, this.isAdd = false});
  final int? questionId;
  final bool? isAdd;
  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final TextEditingController playListNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayListCubit>().getPlayList();
    });
  }

  @override
  void dispose() {
    playListNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bool isAddMode = widget.questionId != null;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Playlists'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: BlocConsumer<PlayListCubit, PlayListStates>(
          listener: (context, state) {
            if (state is AddToPlayListSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<PlayListCubit>();
            if (state is GetPlayListLoadingState) {
              return const SizedBox.shrink();
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isAdd == true
                      ? 24.verticalSpace
                      : const SizedBox.shrink(),
                  widget.isAdd == true
                      ? Text('Recently added', style: AppTextStyle.style16Bold)
                      : const SizedBox.shrink(),
                  8.verticalSpace,
                  if (cubit.playListModel != null &&
                      cubit.playListModel!.data != null)
                    if (cubit.playListModel!.data!.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ((SizeConfig.screenHeight / 3) - 150)
                                  .verticalSpace,
                              Icon(
                                Icons.playlist_add_outlined,
                                size: 80.r,
                                color: AppColors.primaryColor,
                              ),
                              16.verticalSpace,
                              Text(
                                'No playlists yet',
                                style: AppTextStyle.style20Bold.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              8.verticalSpace,
                              Text(
                                widget.isAdd == true
                                    ? 'Create a playlist to add this question.'
                                    : 'Create your first playlist to get started.',
                                style: AppTextStyle.style14W500.copyWith(
                                  color: AppColors.thirdColor.withAlpha(150),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              46.verticalSpace,
                              if (widget.isAdd == false)
                                CustomPrimaryButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BlocProvider.value(
                                          value: cubit,
                                          child: PlaylistAlertWidget(
                                            playListNameController:
                                                playListNameController,
                                            title: 'New playlist',
                                            isEdit: false,
                                            questionId: widget.questionId,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  text: 'Create new playlist',
                                )
                              else
                                CustomPrimaryButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BlocProvider.value(
                                          value: cubit,
                                          child: PlaylistAlertWidget(
                                            playListNameController:
                                                playListNameController,
                                            title: 'New playlist',
                                            isEdit: false,
                                            questionId: widget.questionId,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  text: 'Create New Playlist',
                                ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final playlist = cubit.playListModel!.data![index];
                          final questionCount =
                              '${playlist.questions?.length ?? 0}';
                          return PlayListWidget(
                            playListNameController: playListNameController,
                            playListName: playlist.name ?? '',
                            questionCount: questionCount,
                            playListId: '${playlist.id}',
                            onTap: () {
                              if (widget.isAdd == false) {
                                cubit.addToPlayList(
                                  '${playlist.id}',
                                  widget.questionId.toString(),
                                );
                              } else {
                                context.pushNamed(
                                  AppRoutes.playlistQuestionsScreen,
                                  arguments: {
                                    'playlistId': playlist.id,
                                    'totalQuestions':
                                        playlist.questions?.length ?? 0,
                                    'asAdd': true,
                                  },
                                );
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) => 12.verticalSpace,
                        itemCount: cubit.playListModel!.data!.length,
                      )
                  else if (state is GetPlayListFailedState)
                    const Center(child: Text('Error!')),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(320.r),
        ),
        child: const Icon(Icons.add, color: AppColors.offwhiteColor),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return BlocProvider.value(
                value: context.read<PlayListCubit>(),
                child: PlaylistAlertWidget(
                  playListNameController: playListNameController,
                  title: 'New playlist',
                  isEdit: false,
                  questionId: widget.questionId,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
