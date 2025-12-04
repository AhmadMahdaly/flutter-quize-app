import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';

class AddNoteDialogWidget extends StatefulWidget {
  const AddNoteDialogWidget({super.key, required this.cubit});
  final RealExamCubit cubit;
  @override
  State<AddNoteDialogWidget> createState() => _AddNoteDialogWidgetState();
}

class _AddNoteDialogWidgetState extends State<AddNoteDialogWidget> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        6.verticalSpace,
        Text(
          textAlign: TextAlign.center,
          'Add Note to Question',
          style: AppTextStyle.style16Bold.copyWith(fontSize: 20.sp),
        ),
        6.verticalSpace,
        CustomPrimaryTextfield(
          maxLines: 7,
          textAlign: TextAlign.start,
          controller: controller,
        ),
        6.verticalSpace,
        Row(
          spacing: 12.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                context.pop();
                widget.cubit.addQuestionNote(controller.text);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.greenColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Save note',
                  style: AppTextStyle.style16Bold.copyWith(
                    color: AppColors.offwhiteColor,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.darkGreyColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyle.style16Bold.copyWith(
                    color: AppColors.offwhiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
