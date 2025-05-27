import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';
import 'package:smle/features/q_bank/widgets/drop_down_widget.dart';
import 'package:smle/features/q_bank/widgets/question_button_widget.dart';
import 'package:smle/features/q_bank/widgets/year_picker_widget.dart';
import '../../core/routing/routes.dart';
import '../../core/shared_widgets/custom_app_bar.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import 'data/model/startQuizModel.dart';

class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'create_quiz'.tr(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: BlocBuilder<QBankcubit, QBankStates>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'month'.tr(context),
                      style: interMedium.copyWith(fontSize: 16.sp),
                    ),
                    10.verticalSpace,
                    const YearPickerWidget(),
                    20.verticalSpace,
                    Text(
                      'specialty'.tr(context),
                      style: interMedium.copyWith(fontSize: 16.sp),
                    ),
                    10.verticalSpace,
                    if (context.read<QBankcubit>().categoriesModel != null)
                      DropDownWidget(
                        selectedValue:
                            '${context.read<QBankcubit>().selectedCategory}',
                        selectValueList: context
                            .read<QBankcubit>()
                            .categoriesModel!
                            .data!
                            .map((e) => e.name!)
                            .toList(),
                        onChangeFunMulti: (fc){},
                        onChangeFun: (value) {
                          context.read<QBankcubit>().selectCategory(value);
                          context.read<QBankcubit>().getSubCategories(
                              '${context.read<QBankcubit>().categoriesModel!.data![context.read<QBankcubit>().categoriesModel!.data!.indexWhere(
                                    (element) => element.name == value,
                                  )].id}');
                        },
                      ),
                    20.verticalSpace,
                    Text(
                      'sub_specialty'.tr(context),
                      style: interMedium.copyWith(fontSize: 16.sp),
                    ),
                    10.verticalSpace,
                    if (context.read<QBankcubit>().subCategoriesModel != null)
                      context
                              .read<QBankcubit>()
                              .subCategoriesModel!
                              .data!
                              .subcategories!
                              .isNotEmpty
                          ? DropDownWidget(
                              selectValueList: context
                                  .read<QBankcubit>()
                                  .subCategoriesModel!
                                  .data!
                                  .subcategories!
                                  .map((e) => e.name!)
                                  .toList(),
                              selectedValueList: context
                                          .read<QBankcubit>()
                                          .selectedSubCategory ,
                              onChangeFunMulti: (value) {
                                print(value);
                                List<int> ids=[];
                                for(int i =0; i<value.length;i++){
                                print('${context.read<QBankcubit>().subCategoriesModel!.data!.subcategories!.indexWhere((element) =>
                                    value[i]==element.name,)}');
                                if(i<value.length){
                                  ids.add(context.read<QBankcubit>().subCategoriesModel!.data!.subcategories![
                                  context.read<QBankcubit>().subCategoriesModel!.data!.subcategories!.indexWhere((element) =>
                                  value[i]==element.name,)].id!);
                                }
                                // print(ids);
                                }
                                context.read<QBankcubit>().selectSubCategory(ids,value);
                              },
                            )
                          : Center(
                              child: Text(
                                'Not_found_sub_specialty'.tr(context),
                                style: interRegular.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.darkGreyColor),
                              ),
                            ),
                    20.verticalSpace,
                    Text(
                      'question_count'.tr(context),
                      style: interMedium.copyWith(fontSize: 16.sp),
                    ),
                    10.verticalSpace,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Center(
                        child: Text(
                          '20/800',
                          style: interRegular.copyWith(
                              fontSize: 14.sp, color: AppColors.darkGreyColor),
                        ),
                      ),
                    ),
                    50.verticalSpace,
                    Center(
                        child: GestureDetector(
                            onTap: () {
                              context.pushReplacementNamed(Routes.qBankScreen,arguments: StartQuizModel(context: context,
                                  offset: context.read<QBankcubit>().offset,
                                pickedDate: context.read<QBankcubit>().pickedDate,
                                  selectedSubCategoryId: context.read<QBankcubit>().selectedSubCategoryId
                              ));
                            },
                            child: QuestionButtonWidget(
                              text: 'start_quiz'.tr(context),
                            )))
                  ],
                );
              },
            )),
      ),
    );
  }
}
