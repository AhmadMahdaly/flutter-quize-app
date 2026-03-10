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

class GiftsScreen extends StatefulWidget {
  const GiftsScreen({super.key});

  @override
  State<GiftsScreen> createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<MainLayoutCubit>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        cubit.getGifts(isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
          builder: (context, state) {
            final cubit = context.read<MainLayoutCubit>();
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
              controller: _scrollController,
              itemCount: gifts.length + (cubit.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == gifts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final invoice = gifts[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
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
                      Text('Payment: ${invoice.payments} SAR'),
                      if (invoice.offer != null)
                        Text('Offer: ${invoice.offer!.name}'),
                      if (invoice.expiredAt != null)
                        Text(
                          'Expire: ${invoice.expiredAt?.day}-${invoice.expiredAt?.month}-${invoice.expiredAt?.year}',
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
