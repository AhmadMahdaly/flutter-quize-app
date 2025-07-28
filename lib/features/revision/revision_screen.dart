import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/features/revision/cubit/revision_cubit.dart';

import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class RevisionScreen extends StatelessWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'revision'.tr(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: BlocBuilder<RevisionCubit, RevisionStates>(
            builder: (context, state) {
              return Column(
                children: [
                  if (context.read<RevisionCubit>().subCategoriesModel != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 15.h),
                      decoration: BoxDecoration(
                          color: AppColors.darkGreyColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(60.r))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 30.h),
                            child: Text(
                                '${context.read<RevisionCubit>().subCategoriesModel!.data!.name}',
                                style: interBold.copyWith(
                                    fontSize: 16.sp,
                                    color: AppColors.thirdColor)),
                          ),
                          // Icon(Icons.add)
                        ],
                      ),
                    ),
                  30.verticalSpace,
                  if (context.read<RevisionCubit>().subCategoriesModel != null)
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '${context.read<RevisionCubit>().subCategoriesModel!.data!.chapters![index].name}',
                                    style: interBold.copyWith(fontSize: 16.sp),
                                  ),
                                ),
                                10.verticalSpace,
                                Container(
                                  width: 150.w,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.r))),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 6.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              context.read<RevisionCubit>().openPDF(
                                                  '${context.read<RevisionCubit>().subCategoriesModel!.data!.chapters![index].pdf}');
                                            },
                                            child:
                                                Image.asset(Assets.pdfButton)),
                                        GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<RevisionCubit>()
                                                  .launchVideo(
                                                      '${context.read<RevisionCubit>().subCategoriesModel!.data!.chapters![index].video}');
                                            },
                                            child:
                                                Image.asset(Assets.mp4Button)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                        separatorBuilder: (context, index) => 20.verticalSpace,
                        itemCount: context
                            .read<RevisionCubit>()
                            .subCategoriesModel!
                            .data!
                            .chapters!
                            .length)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
