import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/features/analysis/widgets/circle_image_widget.dart';
import 'package:smle/features/analysis/widgets/number_text_widget.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: 'analysis'.tr(context),),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberTextWidget(text: 'number_doctors'.tr(context), number: '100'),
                NumberTextWidget(text: 'number_exams'.tr(context), number: '50'),

              ],
            ),
            30.verticalSpace,
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              CircleImageWidget(imagePath: 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png', number: '2'),
              CircleImageWidget(imagePath: 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png', number: '1'),
              CircleImageWidget(imagePath: 'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png', number: '3'),

              ],
            ),
            30.verticalSpace,
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context,index)=>Container(
                  decoration: BoxDecoration(
                    color:index==0? AppColors.primaryColor:Colors.transparent,
                    borderRadius: BorderRadius.circular(30.r)
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: index==0?MainAxisAlignment.center:MainAxisAlignment.start,
                      children: [
                        Text('${index+1}-   ',style: interBold.copyWith(fontSize: 16.sp),),
                        Text('Hager Hifnawy',style: interBold.copyWith(fontSize: 16.sp),),
                      ],

                    ),
                  ),
                ), separatorBuilder: (context,index)=>20.verticalSpace, itemCount: 5)


          ],
        ),
      ),
    );
  }
}
