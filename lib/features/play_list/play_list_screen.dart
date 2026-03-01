import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
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
  Widget build(BuildContext context) {
    // final bool isAddMode = widget.questionId != null;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Playlists'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: BlocConsumer<PlayListCubit, PlayListStates>(
          // غير إلى BlocConsumer
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
                              const Icon(
                                Icons.playlist_add_outlined,
                                size: 80,
                                color: AppColors.greyColor,
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
                                style: AppTextStyle.style16W500.copyWith(
                                  color: AppColors.darkGreyColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              24.verticalSpace,
                              if (widget.isAdd == false)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.h,
                                      ),
                                    ),
                                    child: Text(
                                      'Create new playlist',
                                      style: AppTextStyle.style14W500.copyWith(
                                        color: AppColors.thirdColor,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
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
                                    child: const Text('Create New Playlist'),
                                  ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(320.r),
        ),
        child: const Icon(Icons.add),
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
