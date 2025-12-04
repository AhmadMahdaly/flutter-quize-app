import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
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
    final cubit = context.read<PlayListCubit>();
    return GestureDetector(
      onTap: onTap ?? () {}, // استخدم الـ
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            Assets.questionMark,
            height: SizeConfig.responsiveValue(phone: 80.h, tablet: 80.h),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playListName,
                  style: AppTextStyle.style16W700.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '$questionCount ${'question'.tr(context)}',
                  style: AppTextStyle.style14W500.copyWith(
                    color: AppColors.darkGreyColor,
                  ),
                ),
                10.verticalSpace,
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
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
                        title: 'edit_playlist'.tr(context),
                        isEdit: true,
                        playListName: playListName,
                        playListId: playListId,
                      ),
                    );
                  },
                );
              } else if (value == 'delete') {
                cubit.deletePlayList(playListId);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                      'delete_playlist'.tr(context),
                      style: AppTextStyle.style14W500,
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.pencil,
                      size: SizeConfig.responsiveValue(
                        phone: 20.r,
                        tablet: 16.r,
                      ),
                    ),
                    6.horizontalSpace,
                    Text('edit'.tr(context), style: AppTextStyle.style14W500),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
