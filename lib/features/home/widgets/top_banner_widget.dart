import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/text_styles.dart';

class TopBannerWidget extends StatelessWidget {
  const TopBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(40),
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: SizeConfig.screenWidth / 2,
              child: FittedBox(
                child: Text.rich(
                  maxLines: 2,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '+18,000 ',
                        style: AppTextStyle.style16Bold.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(170),
                        ),
                      ),
                      TextSpan(
                        text: 'Questions across\nall medical specialties',
                        style: AppTextStyle.style16Bold.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontSize: SizeConfig.responsiveValue(
                            phone: 16.sp,
                            tablet: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -5,
              right: -20,
              child: Image.asset(
                'assets/images/png/medical-check.png',
                height: SizeConfig.responsiveValue(phone: 90.h, tablet: 70.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
