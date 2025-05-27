import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'cubit/privacy_policy_cubit.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: 'support'.tr(context),),
      body: BlocConsumer<PrivacyPolicySupportCubit,PrivacyPolicySupportStates>(
          listener: (context,state){},
          builder: (context,state) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child:
              context.read<PrivacyPolicySupportCubit>().supportModel == null
                  ? const Column() :
              Column(
                children: [
                  SingleChildScrollView(
                    physics:const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 15.sp),
                    child:   Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20.h),
                      child: HtmlWidget(
                          '${context.read<PrivacyPolicySupportCubit>().supportModel!.data}',
                        key: const Key('support'),
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
