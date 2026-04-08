import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/get_app_version.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class PoweredByWidget extends StatelessWidget {
  const PoweredByWidget({super.key});

  Future<void> _launchUpdateUrl(BuildContext context) async {
    final Uri url = Uri.parse(
      'https://sitksa-eg.com/ar',
      // Theme.of(context).platform == TargetPlatform.iOS
      //     ? UpdateScreen.iosUrl
      //     : UpdateScreen.androidUrl,
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrintWidget('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 30.h),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _launchUpdateUrl(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Powered by:',
                    style: AppTextStyle.style12W700.copyWith(
                      fontSize: 11.sp,
                      color: AppColors.greyColor.withAlpha(150),
                    ),
                  ),
                  2.horizontalSpace,
                  Image.asset('assets/images/png/sit_logo.png', height: 30.h),
                ],
              ),
              2.verticalSpace,
              FutureBuilder<String>(
                future: getAppVersion(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  } else if (snapshot.hasError) {
                    return const Text('');
                  } else {
                    return Text(
                      '${'Version Number'}: ${snapshot.data}',
                      style: AppTextStyle.style9W600.copyWith(
                        fontSize: 10.sp,
                        color: AppColors.greyColor.withAlpha(150),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
