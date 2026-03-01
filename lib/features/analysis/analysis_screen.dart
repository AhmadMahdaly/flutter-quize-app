import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/shared_widgets/no_data_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/analysis/cubit/analysis_cubit.dart';
import 'package:smle/features/analysis/widgets/analysis_chart_widget.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key, required this.isExam});
  final bool isExam;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isExam,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.pushReplacementNamed(AppRoutes.mainLayoutScreen);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Analysis',
          canBack: !isExam,
          leading: IconButton(
            icon: Icon(
              size: SizeConfig.responsiveValue(phone: 24.sp, tablet: 30.sp),
              Icons.arrow_back_ios_new,
              color: AppColors.iconColorBlack,
            ),
            onPressed: () {
              // getIt<RealExamCubit>().resetExam();
              context.pushReplacementNamed(AppRoutes.mainLayoutScreen);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: BlocBuilder<AnalysisCubit, AnalysisStates>(
            builder: (context, state) {
              if (context.read<AnalysisCubit>().analysisModel != null) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      if (isExam)
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
                                  style: AppTextStyle.style16Bold.copyWith(
                                    color: AppColors.forthColor,
                                    fontSize: SizeConfig.responsiveValue(
                                      phone: 16.sp,
                                      tablet: 20.sp,
                                    ),
                                  ),
                                ),
                                8.verticalSpace,
                                Text(
                                  '${context.read<AnalysisCubit>().analysisModel!.totalScore}',
                                  style: AppTextStyle.style16Bold.copyWith(
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
                      if (isExam) 10.verticalSpace,
                      if (!isExam)
                        Text(
                          'This report outlines your strengths and weaknesses across assessed domains to help you understand and improve your performance.',
                          style: AppTextStyle.style14W500.copyWith(
                            color: AppColors.forthColor,
                            fontSize: SizeConfig.responsiveValue(
                              phone: 14.sp,
                              tablet: 18.sp,
                            ),
                          ),
                        ),
                      const Divider(),
                      if (!isExam)
                        Text(
                          'Figure1: Displays your performance in the test domains.',
                          style: AppTextStyle.style14W500.copyWith(
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
                                    'Your score',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.style14W500.copyWith(
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
                                    'Major score of who passed',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: AppTextStyle.style14W500.copyWith(
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
                      if (isExam)
                        buildDetailedTable(
                          context,
                          context.read<AnalysisCubit>().analysisModel!.data!,
                        ),
                      if (isExam) 20.verticalSpace,
                      if (isExam)
                        CustomPrimaryButton(
                          text: 'Back to Home',
                          onPressed: () {
                            // getIt<RealExamCubit>().resetExam();
                            context.pushReplacementNamed(
                              AppRoutes.mainLayoutScreen,
                            );
                          },
                        ),
                    ],
                  ),
                );
              } else if (state is GetAnalysisFailedState &&
                  state.error.contains(
                    'No analysis is available yet because you haven',
                  )) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_late_outlined,
                        size: 100.r,
                        color: AppColors.primaryColor.withAlpha(110),
                      ),
                      20.verticalSpace,
                      Text(
                        state.error,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.style20Bold.copyWith(
                          color: AppColors.forthColor.withAlpha(150),
                        ),
                      ),
                      50.verticalSpace,
                      CustomPrimaryButton(
                        text: 'Back to Home',
                        width: 250.w,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  ),
                );
              }
              // 3. حالة التحميل
              else if (state is GetAnalysisLoadingState) {
                return const SizedBox.shrink(); // اللودينج يظهر عبر showLoading()
              }
              // 4. الحالات الأخرى (No Data عامة)
              else {
                return const NoDataWidget(
                  noDataImage: '',
                  noDataText: 'No Data Found',
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
