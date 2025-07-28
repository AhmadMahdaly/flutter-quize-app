import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/login/cubit/login_cubit.dart';
import 'package:smle/features/login/widgets/login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LogInSuccessState) {
              context.pushReplacementNamed(Routes.mainLayoutScreen);
            } else if (state is LogInFailedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
              debugPrintWidget('Sign in with Google failed: ${state.message}');
            }
          },
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.darkGreyColor],
                begin: Alignment.center,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset(Assets.logoCircle),
                      15.verticalSpace,
                      Text(
                        "  ${'welcome_to'.tr(context)}  \n(${'smle_gate'.tr(context)})",
                        style: interExtraBold.copyWith(fontSize: 24.sp),
                      ),
                      20.verticalSpace,
                      Text(
                        'trusted_partner'.tr(context),
                        style: interBold.copyWith(fontSize: 20.sp),
                        textAlign: TextAlign.center,
                      ),
                      50.verticalSpace,
                      Text(
                        'log_in'.tr(context),
                        style: interBold.copyWith(fontSize: 18.sp),
                      ),
                      25.verticalSpace,
                      BlocBuilder<LoginCubit, LoginStates>(
                        builder: (context, state) {
                          if (state is LogInLoadingState) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          return LoginButton(
                            onTap: () {
                              context.read<LoginCubit>().logInWithGoogle();
                            },
                          );
                        },
                      ),
                      25.verticalSpace,
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'by_the'.tr(context),
                              style: interRegular.copyWith(fontSize: 14.sp)),
                          TextSpan(
                              text: 'register'.tr(context),
                              style: interRegular.copyWith(
                                  color: AppColors.secondaryColor,
                                  fontSize: 14.sp)),
                          TextSpan(
                              text: 'confirm_agreement'.tr(context),
                              style: interRegular.copyWith(fontSize: 14.sp)),
                          TextSpan(
                              text: 'privacy_policy'.tr(context),
                              style: interRegular.copyWith(
                                  color: AppColors.secondaryColor,
                                  fontSize: 14.sp)),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
