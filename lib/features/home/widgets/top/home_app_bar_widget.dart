import 'package:flutter/material.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // actions: [
      //   GestureDetector(
      //     onTap: (){
      //       context.pushNamed(Routes.notificationScreen);
      //     },
      //     child: Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 15.w),
      //       child: Icon(
      //         CupertinoIcons.bell,
      //         color: AppColors.iconColorBlack,
      //         size: 25.sp,
      //       ),
      //     ),
      //   )
      // ],
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
