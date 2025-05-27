import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/features/support_privacy_policy/cubit/privacy_policy_cubit.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: 'privacy_policy'.tr(context),),
      body: BlocConsumer<PrivacyPolicySupportCubit,PrivacyPolicySupportStates>(
          listener: (context,state){},
          builder: (context,state) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child:

              context.read<PrivacyPolicySupportCubit>().privacyPolicyModel == null
                  ? const Column() :
              Column(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child:   Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20.h),

                      child: HtmlWidget(
                    ' ${context.read<PrivacyPolicySupportCubit>().privacyPolicyModel!.data}',
                        key: const Key('privacy_policy'),
                        onTapUrl: (String url) {
                          return launchUrlString(url,
                              mode: LaunchMode.externalApplication);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),

    );
  }
}
