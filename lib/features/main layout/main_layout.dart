import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/fcm.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/routing/app_router.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/home/widgets/drawer/drawer_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/notification/notification_permission_dialog.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  @override
  void initState() {
    FCMService.instance.initialize();
    if (mounted) {
      NotificationPermissionDialog.showIfNeeded(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MainLayoutCubit>()
          ..resetBackPress()
          ..getProfile()
          ..getGifts();
        await context.read<CheckSubscriptionCubit>().loadAllSubscriptions();
      },
      child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
        builder: (BuildContext context, state) {
          final cubit = context.read<MainLayoutCubit>();
          final mainLayoutInitialScreenIndex =
              cubit.mainLayoutInitialScreenIndex;
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              cubit.backPressCount++;

              if (cubit.backPressCount == 1 &&
                  mainLayoutInitialScreenIndex != 1) {
                cubit.changeBottomNavBar(1);
              } else if (cubit.backPressCount == 1 &&
                  mainLayoutInitialScreenIndex == 1) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      content: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(4.r),
                        padding: EdgeInsets.symmetric(vertical: 4.r),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(220),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: theme.colorScheme.onSurface,
                              size: 16.r,
                            ),
                            8.horizontalSpace,
                            Text(
                              'Press again to exit',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.style14Bold.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              } else {
                SystemNavigator.pop();
              }
            },
            child: Scaffold(
              drawer: const DrawerWidget(),
              // backgroundColor: Colors.transparent,
              body: AppRouter().screen[mainLayoutInitialScreenIndex],
              bottomNavigationBar: BottomNavigationBar(
                elevation: 0,
                backgroundColor: theme.colorScheme.primary,
                useLegacyColorScheme: false,
                unselectedFontSize: 0,
                selectedFontSize: 0,
                unselectedItemColor: theme.colorScheme.secondary,
                selectedItemColor: theme.colorScheme.onSurface,
                type: BottomNavigationBarType.fixed,
                landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
                onTap: cubit.changeBottomNavBar,
                items: [
                  BottomNavigationBarItem(
                    label: '',
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: mainLayoutInitialScreenIndex == 0
                            ? theme.colorScheme.secondary.withAlpha(40)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(320.r),
                      ),
                      child: Image.asset(
                        mainLayoutInitialScreenIndex == 0
                            ? 'assets/images/icons/play (2).png'
                            : 'assets/images/icons/play (1).png',
                        height: 24.h,
                        color: mainLayoutInitialScreenIndex == 0
                            ? theme.colorScheme.onPrimary.withAlpha(190)
                            : theme.colorScheme.surface,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: mainLayoutInitialScreenIndex == 1
                            ? theme.colorScheme.secondary.withAlpha(40)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(320.r),
                      ),
                      child: Image.asset(
                        mainLayoutInitialScreenIndex == 1
                            ? 'assets/images/icons/home (1).png'
                            : 'assets/images/icons/home.png',
                        height: 24.h,
                        color: mainLayoutInitialScreenIndex == 1
                            ? theme.colorScheme.onPrimary.withAlpha(190)
                            : theme.colorScheme.surface,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: mainLayoutInitialScreenIndex == 2
                            ? theme.colorScheme.secondary.withAlpha(40)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(320.r),
                      ),
                      child: Image.asset(
                        mainLayoutInitialScreenIndex == 2
                            ? 'assets/images/icons/user (1).png'
                            : 'assets/images/icons/user.png',
                        height: 24.h,
                        color: mainLayoutInitialScreenIndex == 2
                            ? theme.colorScheme.onPrimary.withAlpha(190)
                            : theme.colorScheme.surface,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ],
              ),
              //  Container(
              //   height: 80.h,
              //   // margin: EdgeInsets.only(right: 16.w, left: 16.w, bottom: 10.h),
              //   padding: EdgeInsets.symmetric(horizontal: 24.w),
              //   decoration: BoxDecoration(
              //     color: AppColors.secondaryColor.withAlpha(150),
              //     borderRadius: BorderRadius.circular(12.r),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              // _BottomNavItem(
              //   index: 0,
              //   currentIndex: mainLayoutInitialScreenIndex,
              //   activeIcon: 'assets/images/icons/play (2).png',
              //   inactiveIcon: 'assets/images/icons/play (1).png',
              //   onTap: () => cubit.changeBottomNavBar(0),
              // ),
              // _BottomNavItem(
              //   index: 1,
              //   currentIndex: mainLayoutInitialScreenIndex,
              //   activeIcon: 'assets/images/icons/home (1).png',
              //   inactiveIcon: 'assets/images/icons/home.png',
              //   onTap: () => cubit.changeBottomNavBar(1),
              // ),
              // _BottomNavItem(
              //   index: 2,
              //   currentIndex: mainLayoutInitialScreenIndex,
              //   activeIcon: 'assets/images/icons/user (1).png',
              //   inactiveIcon: 'assets/images/icons/user.png',
              //   onTap: () => cubit.changeBottomNavBar(2),
              // ),
              // ],
              // ),
              // ),
            ),
          );
        },
      ),
    );
  }
}

// class _BottomNavItem extends StatelessWidget {
//   const _BottomNavItem({
//     required this.index,
//     required this.currentIndex,
//     required this.activeIcon,
//     required this.inactiveIcon,
//     required this.onTap,
//   });

//   final int index;
//   final int currentIndex;
//   final String activeIcon;
//   final String inactiveIcon;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final bool isActive = index == currentIndex;

//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         padding: EdgeInsets.all(12.r),
//         decoration: BoxDecoration(
//           color: isActive
//               ? AppColors.primaryColor.withAlpha(40)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(320.r),
//         ),
//         child: Image.asset(
//           isActive ? activeIcon : inactiveIcon,
//           height: 24.h,
//           color: AppColors.primaryColor,
//           filterQuality: FilterQuality.high,
//         ),
//       ),
//     );
//   }
// }
