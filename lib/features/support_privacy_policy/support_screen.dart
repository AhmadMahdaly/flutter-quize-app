import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/features/support_privacy_policy/cubit/privacy_policy_cubit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Support'),
      body: BlocConsumer<PrivacyPolicySupportCubit, PrivacyPolicySupportStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            child:
                context.read<PrivacyPolicySupportCubit>().supportModel == null
                ? const Column()
                : Column(
                    children: [
                      HtmlWidget(
                        '${context.read<PrivacyPolicySupportCubit>().supportModel!.data}',
                        key: const Key('support'),
                        onTapUrl: (String url) {
                          return launchUrlString(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
