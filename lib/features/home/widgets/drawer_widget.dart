import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/features/login/cubit/login_cubit.dart';

import 'package:smle/core/di.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/home/widgets/drawer_item_widget.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.thirdColor,
      width: MediaQuery
          .of(context)
          .size
          .width / 2,
      child: ListView(
        children: [
          // Drawer Items
          DrawerItemWidget(iconAsset: Assets.userCircleLight,title:'profile'.tr(context) ,onTap: (){
            context.pushNamed(Routes.profileScreen);

          },),
          DrawerItemWidget(
            iconAsset: Assets.mortarboardLight,
            title: 'SCFHS_score_calculator'.tr(context),
            onTap: () {
              context.pushNamed(Routes.sCFHSScoreCalculatorScreen);
            },
          ),
          DrawerItemWidget(
            iconAsset: Assets.trophyLight,
            title: 'subscription'.tr(context),
            onTap: () {
              context.pushNamed(Routes.subscriptionScreen);
            },
          ),
          // DrawerItemWidget(iconAsset: Assets.columUpLight,title:'analysis'.tr(context) ,onTap: (){
          //   context.pushNamed(Routes.analysisScreen);
          // },),
          DrawerItemWidget(
            iconAsset: Assets.questionLight,
            title: 'support'.tr(context),
            onTap: () {
              context.pushNamed(Routes.supportScreen);
            },
          ),
          DrawerItemWidget(
              iconAsset: Assets.privacyPolicy,
              title: 'privacy_policy'.tr(context),
              onTap: () {
                context.pushNamed(Routes.privacyPolicyScreen);
              }),
          BlocProvider(
            create: (context) => LoginCubit(getIt()),
            child: BlocBuilder<LoginCubit, LoginStates>(
              builder: (context, state) {
                return DrawerItemWidget(
                    iconAsset: Assets.logOut,
                    title: 'log_out'.tr(context),
                    onTap: () {
                      context.read<LoginCubit>().logOut().then((value) {
                        if (value == true) {
                          context.pushReplacementNamed(Routes.loginScreen);
                        }
                      });
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
