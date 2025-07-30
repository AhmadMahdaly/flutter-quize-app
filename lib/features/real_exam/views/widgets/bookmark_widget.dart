import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';

class MakeFlagWidget extends StatelessWidget {
  const MakeFlagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<RealExamCubit>().makeQuestionFlag();
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
        child: const Icon(Icons.flag_outlined, color: AppColors.thirdColor),
      ),
    );
  }
}
