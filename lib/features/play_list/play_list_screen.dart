import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';
import 'package:smle/features/play_list/widgets/play_list_widget.dart';
import 'package:smle/features/play_list/widgets/playlist_alert_widget.dart';
import '../../core/theme/text_styles.dart';

class PlayListScreen extends StatelessWidget {
  PlayListScreen({super.key, this.questionId});
  final TextEditingController playListNameController = TextEditingController();
  final int? questionId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'playlists'.tr(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: SingleChildScrollView(
          child: BlocBuilder<PlayListCubit, PlayListStates>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.verticalSpace,
                  Text(
                    'recently_added'.tr(context),
                    style: interBold.copyWith(
                      fontSize: 16.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  30.verticalSpace,
                  if (context.read<PlayListCubit>().playListModel != null)
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {

                              },
                              child: PlayListWidget(
                                playListNameController: playListNameController,
                                playListName:
                                    '${context.read<PlayListCubit>().playListModel!.data![index].name}',
                                questionCount:
                                    '${context.read<PlayListCubit>().playListModel!.data!.length}',
                                playListId:
                                    '${context.read<PlayListCubit>().playListModel!.data![index].id}',
                              ),
                            ),
                        separatorBuilder: (context, index) => 15.verticalSpace,
                        itemCount: context
                            .read<PlayListCubit>()
                            .playListModel!
                            .data!
                            .length),
                  30.verticalSpace,
                  Center(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BlocProvider(
                              create: (context) => PlayListCubit(getIt()),
                              child: BlocBuilder<PlayListCubit, PlayListStates>(
                                builder: (context, state) {
                                  return PlaylistAlertWidget(
                                    playListNameController:
                                        playListNameController,
                                    title: 'new_playlist'.tr(context),
                                    isEdit: false,
                                    questionId: questionId,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.secondaryColor),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: WidgetStateProperty.all(
                            const Size(double.infinity, 52)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'create_new_playlist'.tr(context),
                        style: interRegular.copyWith(
                          color: AppColors.thirdColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
