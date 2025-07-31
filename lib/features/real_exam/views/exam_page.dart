import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/views/widgets/break_time_dailog.dart';
import 'package:smle/features/real_exam/views/widgets/real_exam_body.dart';

class RealExamPage extends StatelessWidget {
  const RealExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    getIt<RealExamCubit>().startOrResumeExam();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(canBack: false, title: 'real_exam'.tr(context)),
      body: BlocConsumer<RealExamCubit, RealExamState>(
        bloc: getIt<RealExamCubit>(),
        listener: (context, state) {
          if (state.status == ExamStatus.finished && state.examResult != null) {
            context.pushReplacementNamed(
              Routes.examResultsPage,
              arguments: state.examResult!,
            );
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case ExamStatus.loading:
            case ExamStatus.initial:
              return const SizedBox.shrink();
            case ExamStatus.success:
              return RealExamBody(
                examModel: state.examModel!,
                bookmarkedStatuses: state.bookmarkedStatuses,
                noteStatuses: state.noteStatuses,
              );
            case ExamStatus.onBreak:
              return Center(
                child: BreakTimeDialog(breakEndTime: state.breakEndTime!),
              );
            case ExamStatus.error:
              return Center(
                child: Text(state.errorMessage ?? 'An error occurred'),
              );
            case ExamStatus.finished:
              return const Center(child: Text('Exam Finished!'));
          }
        },
      ),
    );
  }
}
