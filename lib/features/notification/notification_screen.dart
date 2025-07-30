import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: 'notification'.tr(context),),
      body:
      // NoDataWidget(noDataImage:Assets.noNotification ,noDataText:'no_notification_yet'.tr(context) ,),
      Padding(
        padding:  EdgeInsets.symmetric(vertical: 15.h),
        child: Column(
          children: [
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index)=>          Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.w),
                  child: Stack(
                    children: [
                      Container(
                                  decoration: BoxDecoration(
                        color: AppColors.darkGreyColor,
                        borderRadius: BorderRadius.all(Radius.circular( 50.r))
                                  ),
                        padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
                        child: Row(
                          children: [
                            index==1? Image.asset(Assets.crownIcon):const SizedBox.shrink(),
                            10.horizontalSpace,
                             Flexible(child: Text.rich(
                                 TextSpan(   children:[
                                   if(index==3)
                               TextSpan(text: '5 SAR ',style: interBold.copyWith(color: AppColors.thirdColor)),
                               TextSpan(text: 'Only two days left until your subscription expires!',style: interRegular.copyWith(color: AppColors.forthColor)),
                               ]
                                ))),
                          ],
                        ),
                                ),
                      index==3?Positioned(
                        right: 24,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset(Assets.coinsIcon),
                        ),
                      ):const SizedBox.shrink(),

                    ],
                  ),
                )
                , separatorBuilder: (context,index)=>20.verticalSpace, itemCount: 5)
          ],
        ),
      )
    );
  }
}
