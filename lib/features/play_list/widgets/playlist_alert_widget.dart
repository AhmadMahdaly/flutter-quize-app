import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';

class PlaylistAlertWidget extends StatelessWidget {
  const PlaylistAlertWidget({
    super.key,
    required this.playListNameController,
    required this.title,
    required this.isEdit,
    this.playListName,
    this.playListId,
    this.questionId,
  });
  final TextEditingController playListNameController;
  final String title;
  final String? playListName, playListId;
  final int? questionId;
  final bool isEdit;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (playListName != null) {
      playListNameController.text = playListName!;
    }
    return BlocListener<PlayListCubit, PlayListStates>(
      listener: (context, state) {
        if (state is CreatePlayListSuccessState ||
            state is EditPlayListSuccessState) {
          playListNameController.clear();
          context.pop();
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            SizeConfig.responsiveValue(phone: 12.r, tablet: 12.r),
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          title,
          style: AppTextStyle.style18Bold.copyWith(
            fontSize: SizeConfig.responsiveValue(phone: 18.sp, tablet: 22.sp),
          ),
        ),
        content: SizedBox(
          width: SizeConfig.screenWidth,
          child: CustomPrimaryTextfield(
            controller: playListNameController,

            text: 'Playlist title',
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: AppTextStyle.style14W500.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
              CustomPrimaryHButton(
                onPressed: () {
                  if (isEdit) {
                    context.read<PlayListCubit>().editPlayList(
                      playListId!,
                      playListNameController.text,
                    );
                  } else {
                    context.read<PlayListCubit>().createPlayList(
                      playListNameController.text,
                      questionId,
                    );
                  }
                },
                text: isEdit ? 'Edit' : 'Create',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
