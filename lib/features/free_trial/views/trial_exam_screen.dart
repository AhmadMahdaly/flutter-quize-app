import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/features/free_trial/cubit/free_trial_cubit.dart';
import 'package:smle/features/free_trial/views/widgets/trial_exam_body.dart';

class TrialExamScreen extends StatelessWidget {
  const TrialExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrialExamCubit(getIt())..fetchTrialExam(),
      child: Scaffold(
        appBar: const CustomAppBar(canBack: false, title: 'Free Trial'),
        body: BlocBuilder<TrialExamCubit, TrialExamState>(
          builder: (context, state) {
            if (state.status == FetchStatus.loading ||
                state.status == FetchStatus.initial) {
              return const SizedBox.shrink();
            }
            if (state.status == FetchStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'An error occurred'),
              );
            }
            if (state.questions.isEmpty) {
              return const Center(child: Text('No questions found.'));
            }
            return const TrialExamBody();
          },
        ),
      ),
    );
  }
}
