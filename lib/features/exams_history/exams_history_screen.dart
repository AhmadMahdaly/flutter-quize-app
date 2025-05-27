import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/text_styles.dart';
import '../../core/theme/colors.dart';

class ExamsHistoryScreen extends StatelessWidget {
  const ExamsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'exams_history'.tr(context),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              children: [
                TabBar(
                  unselectedLabelColor : AppColors.darkGreyColor,
                  labelColor: AppColors.forthColor,
                  indicator: const BoxDecoration(), // No underline
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      text: "pass".tr(context),
                    ),
                    Tab(text: "mid_level".tr(context)),
                    Tab(text: "fail".tr(context)),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [
                    ListView.separated(
                        itemBuilder: (context,index)=>Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${'exam'.tr(context)} ${index + 1}',style: interBold.copyWith(fontSize: 16.sp,
                      decoration: TextDecoration.underline,
                    ),),
                    10.verticalSpace,
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text('60 ${'marks'.tr(context)}',style: interMedium.copyWith(fontSize: 16.sp),)),
                    10.verticalSpace,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.r),
                      child: SizedBox(
                        height: 40.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.r),
                              child: SizedBox(
                                height: 40.h,
                                child: LinearProgressIndicator(
                                  value: 60 / 100,
                                  backgroundColor: AppColors.greyColor,
                                  color: AppColors.successColor,
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:  EdgeInsets.only(right: 8.w),
                                  child: Text("60/100%",style: interBold.copyWith(fontSize: 14.sp,color: AppColors.forthColor),),
                                )),

                          ],
                        ),
                      ),
                    ),
                  ],
                    ), separatorBuilder: (context,index)=>20.verticalSpace, itemCount: 10),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index)=>Container(
                  
                    ), separatorBuilder: (context,index)=>20.verticalSpace, itemCount: 10),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index)=>Container(
                  
                    ), separatorBuilder: (context,index)=>20.verticalSpace, itemCount: 10),
                  
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
