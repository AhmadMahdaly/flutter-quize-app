import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';
import 'package:smle/features/play_list/widgets/play_list_widget.dart';
import 'package:smle/features/play_list/widgets/playlist_alert_widget.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key, this.questionId, this.isAdd=false});
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
    final bool isAddMode = widget.questionId != null;
    return Scaffold(
      appBar: CustomAppBar(
        title:  'playlists'.tr(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: BlocConsumer<PlayListCubit, PlayListStates>(  // غير إلى BlocConsumer
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
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isAdd==true ?  24.verticalSpace:const SizedBox.shrink(),
                  widget.isAdd==true ?  Text(
                    'recently_added'.tr(context),
                    style: interBold.copyWith(
                      fontSize: SizeConfig.responsiveValue(
                        phone: 16.sp,
                        tablet: 20.sp,
                      ),
                    ),
                  ):const SizedBox.shrink(),
                  30.verticalSpace,
                  if (cubit.playListModel != null && cubit.playListModel!.data != null)
                    if (cubit.playListModel!.data!.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.playlist_add_outlined,
                                size: 80,
                                color: AppColors.greyColor,
                              ),
                              16.verticalSpace,
                              Text(
                                'No playlists yet',
                                style: interBold.copyWith(
                                  fontSize: 20.sp,
                                  color: AppColors.primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              8.verticalSpace,
                              Text(
                                widget.isAdd == true
                                    ? 'Create a playlist to add this question.'
                                    : 'Create your first playlist to get started.',
                                style: interRegular.copyWith(
                                  fontSize: 16.sp,
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
                                              playListNameController: playListNameController,
                                              title: 'new_playlist'.tr(context),
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
                                        borderRadius: BorderRadius.circular(30.r),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 16.h),
                                    ),
                                    child: Text(
                                      'create_new_playlist'.tr(context),
                                      style: interRegular.copyWith(
                                        color: AppColors.thirdColor,
                                        fontSize: SizeConfig.responsiveValue(
                                          phone: 14.sp,
                                          tablet: 18.sp,
                                        ),
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
                                              playListNameController: playListNameController,
                                              title: 'new_playlist'.tr(context),
                                              isEdit: false,
                                              questionId: widget.questionId,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text('Create New Playlist'),
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
                          final questionCount = '${playlist.questions?.length ?? 0}';
                          return PlayListWidget(
                            playListNameController: playListNameController,
                            playListName: playlist.name ?? '',
                            questionCount: questionCount,
                            playListId: '${playlist.id}',
                            onTap: () {
                              if (widget.isAdd==false) {
                                cubit.addToPlayList('${playlist.id}', widget.questionId.toString());
                              } else {
                                context.pushNamed(
                                    Routes.playlistQuestionsScreen,
                                    arguments: {
                                      'playlistId': playlist.id,
                                      'totalQuestions': playlist.questions?.length ?? 0,
                                      'asAdd':true,

                                    }
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
                  30.verticalSpace,
                  widget.isAdd==false ?
                  Center(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BlocProvider.value(
                              value: cubit,
                              child: PlaylistAlertWidget(
                                playListNameController: playListNameController,
                                title: 'new_playlist'.tr(context),
                                isEdit: false,
                                questionId: widget.questionId,
                              ),
                            );
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(AppColors.secondaryColor),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: WidgetStateProperty.all(Size(double.infinity, 52.h)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                        ),
                      ),
                      child: Text(
                        'create_new_playlist'.tr(context),
                        style: interRegular.copyWith(
                          color: AppColors.thirdColor,
                          fontSize: SizeConfig.responsiveValue(
                            phone: 14.sp,
                            tablet: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ):const SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}