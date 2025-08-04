import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';

class ProfileAppBarWidgets extends StatelessWidget
    implements PreferredSizeWidget {
  const ProfileAppBarWidgets({
    super.key,
    this.canBack = true,
    required this.imagePath,
  });
  final bool canBack;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allows overflow positioning
      children: [
        AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          leading: canBack
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.iconColorBlack,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : const SizedBox(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(90.r),
              bottomLeft: Radius.circular(15.r),
            ),
          ),
        ),

        // Positioned(
        //   bottom: SizeConfig.responsiveValue(phone: -80, tablet: -50.h),
        //   left:
        //       MediaQuery.of(context).size.width / 2 -
        //       SizeConfig.responsiveValue(phone: 80.r, tablet: 30.r),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       border: Border.all(color: AppColors.darkGreyColor, width: 1.r),
        //     ),
        //     child: CircleAvatar(
        //       radius: SizeConfig.responsiveValue(
        //         phone: 80.r,
        //         tablet: 30.r,
        //       ), // Avatar size
        //       backgroundColor: AppColors.greyColor,
        //       child: Stack(
        //         children: [
        //           Padding(
        //             padding: EdgeInsets.only(top: 5.h),
        //             child: Image(
        //               image: imagePath.isEmpty
        //                   ? const AssetImage(
        //                       Assets.user,
        //                     ) // Use a valid asset path
        //                   : NetworkImage(imagePath) as ImageProvider,
        //             ),
        //           ),
        //           Positioned(
        //             bottom: 0,
        //             right: 0,
        //             child: Container(
        //               padding: EdgeInsets.symmetric(
        //                 vertical: 5.h,
        //                 horizontal: 5.w,
        //               ),
        //               decoration: const BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: AppColors.secondaryColor,
        //               ),
        //               child: const Icon(CupertinoIcons.camera),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h); // Adjust height if needed
}
