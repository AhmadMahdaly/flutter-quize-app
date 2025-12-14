import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/features/home/widgets/category/base_category_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class AnalysisHomeWidget extends StatelessWidget {
  const AnalysisHomeWidget({super.key, required this.isSubscribed});

  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    return CategoryWidget(
      onTap: () {
        if (!isSubscribed) {
          showCustomPrimaryDialog(
            context,
            widget: CustomPrimaryDialog(
              title: 'Subscription Required',
              description: 'Subscribe to access the analysis.',
              confirmText: 'Subscribe Now',
              onConfirm: () {
                context.pushNamed(
                  AppRoutes.subscriptionScreen,
                  arguments:
                      context
                          .read<MainLayoutCubit>()
                          .profileModel!
                          .data!
                          .offerId ??
                      -1,
                );
              },
            ),
          );
        } else {
          // context.pushNamed(AppRoutes.analysisScreen, arguments: false);

          context.pushNamed(AppRoutes.analysisDashboardScreen);
        }
      },
      categoryName: 'analysis'.tr(context),
      imagePath: Assets.analysisCategory,
    );
  }
}
