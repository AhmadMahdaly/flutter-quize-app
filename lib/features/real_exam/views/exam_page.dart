import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/views/widgets/real_exam_body.dart';

class RealExamPage extends StatelessWidget {
  const RealExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(canBack: false, title: 'real_exam'.tr(context)),
      body: BlocConsumer<RealExamCubit, RealExamState>(
        listener: (context, state) {
          if (state is FinishAnalysisExamSuccessState) {
            context.pop();
          }
        },
        builder: (context, state) {
          return state is StartRealExamSuccessState
              ? RealExamBody(examModel: state.examModel)
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
