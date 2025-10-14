import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
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
                    spacing: 16.h,
                    children: [
                      Image.asset(
                        Assets.logoCircle,
                        height: SizeConfig.responsiveValue(
                          phone: null,
                          tablet: 75.h,
                        ),
                        fit: BoxFit.cover,
                      ),
                      10.verticalSpace,
                      Text(textAlign: TextAlign.center,
                        "${'welcome_to'.tr(context)}\n(${'smle_gate'.tr(context)})",
                        style: interExtraBold.copyWith(
                          fontSize: SizeConfig.responsiveValue(
                            phone: 24.sp,
                            tablet: 28.sp,
                          ),
                        ),
                      ),
                      Text(
                        'trusted_partner'.tr(context),
                        style: interBold.copyWith(
                          fontSize: SizeConfig.responsiveValue(
                            phone: 18.sp,
                            tablet: 20.sp,
                          ),fontWeight: FontWeight.w500
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Text(
                      //   'log_in'.tr(context),
                      //   style: interBold.copyWith(
                      //     fontSize: SizeConfig.responsiveValue(
                      //       phone: 18.sp,
                      //       tablet: 22.sp,
                      //     ),
                      //   ),
                      // ),
                      30.verticalSpace,
                      BlocBuilder<LoginCubit, LoginStates>(
                        builder: (context, state) {
                          if (state is LogInLoadingState) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          return LoginButton(
                            onTap: () {
                              if (Platform.isAndroid) {
                                context.read<LoginCubit>().logInWithGoogle();
                                // context.pushReplacementNamed(
                                //   Routes.mainLayoutScreen,
                                // );
                              } else {
                                context.read<LoginCubit>().logInWithApple();
                                // context.pushReplacementNamed(
                                //   Routes.mainLayoutScreen,
                                // );
                              }
                            },
                          );
                        },
                      ),
                      8.verticalSpace,
                      TextButton(
                        onPressed: () {
                          context.pushReplacementNamed(Routes.guestScreen);
                        },
                        child: Text(
                          'Continue As Guest',
                          style: interBold.copyWith(
                            color: AppColors.secondaryColor,
                            fontSize: SizeConfig.responsiveValue(
                              phone: 14.sp,
                              tablet: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
      
                  FittedBox(
                    child: Row(
                      children: [
                        Text('by_the'.tr(context),
                          style: interRegular.copyWith(
                            fontSize: SizeConfig.responsiveValue(
                              phone: 14.sp,
                              tablet: 18.sp,
                            ),)), Text('${'register'.tr(context)} ',
                          style: interRegular.copyWith(
                            fontSize: SizeConfig.responsiveValue(
                              phone: 14.sp,
                              tablet: 18.sp,
                            ),
                                ),
                              ),
                          
                   
                          Text(
                            'confirm_agreement'.tr(context),

                            style: interRegular.copyWith(
                              fontSize: SizeConfig.responsiveValue(
                                phone: 12.sp,
                                tablet: 18.sp,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                context.pushNamed(Routes.privacyPolicyScreen),
                            child: Text(
                              'privacy_policy'.tr(context),

                              style: interRegular.copyWith(
                                color: AppColors.secondaryColor,
                                fontSize: SizeConfig.responsiveValue(
                                  phone: 12.sp,
                                  tablet: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  )  ],

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
