import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/subscription/cubit/Subscription_cubit.dart';
import 'package:smle/features/subscription/widgets/pay_done_dialog.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionStates>(
      listener: (context, state) {
        if (state is PurchaseSuccessState) {
          // تم الشراء بنجاح، اظهر رسالة أو انتقل لشاشة أخرى
          showDialog(
            context: context,
            builder: (context) => const PayDoneDialog(),
          );
        } else if (state is PurchaseFailedState) {
          // فشلت عملية الشراء، اظهر رسالة خطأ
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<SubscriptionCubit>();

        if (cubit.storeProducts.isEmpty) {
          // جاري التحميل أو لم يتم العثور على منتجات
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(title: 'subscription'.tr(context)),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... (نصوص العنوان)

                // عرض قائمة المنتجات من متجر Apple
                ...List.generate(cubit.storeProducts.length, (index) {
                  final product = cubit.storeProducts[index];
                  // يمكنك البحث عن تفاصيل الباقة من `packagesModel` باستخدام `product.id`
                  // للعثور على الميزات وغيرها

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: GestureDetector(
                      onTap: () {
                        // بدء عملية الشراء
                        cubit.buyPackage(product);
                      },
                      child: Container(
                        // ... (تصميم الكارت الخاص بك)
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: interBold,
                                ), // اسم المنتج من Apple
                                Text(
                                  product.description,
                                ), // وصف المنتج من Apple
                                // ... عرض الميزات من الـ packagesModel
                              ],
                            ),
                            Text(
                              product.price,
                              style: interBold,
                            ), // السعر من Apple (جاهز بالعملة المحلية)
                          ],
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
