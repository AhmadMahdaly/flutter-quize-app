import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
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
  });
  final String playListName, questionCount, playListId;
  final TextEditingController playListNameController;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          Assets.questionMark,
          height: SizeConfig.responsiveValue(phone: 80.h, tablet: 80.h),
        ),
        10.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150.w,
              child: Text(
                playListName,
                style: interMedium.copyWith(
                  fontSize: SizeConfig.responsiveValue(
                    phone: 16.sp,
                    tablet: 20.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(
              '$questionCount ${'question'.tr(context)}',
              style: interRegular.copyWith(
                fontSize: 14.sp,
                color: AppColors.darkGreyColor,
              ),
            ),
            10.verticalSpace,
          ],
        ),
        const Spacer(),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert), // three dots icon
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            // Handle menu selection
            if (value == 'edit') {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlocProvider(
                    create: (context) => PlayListCubit(getIt()),
                    child: BlocBuilder<PlayListCubit, PlayListStates>(
                      builder: (context, state) {
                        return PlaylistAlertWidget(
                          playListNameController: playListNameController,
                          title: 'edit_playlist'.tr(context),
                          isEdit: true,
                          playListName: playListName,
                          playListId: playListId,
                        );
                      },
                    ),
                  );
                },
              );
            } else if (value == 'delete') {
              context.read<PlayListCubit>().deletePlayList(playListId).then((
                onValue,
              ) {
                context.pushReplacementNamed(Routes.playListScreen);
              });
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.delete_simple,

                    size: SizeConfig.responsiveValue(phone: 20.r, tablet: 16.r),
                  ),
                  6.horizontalSpace,
                  Text(
                    'delete_playlist'.tr(context),
                    style: interRegular.copyWith(
                      fontSize: SizeConfig.responsiveValue(
                        phone: 14.sp,
                        tablet: 16.sp,
                      ),
                    ),
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
                    size: SizeConfig.responsiveValue(phone: 20.r, tablet: 16.r),
                  ),
                  6.horizontalSpace,
                  Text(
                    'edit'.tr(context),
                    style: interRegular.copyWith(
                      fontSize: SizeConfig.responsiveValue(
                        phone: 14.sp,
                        tablet: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
