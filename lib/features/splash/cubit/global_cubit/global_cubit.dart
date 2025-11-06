import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalStates> {
  GlobalCubit() : super(const GlobalStates(locale: Locale('en')));

  // static LocalizationCubit get(context)=>BlocProvider.of(context);
  /// Set onBoarding Index
  int onBoardingIndex = 0;
  void setOnBoardingIndex(int i) {
    onBoardingIndex = i;
    emit(SetOnBoardingIndexState(onBoardingIndex));
  }

  // /// Change Language
  // Future<void> changeLanguage(String languageCode, BuildContext context) async {
  //   await CacheHelper().cacheLanguageCode(languageCode);
  //   // CacheHelper.saveUserLang(languageCode);
  //   emit(GlobalStates(locale: Locale(languageCode)));
  // }
  //
  // /// Get Language in Local Data
  // Future<void> getSavedLanguage() async {
  //   final String cachedLanguageCode =
  //    CacheHelper.getCurrentLanguage();
  //   emit(GlobalStates(locale: Locale(cachedLanguageCode)));
  // }
  //
  // /// Change Language Bottom Sheet
  // bottomSheet(BuildContext context) {
  //   return showModalBottomSheet(
  //       shape:  RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(15.r),
  //               topRight: Radius.circular(15.r))),
  //       context: context,
  //       builder: (context) => Directionality(
  //             textDirection:CacheHelper.getCurrentLanguage()==
  //                     'en'
  //                 ? TextDirection.ltr
  //                 : TextDirection.rtl,
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Icon(
  //                             Icons.language,
  //                             color: Theme.of(context).primaryColor,
  //                             size: 25.w,
  //                           ),
  //                           AppSpacer(
  //                             width: 0.015.sp,
  //                           ),
  //                           Text(
  //                             'language'.tr(context),
  //                             style: interRegular.copyWith(
  //                               color: Theme.of(context).primaryColor,
  //                               fontSize: 18.sp,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       GestureDetector(
  //                         onTap: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: Icon(
  //                           Icons.close,
  //                           color: AppColors.greyColor,
  //                           size: 25.w,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   AppSpacer(
  //                     height: 0.015.sp,
  //                   ),
  //                   Text(
  //                     'choose_language'.tr(context),
  //                     style: interRegular.copyWith(
  //                       color: AppColors.greyColor,
  //                       fontSize: 18.sp,
  //                     ),
  //                   ),
  //                   AppSpacer(
  //                     height: 0.015.sp,
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       changeLanguage('en', context).then((value) {
  //                         debugPrintWidget('this is an lang${CacheHelper.getCurrentLanguage()}');
  //                         Navigator.of(context).pop();
  //                       });
  //                     },
  //                     child: Row(
  //                       children: [
  //                         Text(
  //                           'English',
  //                           style: interRegular.copyWith(
  //                               color: AppColors.greyColor),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   AppSpacer(
  //                     height: 0.015.sp,
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       changeLanguage('ar', context).then((value) {
  //                         debugPrintWidget('this is an lang${CacheHelper.getCurrentLanguage()}');
  //                         Navigator.of(context).pop();
  //                       });
  //                     },
  //                     child: Row(
  //                       children: [
  //                         Text(
  //                           'اللغة العربية',
  //                           style: interRegular.copyWith(
  //                               color: AppColors.greyColor, fontSize: 16.sp),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ));
  // }
}
