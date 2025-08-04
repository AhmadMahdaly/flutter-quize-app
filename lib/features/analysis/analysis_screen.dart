import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/shared_widgets/no_data_widget.dart';
import 'package:smle/features/analysis/cubit/analysis_cubit.dart';
import 'package:smle/features/analysis/widgets/analysis_chart_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key,required this.isExam});
 final bool isExam;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'analysis'.tr(context),
      canBack: !isExam,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: BlocBuilder<AnalysisCubit, AnalysisStates>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: context
                  .read<AnalysisCubit>()
                  .analysisModel!=null?
              Column(
                children: [
                  if(isExam)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Your Final Score',
                            style: interBold.copyWith(
                              color: AppColors.forthColor,
                              fontSize: SizeConfig.responsiveValue(
                                phone: 16.sp,
                                tablet: 20.sp,
                              ),
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            '${context
                                .read<AnalysisCubit>()
                                .analysisModel!
                                .totalScore}',
                            style: interBold.copyWith(
                              color: AppColors.primaryColor,
                              fontSize: SizeConfig.responsiveValue(
                                phone: 24.sp,
                                tablet: 28.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(isExam)
                  10.verticalSpace,
                  if(!isExam)
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
                  if(!isExam)
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
                  30.verticalSpace,
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
                    30.verticalSpace,
                    if (context.read<AnalysisCubit>().analysisModel != null)
                      PerformanceChart(
                      data: context
                          .read<AnalysisCubit>()
                          .analysisModel!
                          .data!,
                    ),
                  if(isExam)
                  buildDetailedTable(context,  context
                      .read<AnalysisCubit>()
                      .analysisModel!
                      .data!,),
                  if(isExam)
                    20.verticalSpace,
                    if(isExam)
                    CustomPrimaryButton(
                      text: 'Back to Home',
                      onPressed: () {
                        getIt<RealExamCubit>().resetExam();
                        context.pushReplacementNamed(Routes.mainLayoutScreen);
                      },
                    ),
                ],
              ):NoDataWidget(noDataImage: '', noDataText: 'no_data_found'.tr(context)),
            );
          },
        ),
      ),
    );
  }
}
