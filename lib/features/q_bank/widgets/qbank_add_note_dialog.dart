import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';

class QBankAddNoteDialog extends StatefulWidget {
  const QBankAddNoteDialog({super.key, required this.cubit});
  final QBankCubit cubit;

  @override
  State<QBankAddNoteDialog> createState() => _QBankAddNoteDialogState();
}

class _QBankAddNoteDialogState extends State<QBankAddNoteDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QBankCubit, QBankStates>(
      bloc: widget.cubit,
      listener: (context, state) {
        if (state is AddNoteSuccessState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AddNoteFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Send Notes To Admin for this Question',
                  style: AppTextStyle.style16Bold,
                ),
                12.verticalSpace,
                CustomPrimaryTextfield(
                  maxLines: 7,
                  controller: controller,
                  text: 'Type your note here...',
                  style: AppTextStyle.style14W500,
                ),
                12.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: state is AddNoteLoadingState
                          ? null // تعطيل الزر أثناء التحميل
                          : () {
                              if (controller.text.isNotEmpty) {
                                widget.cubit.addQuestionNote(controller.text);
                              }
                            },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.r,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greenColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: state is AddNoteLoadingState
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Send note',
                                style: AppTextStyle.style14Bold.copyWith(
                                  color: AppColors.offwhiteColor,
                                ),
                              ),
                      ),
                    ),
                    8.horizontalSpace,
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.r,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkGreyColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTextStyle.style14Bold.copyWith(
                            color: AppColors.offwhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
