import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/revision/cubit/revision_cubit.dart';

class RevisionScreen extends StatelessWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'revision'.tr(context)),
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
                        horizontal: 15.w,
                        vertical: 15.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreyColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            SizeConfig.responsiveValue(
                              phone: 60.r,
                              tablet: 16.r,
                            ),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 30.h),
                            child: Text(
                              '${context.read<RevisionCubit>().subCategoriesModel!.data!.name}',
                              style: interBold.copyWith(
                                fontSize: SizeConfig.responsiveValue(
                                  phone: 16.sp,
                                  tablet: 20.sp,
                                ),
                                color: AppColors.thirdColor,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          Image.network(
                            fit: BoxFit.cover,
                            '${context.read<RevisionCubit>().subCategoriesModel!.data!.photo}',
                          ),
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
                              style: interBold.copyWith(
                                fontSize: SizeConfig.responsiveValue(
                                  phone: 16.sp,
                                  tablet: 20.sp,
                                ),
                              ),
                            ),
                          ),
                          10.verticalSpace,
                          Container(
                            width: SizeConfig.responsiveValue(
                              phone: 150.w,
                              tablet: 250.w,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  SizeConfig.responsiveValue(
                                    phone: 25.r,
                                    tablet: 12.r,
                                  ),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.responsiveValue(
                                  phone: 6.h,
                                  tablet: 16.h,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                        Routes.pdfViewerFromUrlScreen,
                                        arguments: context
                                            .read<RevisionCubit>()
                                            .subCategoriesModel!
                                            .data!
                                            .chapters![index]
                                            .pdf,
                                      );
                                      // context.read<RevisionCubit>().openPDF(
                                      //   '${context.read<RevisionCubit>().subCategoriesModel!.data!.chapters![index].pdf}',
                                      // );
                                    },
                                    child: Image.asset(
                                      Assets.pdfButton,
                                      fit: BoxFit.cover,
                                      height: SizeConfig.responsiveValue(
                                        phone: 30.h,
                                        tablet: 50.h,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                        Routes.videoPlayerScreen,
                                        arguments: context
                                            .read<RevisionCubit>()
                                            .subCategoriesModel!
                                            .data!
                                            .chapters![index]
                                            .video,
                                      );
                                      // context.read<RevisionCubit>().launchVideo(
                                      //   '${context.read<RevisionCubit>().subCategoriesModel!.data!.chapters![index].video}',
                                      // );
                                    },
                                    child: Image.asset(
                                      Assets.mp4Button,
                                      fit: BoxFit.cover,
                                      height: SizeConfig.responsiveValue(
                                        phone: 30.h,
                                        tablet: 50.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      separatorBuilder: (context, index) => 16.verticalSpace,
                      itemCount: context
                          .read<RevisionCubit>()
                          .subCategoriesModel!
                          .data!
                          .chapters!
                          .length,
                    ),
                  // if (context.read<RevisionCubit>().subCategoriesModel == null)
                  //   const Text('no'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
