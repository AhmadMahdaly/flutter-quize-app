import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/exams_history/widgets/exams_history_body.dart';

class ExamsHistoryScreen extends StatelessWidget {
  const ExamsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ExamsHistoryCubit>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Exams history'),
      body: ExamHistoryBody(cubit: cubit),
    );
  }
}
