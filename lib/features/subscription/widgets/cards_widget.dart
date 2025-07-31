import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/subscription/data/model/cards_model.dart';

class CardsListWidget extends StatelessWidget {
  final List<CardItem> cards;

  const CardsListWidget({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const Center(child: Text("No cards available."));
    }

    return SizedBox(
      height: 220.h, // Enough height for the horizontal cards
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemBuilder: (context, index) {
          final card = cards[index];

          return Container(

            width: 280.w,
            margin: EdgeInsets.only(right: 12.w),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Prevent overflow
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.credit_card, size: 40.r, color: AppColors.primaryColor),
                 10.verticalSpace,
                    Text(
                      'Card ID: ${card.cardId ?? 'Unknown'}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  10.verticalSpace,
                    Text('Expiry Date: ${card.expDate ?? '-'}', style: TextStyle(fontSize: 14.sp)),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

