import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class HomeChatBar extends StatelessWidget {
  const HomeChatBar({
    super.key,
    // required this.onTap,
    required this.isActive,
    // required this.onMicTap,
    // required this.onGalleryTap,
  });
  // final VoidCallback onTap;
  final bool isActive;
  // final VoidCallback onMicTap;
  // final VoidCallback onGalleryTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      height: 55.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDarkMode ? 77 : 15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(35.r),
          onTap: () {
            if (!isActive) {
              showCustomPrimaryDialog(
                context,
                widget: CustomPrimaryDialog(
                  title: 'Subscription Required',
                  description: 'Subscribe to access SMLE Gate AI.',
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

            context.pushNamed(AppRoutes.chatScreen);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: theme.colorScheme.primary.withAlpha(40),

                      child: Image.asset('assets/images/png/logo_circle.png'),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.greenColor
                              : AppColors.errorColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                12.horizontalSpace,

                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Ask SMLE Gate AI...',
                        style: AppTextStyle.style14W500.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(180),
                        ),
                      ),
                      2.horizontalSpace,

                      const BlinkingCursor(),
                    ],
                  ),
                ),
                Icon(
                  CupertinoIcons.wand_stars_inverse,
                  color: theme.colorScheme.onSurface.withAlpha(180),
                ),
                8.horizontalSpace,
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Container(
                //       width: 1.5,
                //       height: 24,
                //       color: Colors.grey.shade200,
                //     ),
                //     IconButton(
                //       icon: Icon(
                //         Icons.mic_none_rounded,
                //         color: Colors.grey.shade600,
                //       ),
                //       onPressed: widget.onMicTap,
                //       splashRadius: 20,
                //     ),
                //     IconButton(
                //       icon: Icon(
                //         Icons.image_outlined,
                //         color: Colors.grey.shade600,
                //       ),
                //       onPressed: widget.onGalleryTap,
                //       splashRadius: 20,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor> {
  bool visible = true;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() => visible = !visible);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Container(width: 2, height: 18.r, color: AppColors.primaryColor),
    );
  }
}
