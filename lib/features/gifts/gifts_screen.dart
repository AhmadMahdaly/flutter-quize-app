import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/no_data_widget.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class GiftsScreen extends StatelessWidget {
  const GiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gifts'),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(320.r),
        ),
        backgroundColor: AppColors.primaryColor,
        label: Text('Send a gift', style: AppTextStyle.style12W800),
        icon: const Icon(Icons.card_giftcard, color: Colors.white),
        onPressed: () {
          // الانتقال لصفحة إرسال الهدية
          context.pushNamed(AppRoutes.sendGiftScreen);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
          builder: (context, state) {
            final cubit = context.watch<MainLayoutCubit>();
            final gifts = cubit.gifts;
            if (gifts.isEmpty && state is GetGiftsSuccessState) {
              return const NoDataWidget(
                noDataImage: 'assets/images/png/present.png',
                noDataText: 'No Gifts yet!',
              );
            }
            if (gifts.isEmpty && state is GetGiftsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: gifts.length + 1,
              itemBuilder: (context, index) {
                if (index == gifts.length) {
                  if (cubit.currentPage <= cubit.lastPage) {
                    cubit.getGifts(isLoadMore: true);
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }

                final invoice = gifts[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.darkGreyColor.withAlpha(150),
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send by: ${invoice.createdByName}',
                        style: AppTextStyle.style16Bold.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        invoice.invoiceNumber,
                        style: AppTextStyle.style16Bold,
                      ),
                      10.verticalSpace,
                      Text('Status: ${invoice.status}'),
                      Text('Payment: ${invoice.payments}'),
                      if (invoice.offer != null)
                        Text('Offer: ${invoice.offer!.name}'),
                      if (invoice.expiredAt != null)
                        Text(
                          'Expire: ${invoice.expiredAt?.year}-${invoice.expiredAt?.month}-${invoice.expiredAt?.day}',
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
