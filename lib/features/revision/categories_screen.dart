import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/features/revision/cubit/revision_cubit.dart';
import 'package:smle/core/shared_widgets/category_widget.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/text_styles.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'revision'.tr(context),
      ),
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
                'specialty'.tr(context),
                style: interBold.copyWith(
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
              50.verticalSpace,
              if(context.read<RevisionCubit>().categoriesModel!=null)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 33.0,
                  childAspectRatio: 1.9,
                ),
                itemCount: context.read<RevisionCubit>().categoriesModel!.data!.length,
                itemBuilder: (context, index) {
                  return  CategoryWidget(
                    onTap: (){
                      context.pushNamed(Routes.revisionScreen,arguments: '${context.read<RevisionCubit>().categoriesModel!.data![index].id}');
                    },
                    categoryName: '${context.read<RevisionCubit>().categoriesModel!.data![index].name}',
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
