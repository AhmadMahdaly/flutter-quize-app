import 'package:flutter/material.dart';
import 'package:smle/core/functions/date_format.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_cache_image.dart';
import 'package:smle/core/theme/text_styles.dart';

class UserImageNameWidget extends StatelessWidget {
  const UserImageNameWidget({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
    required this.points,
  });
  final String name, email, points;
  final String? imagePath;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: theme.colorScheme.surface.withAlpha(190),

          child: (imagePath == null || imagePath!.isEmpty)
              ? Icon(
                  Icons.person,
                  size: 25.r,
                  color: theme.colorScheme.onSurface.withAlpha(160),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(320.r),
                  child: CustomCacheImageWidget(imageUrl: imagePath!),
                ),
        ),

        15.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 4.w,
                children: [
                  Text(
                    'Hello ',
                    style: AppTextStyle.style12Bold.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 250.w,
                    child: Text(
                      name,
                      style: AppTextStyle.style12Bold.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   width: MediaQuery.sizeOf(context).width - 150.w,
              //   child: Text(
              //     email,
              //     maxLines: 1,
              //     overflow: TextOverflow.ellipsis,
              //     style: AppTextStyle.style12W500.copyWith(
              //       color: AppColors.secondaryColor,
              //     ),
              //   ),
              // ),
              Text(
                getGreetingWithEmoji(context),
                style: AppTextStyle.style16Bold.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(210),
                ),
              ),
              // Row(
              //   children: [
              //     Text(
              //       '$points ',
              //       style: AppTextStyle.style14Bold.copyWith(
              //         color: AppColors.primaryColor,
              //       ),
              //     ),
              //     Text(
              //       'Points',
              //       style: AppTextStyle.style12Bold.copyWith(
              //         color: AppColors.secondaryColor,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
