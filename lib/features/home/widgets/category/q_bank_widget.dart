import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/features/home/widgets/category/base_category_widget.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class QBankHomeWidget extends StatelessWidget {
  const QBankHomeWidget({
    super.key,
    required this.isSubscribed,
    required this.hasQBank,
  });

  final bool isSubscribed;
  final bool hasQBank;

  @override
  Widget build(BuildContext context) {
    return CategoryWidget(
      onTap: () {
        if (!isSubscribed || !hasQBank) {
          showCustomPrimaryDialog(
            context,
            widget: CustomPrimaryDialog(
              title: 'Subscription Required',
              description:
                  'You cannot access the Question bank. Renew your subscription to enjoy the benefits.',
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
          return;
        }

        context.pushNamed(AppRoutes.createQuizScreen);
      },
      categoryName: 'Question Bank',
      imagePath: Assets.questionBank,
    );
  }
}
