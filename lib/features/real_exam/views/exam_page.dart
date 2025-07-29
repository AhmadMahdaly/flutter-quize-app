import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/views/widgets/timeline_question.dart';

class RealExamPage extends StatelessWidget {
  const RealExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        // canBack: false,
        title: 'real_exam'.tr(context),
      ),
      body: BlocBuilder<RealExamCubit, RealExamState>(
        builder: (context, state) {
          // if (state is StartRealExamLoadingState ||
          //     state is GetQuestionLoadingState) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          // if (state is StartRealExamFailedState) {
          //   return Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text('Error: ${state.message}'),
          //         const SizedBox(height: 20),
          //         ElevatedButton(
          //           onPressed: () =>
          //               context.read<RealExamCubit>().startRealExam(),
          //           child: const Text('Try Again'),
          //         ),
          //       ],
          //     ),
          //   );
          // }

          return state is StartRealExamSuccessState
              ? TimelineQuestionPage(examModel: state.examModel)
              : const SizedBox.shrink();

          // return const Center(child: Text('Initializing Exam...'));
        },
      ),
    );
  }
}
