import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/auth/cubit/login_cubit.dart';
import 'package:smle/features/auth/widgets/login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LogInSuccessState) {
              context.pushReplacementNamed(AppRoutes.mainLayoutScreen);
            } else if (state is LogInFailedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login Failed'),
                  backgroundColor: Colors.red,
                ),
              );
              // debugPrintWidget('Sign in failed: ${state.message}');
            }
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(gradient: appGradientHelper),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 16.h,
                    children: [
                      20.verticalSpace,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(320),
                        child: Image.asset(
                          'assets/images/png/logo final.png',
                          height: SizeConfig.responsiveValue(
                            phone: 150.h,
                            tablet: 75.h,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),

                      Text(
                        textAlign: TextAlign.center,
                        'Welcome to',
                        style: AppTextStyle.style20Bold.copyWith(
                          color: AppColors.greyColor,
                          fontSize: SizeConfig.responsiveValue(
                            phone: 24.sp,
                            tablet: 28.sp,
                          ),
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'SMLE Gate',
                        style: AppTextStyle.style20Bold.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: SizeConfig.responsiveValue(
                            phone: 34.sp,
                            tablet: 28.sp,
                          ),
                        ),
                      ),

                      Text(
                        'Your trusted partner for all your medical test',
                        style: AppTextStyle.style18W500.copyWith(
                          color: AppColors.greyColor,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      30.verticalSpace,
                      BlocBuilder<LoginCubit, LoginStates>(
                        builder: (context, state) {
                          if (state is LogInLoadingState) {
                            return const CircularProgressIndicator(
                              color: AppColors.greyColor,
                            );
                          }
                          return LoginButton(
                            onTap: () {
                              if (Platform.isAndroid) {
                                context.read<LoginCubit>().logInWithGoogle();
                              } else {
                                context.read<LoginCubit>().logInWithApple();
                              }
                            },
                          );
                        },
                      ),
                      8.verticalSpace,
                    ],
                  ),

                  Column(
                    children: [
                      FittedBox(
                        child: Row(
                          children: [
                            Text(
                              'By the',
                              style: AppTextStyle.style14W500.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Text(
                              ' ${'Register'} ',
                              style: AppTextStyle.style14W500.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),

                            Text(
                              'you confirm your agreement to the ',

                              style: AppTextStyle.style12W500.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            InkWell(
                              onTap: () => context.pushNamed(
                                AppRoutes.privacyPolicyScreen,
                              ),
                              child: Text(
                                'Privacy Policy',

                                style: AppTextStyle.style12W500.copyWith(
                                  color: AppColors.primaryColor,
                                  decorationColor: AppColors.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 16.verticalSpace,
                      // const PoweredByWidget(),
                    ],
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
