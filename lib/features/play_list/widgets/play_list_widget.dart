import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/action_confirmation_dialog.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';
import 'package:smle/features/play_list/widgets/playlist_alert_widget.dart';

class PlayListWidget extends StatelessWidget {
  const PlayListWidget({
    super.key,
    required this.playListName,
    required this.questionCount,
    required this.playListId,
    required this.playListNameController,
    this.onTap,
  });
  final String playListName, questionCount, playListId;
  final TextEditingController playListNameController;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cubit = context.read<PlayListCubit>();
    return GestureDetector(
      onTap: onTap ?? () {}, // استخدم الـ
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: theme.colorScheme.primary,
                ),
                child: Icon(
                  Icons.question_mark_rounded,
                  size: 60.r,
                  color: theme.colorScheme.secondary,
                ),
                //  Image.asset(
                //   Assets.questionMark,
                //   height: SizeConfig.responsiveValue(phone: 80.h, tablet: 80.h),
                // ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playListName,
                      style: AppTextStyle.style16W700.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    Text(
                      '$questionCount ${'Question'}',
                      style: AppTextStyle.style14W500.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    10.verticalSpace,
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: theme.colorScheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BlocProvider.value(
                          value: cubit,
                          child: PlaylistAlertWidget(
                            playListNameController: playListNameController,
                            title: 'Edit playlist',
                            isEdit: true,
                            playListName: playListName,
                            playListId: playListId,
                          ),
                        );
                      },
                    );
                  } else if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => ActionConfirmationDialog(
                        title: 'Are you sure you want to delete this playlist?',
                        onConfirm: () async {
                          try {
                            await cubit.deletePlayList(playListId);
                          } catch (_) {}
                        },
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.square_pencil,
                          size: SizeConfig.responsiveValue(
                            phone: 20.r,
                            tablet: 16.r,
                          ),
                        ),
                        6.horizontalSpace,
                        Text('Edit playlist', style: AppTextStyle.style14W500),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.delete_simple,
                          size: SizeConfig.responsiveValue(
                            phone: 20.r,
                            tablet: 16.r,
                          ),
                        ),
                        6.horizontalSpace,
                        Text(
                          'Delete playlist',
                          style: AppTextStyle.style14W500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
