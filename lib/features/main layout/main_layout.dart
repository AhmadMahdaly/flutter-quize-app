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
            body: AppRouter().screen[mainLayoutInitialScreenIndex],
            bottomNavigationBar: Container(
              height: SizeConfig.responsiveValue(phone: 80.h, tablet: 60.h),
              margin: EdgeInsets.symmetric(horizontal: 0.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(60.r)),
              ),
              child: BottomNavigationBar(
                elevation: 0,
                useLegacyColorScheme: false,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                type: BottomNavigationBarType.fixed,
                fixedColor: AppColors.secondaryColor,
                unselectedItemColor: AppColors.darkGreyColor,

                backgroundColor: AppColors.primaryColor,
                onTap: (index) {
                  cubit.changeBottomNavBar(index);
                },
                currentIndex: mainLayoutInitialScreenIndex,
                items: [
                  BottomNavigationBarItem(
                    label: '',
                    icon: Image.asset(
                      filterQuality: FilterQuality.high,
                      // color: AppColors.secondaryColor,
                      height: 24.h,
                      mainLayoutInitialScreenIndex == 0
                          ? 'assets/images/icons/play (2).png'
                          : 'assets/images/icons/play (1).png',
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: Image.asset(
                      filterQuality: FilterQuality.high,
                      // color: AppColors.secondaryColor,
                      height: 24.h,
                      mainLayoutInitialScreenIndex == 1
                          ? 'assets/images/icons/home (1).png'
                          : 'assets/images/icons/home.png',
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: '',
                    icon: Image.asset(
                      filterQuality: FilterQuality.high,
                      // color: AppColors.secondaryColor,
                      height: 24.h,
                      mainLayoutInitialScreenIndex == 2
                          ? 'assets/images/icons/user (1).png'
                          : 'assets/images/icons/user.png',
                    ),
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
