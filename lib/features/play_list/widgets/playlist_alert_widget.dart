import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/colors.dart';
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
    if (playListName != null) {
      playListNameController.text = playListName!;
    }
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          SizeConfig.responsiveValue(phone: 35.r, tablet: 12.r),
        ),
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: interBold.copyWith(
          fontSize: SizeConfig.responsiveValue(phone: 18.sp, tablet: 22.sp),
        ),
      ),
      content: SizedBox(
        width: SizeConfig.screenWidth,
        child: TextFormField(
          controller: playListNameController,
          style: interRegular.copyWith(color: AppColors.darkGreyColor),
          decoration: InputDecoration(
            fillColor: AppColors.greyColor, // Background color
            filled: true, // Enables the background color
            hintText: 'title'.tr(context),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.r)),
              borderSide: const BorderSide(color: AppColors.greyColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.r)),
              borderSide: const BorderSide(color: AppColors.greyColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.r)),
              borderSide: const BorderSide(color: AppColors.greyColor),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'cansel'.tr(context),
            style: interRegular.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 16.sp),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (isEdit) {
              context
                  .read<PlayListCubit>()
                  .editPlayList(playListId!, playListNameController.text)
                  .then((onValue) {
                    Navigator.pop(context);
                    context.pushReplacementNamed(
                      Routes.playListScreen,
                      arguments: questionId,
                    );
                  });
            }
            {
              context
                  .read<PlayListCubit>()
                  .createPlayList(playListNameController.text, questionId)
                  .then((onValue) {
                    Navigator.pop(context);
                    context.pushReplacementNamed(
                      Routes.playListScreen,
                      arguments: questionId,
                    );
                  });
            }
          },
          child: Text(
            isEdit ? 'edit'.tr(context) : 'create'.tr(context),
            style: interBold.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 16.sp),
            ),
          ),
        ),
      ],
    );
  }
}
