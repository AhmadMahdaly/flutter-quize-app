import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/home/widgets/category/base_category_widget.dart';
import 'package:smle/features/revision/cubit/revision_cubit.dart';

class SubcategoriesScreen extends StatelessWidget {
  const SubcategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Revision'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: BlocBuilder<RevisionCubit, RevisionStates>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  50.verticalSpace,
                  Text(
                    'Specialty',
                    style: AppTextStyle.style16Bold.copyWith(
                      fontSize: 16.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  50.verticalSpace,
                  if (context.read<RevisionCubit>().subCategoriesModel != null)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 33.0,
                            childAspectRatio: 1.9,
                          ),
                      itemCount: context
                          .read<RevisionCubit>()
                          .subCategoriesModel!
                          .data!
                          .subcategories!
                          .length,
                      itemBuilder: (context, index) {
                        return CategoryWidget(
                          onTap: () {
                            context.pushNamed(AppRoutes.revisionScreen);
                          },
                          categoryName:
                              '${context.read<RevisionCubit>().subCategoriesModel!.data!.subcategories![index].name}',
                          imagePath: Assets.revisionCategory,
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
