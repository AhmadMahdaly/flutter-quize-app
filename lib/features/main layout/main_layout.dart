import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/routing/app_router.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutCubit, MainLayoutState>(
      builder: (BuildContext context, state) {
        final cubit = context.read<MainLayoutCubit>();
        final mainLayoutInitialScreenIndex = cubit.mainLayoutInitialScreenIndex;
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: AppRouter().screen[mainLayoutInitialScreenIndex],
            bottomNavigationBar: Container(
              height: 70.h,
              margin: EdgeInsets.only(right: 16.w, left: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(80.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BottomNavItem(
                    index: 0,
                    currentIndex: mainLayoutInitialScreenIndex,
                    activeIcon: 'assets/images/icons/play (2).png',
                    inactiveIcon: 'assets/images/icons/play (1).png',
                    onTap: () => cubit.changeBottomNavBar(0),
                  ),
                  _BottomNavItem(
                    index: 1,
                    currentIndex: mainLayoutInitialScreenIndex,
                    activeIcon: 'assets/images/icons/home (1).png',
                    inactiveIcon: 'assets/images/icons/home.png',
                    onTap: () => cubit.changeBottomNavBar(1),
                  ),
                  _BottomNavItem(
                    index: 2,
                    currentIndex: mainLayoutInitialScreenIndex,
                    activeIcon: 'assets/images/icons/user (1).png',
                    inactiveIcon: 'assets/images/icons/user.png',
                    onTap: () => cubit.changeBottomNavBar(2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.index,
    required this.currentIndex,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final String activeIcon;
  final String inactiveIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.secondaryColor.withAlpha(40)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Image.asset(
          isActive ? activeIcon : inactiveIcon,
          height: 24.h,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
