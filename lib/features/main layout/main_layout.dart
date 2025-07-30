import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/constants.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/routing/app_router.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutCubit, MainLayoutState>(
      builder: (BuildContext context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: AppRouter().screen[mainLayoutInitialScreenIndex],
            bottomNavigationBar: Container(
              height: SizeConfig.responsiveValue(phone: null, tablet: 60.h),
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(60.r)),
              ),
              child: BottomNavigationBar(
                selectedFontSize: 0,
                unselectedFontSize: 0,
                backgroundColor: AppColors.primaryColor,
                onTap: (index) {
                  MainLayoutCubit.get(context).changeBottomNavBar(index);
                },
                currentIndex: mainLayoutInitialScreenIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.thirdColor,
                        shape: BoxShape.circle,
                      ),
                      child: ImageIcon(
                        size: SizeConfig.responsiveValue(
                          phone: 18.sp,
                          tablet: 36.sp,
                        ),
                        const AssetImage(Assets.videoLight),
                        color: AppColors.forthColor,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.thirdColor,
                        shape: BoxShape.circle,
                      ),
                      child: ImageIcon(
                        size: SizeConfig.responsiveValue(
                          phone: 18.sp,
                          tablet: 36.sp,
                        ),
                        const AssetImage(Assets.homeLight),
                        color: AppColors.forthColor,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.thirdColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: ImageIcon(
                          size: SizeConfig.responsiveValue(
                            phone: 18.sp,
                            tablet: 36.sp,
                          ),
                          const AssetImage(Assets.userCircleLight),
                          color: AppColors.forthColor,
                        ),
                      ),
                    ),
                    label: '',
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
