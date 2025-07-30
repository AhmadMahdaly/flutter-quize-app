import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/features/analysis/cubit/analysis_cubit.dart';
import 'package:smle/features/analysis/widgets/analysis_chart_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'analysis'.tr(context)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: BlocBuilder<AnalysisCubit, AnalysisStates>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'analysis_title'.tr(context),
                    style: interRegular.copyWith(
                      color: AppColors.forthColor,
                      fontSize: SizeConfig.responsiveValue(
                        phone: 14.sp,
                        tablet: 18.sp,
                      ),
                    ),
                  ),
                  const Divider(),
                  Text(
                    'figure1'.tr(context),
                    style: interRegular.copyWith(
                      color: AppColors.errorColor,
                      fontSize: SizeConfig.responsiveValue(
                        phone: 12.sp,
                        tablet: 16.sp,
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: const BoxDecoration(
                                color: AppColors.greenColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            6.horizontalSpace,
                            Flexible(
                              child: Text(
                                'your_score'.tr(context),
                                overflow: TextOverflow.ellipsis,
                                style: interRegular.copyWith(
                                  color: AppColors.forthColor,
                                  fontSize: SizeConfig.responsiveValue(
                                    phone: 14.sp,
                                    tablet: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: const BoxDecoration(
                                color: AppColors.blueColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            6.horizontalSpace,
                            Flexible(
                              child: Text(
                                'score_who_passed'.tr(context),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: interRegular.copyWith(
                                  color: AppColors.forthColor,
                                  fontSize: SizeConfig.responsiveValue(
                                    phone: 14.sp,
                                    tablet: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (context.read<AnalysisCubit>().analysisModel != null)
                    SizedBox(
                      height: 400.h,
                      child: PerformanceChart(
                        data: context
                            .read<AnalysisCubit>()
                            .analysisModel!
                            .data!,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
