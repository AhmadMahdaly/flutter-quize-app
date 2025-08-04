import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';
import 'package:smle/features/play_list/widgets/play_list_widget.dart';
import 'package:smle/features/play_list/widgets/playlist_alert_widget.dart';

class PlayListScreen extends StatelessWidget {
  PlayListScreen({super.key, this.questionId});
  final TextEditingController playListNameController = TextEditingController();
  final int? questionId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'playlists'.tr(context)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: SingleChildScrollView(
          child: BlocBuilder<PlayListCubit, PlayListStates>(
            builder: (context, state) {
              final cubit = context.read<PlayListCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.verticalSpace,
                  Text(
                    'recently_added'.tr(context),
                    style: interBold.copyWith(
                      fontSize: SizeConfig.responsiveValue(
                        phone: 16.sp,
                        tablet: 20.sp,
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  if (cubit.playListModel != null)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {},
                        child: PlayListWidget(
                          playListNameController: playListNameController,
                          playListName:
                              '${cubit.playListModel!.data![index].name}',
                          questionCount: '${cubit.playListModel!.data!.length}',
                          playListId: '${cubit.playListModel!.data![index].id}',
                        ),
                      ),
                      separatorBuilder: (context, index) => 12.verticalSpace,
                      itemCount: cubit.playListModel!.data!.length,
                    ),
                  30.verticalSpace,
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
                                questionId: questionId,
                              ),
                            );
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          AppColors.secondaryColor,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: WidgetStateProperty.all(
                          Size(double.infinity, 52.h),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
