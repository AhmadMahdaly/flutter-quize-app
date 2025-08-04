import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/views/widgets/add_note_dialog.dart';

class MakeNoteWidget extends StatelessWidget {
  const MakeNoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final cubit = context.read<RealExamCubit>();
        showCustomPrimaryDialog(
          context,
          widget: AddNoteDialogWidget(cubit: cubit),
        );
      },
      icon: Container(
        width: 30.w,
        height: 30.h,
        decoration: ShapeDecoration(
          color: AppColors.successColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: const Icon(
          Icons.chat_bubble_outline_rounded,
          color: AppColors.thirdColor,
        ),
      ),
    );
  }
}
