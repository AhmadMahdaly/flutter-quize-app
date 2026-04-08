import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    super.key,
    required this.noDataImage,
    required this.noDataText,
  });
  final String noDataImage;
  final String noDataText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (noDataImage != '')
          Center(child: Image(image: AssetImage(noDataImage))),
        20.verticalSpace,
        Center(
          child: Text(
            noDataText,
            style: AppTextStyle.style20Bold.copyWith(
              color: AppColors.thirdColor.withAlpha(100),
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingDataWidget extends StatelessWidget {
  const LoadingDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // backgroundColor: AppColors.primaryColor.withAlpha(200),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    );
  }
}
