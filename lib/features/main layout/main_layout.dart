import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import '../../core/constants.dart';
import '../../core/routing/app_router.dart';
import 'cubit/main_layout_cubit.dart';

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
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(60.r)),
                child: BottomNavigationBar(
                  backgroundColor: AppColors.primaryColor,
                  onTap: (index) {
                    MainLayoutCubit.get(context).changeBottomNavBar(index);
                  },
                  currentIndex: mainLayoutInitialScreenIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.thirdColor, // Background color for the icon
                          shape: BoxShape.circle, // Makes the background circular
                        ),
                        child: const ImageIcon(
                          AssetImage(Assets.videoLight),
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
                        child: const ImageIcon(
                          AssetImage(Assets.homeLight),
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
                        child: const Center(
                          child: ImageIcon(
                            AssetImage(Assets.userCircleLight),
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
          ),
        );
      },
    );
  }
}
