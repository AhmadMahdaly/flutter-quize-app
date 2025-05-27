import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class NoDataWidget extends StatelessWidget {
  final String noDataImage;
  final String noDataText;
  const NoDataWidget({super.key, required this.noDataImage, required this.noDataText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          110.verticalSpace,
          if(noDataImage!='')
          Image(image: AssetImage(noDataImage)),
          40.verticalSpace,
          Text(noDataText,style: interBold.copyWith(fontSize: 20.sp,color: AppColors.forthColor),)
        ],
      ),
    );
  }
}

class LoadingDataWidget extends StatelessWidget {
  const LoadingDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: AppColors.forthColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,))
            ],
          ),
        );
  }
}
