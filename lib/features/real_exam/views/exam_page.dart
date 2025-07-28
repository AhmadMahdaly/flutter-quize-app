import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/views/widgets/header_exam_details_card.dart';
import 'package:smle/features/real_exam/views/widgets/timeline_question.dart';

class RealExamPage extends StatelessWidget {
  const RealExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(

          /// Appbar
          appBar: CustomAppBar(
            title: 'real_exam'.tr(context),
          ),
          body: BlocBuilder<RealExamCubit, RealExamState>(
            builder: (context, state) {
              final currentIndex = context.read<RealExamCubit>().currentIndex;
              return Column(
                children: [
                  ExamDetailsCard(
                    currentIndex: currentIndex,
                  ),
                  TimelineQuestionPage(
                    currentIndex: currentIndex,
                  ),
                ],
              );
            },
          )),
    );
  }
}
