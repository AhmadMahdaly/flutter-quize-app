import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/subscription/cubit/Subscription_cubit.dart';
import 'package:smle/features/subscription/widgets/pay_done_dialog.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key, required this.offerId});
  final int offerId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionStates>(
      // 1. تفعيل الـ Listener للاستجابة لنتائج الشراء
      listener: (context, state) {
        if (state is PurchaseSuccessState) {
          // في حالة نجاح الشراء والتحقق منه
          showDialog(
            context: context,
            builder: (context) => const PayDoneDialog(), // عرض رسالة نجاح
          );
        } else if (state is PurchaseFailedState) {
          // في حالة فشل الشراء أو التحقق
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SubscriptionCubit>();

        // 2. معالجة حالات التحميل والخطأ
        if (state is GetStoreProductsLoadingState ||
            state is GetPackagesLoadingState) {
          return Scaffold(
            appBar: CustomAppBar(title: 'subscription'.tr(context)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is GetStoreProductsFailedState) {
          return Scaffold(
            appBar: CustomAppBar(title: 'subscription'.tr(context)),
            body: Center(child: Text('Error: ${state.message}')),
          );
        }
        if (cubit.storeProducts.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(title: 'subscription'.tr(context)),
            body: Center(child: Text('no_packages_found'.tr(context))),
          );
        }

        // دمج باقات السيرفر في قائمة واحدة لتسهيل البحث
        final allBackendPackages =
            (cubit.packagesModel?.data ?? []) +
            (cubit.extraPackagesModel?.data ?? []);

        return Scaffold(
          appBar: CustomAppBar(title: 'subscription'.tr(context)),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.verticalSpace,
                Text(
                  'choose_your_plan'.tr(context),
                  style: interBold.copyWith(
                    fontSize: SizeConfig.responsiveValue(
                      phone: 14.sp,
                      tablet: 20.sp,
                    ),
                  ),
                ),
                24.verticalSpace,
                // 3. عرض المنتجات من متجر Apple وليس من السيرفر مباشرة
                ...List.generate(cubit.storeProducts.length, (index) {
                  final product =
                      cubit.storeProducts[index]; // المنتج من متجر Apple

                  // البحث عن الباقة المطابقة من السيرفر لجلب الميزات والبيانات الوصفية
                  final backendPackage = allBackendPackages.firstWhere(
                    (pkg) =>
                        pkg.appleProductId ==
                        product.id, // افترضنا اسم الحقل appleProductId
                    // orElse: () => Data(), // إرجاع كائن فارغ إذا لم يتم العثور عليه
                  );

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: GestureDetector(
                      // 4. تعديل منطق onTap لبدء عملية الشراء مباشرة
                      onTap: () {
                        if (state is! PurchaseLoadingState &&
                            state is! PurchaseVerificationLoadingState) {
                          cubit.buyPackage(product);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColors.secondaryColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 24.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // عرض اسم المنتج من متجر Apple
                                    Text(
                                      product.title,
                                      style: interBold.copyWith(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    16.verticalSpace,
                                    // عرض الميزات من السيرفر الخاص بك
                                    ...?backendPackage.features?.map(
                                      (feature) => Padding(
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        child: Text(
                                          '* ${feature.name}',
                                          style: interRegular.copyWith(
                                            fontSize: 14.sp,
                                            color: AppColors.thirdColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 5. عرض السعر من متجر Apple (بالعملة المحلية للمستخدم)
                              Text(
                                product.price,
                                style: interBold.copyWith(
                                  color: AppColors.thirdColor,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
