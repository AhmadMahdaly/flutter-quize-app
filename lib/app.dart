import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/routing/app_router.dart';
import 'core/cache_helper/cache_values.dart';
import 'core/constants.dart';
import 'core/helpers/app_localization.dart';
import 'core/routing/routes.dart';
import 'core/theme/themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  void configLoading(BuildContext context) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = AppColors.secondaryColor
      ..indicatorColor = Theme.of(context).primaryColor
      ..textColor = Theme.of(context).primaryColor
      ..maskColor = AppColors.forthColor
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.black
      ..userInteractions = false;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
            ),
            child: Builder(builder: (context) {
              return MaterialApp(
                onGenerateRoute: AppRouter().generateRoute,
                initialRoute:
                    CacheHelper.getData(key: CacheKeys.isFirstOpen) == true
                        ? Routes.mainLayoutScreen
                        : Routes.splashScreen,
                theme: lightTheme,
                navigatorKey: navigatorKey,
                darkTheme: lightTheme,
                themeMode: ThemeMode.light,
                title: 'SMLE',
                debugShowCheckedModeBanner: false,
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  for (var locale in supportedLocales) {
                    if (deviceLocale != null &&
                        deviceLocale.languageCode == locale.languageCode) {
                      return deviceLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                supportedLocales: const [Locale('en'), Locale('ar')],
                locale: Locale(CacheHelper.getCurrentLanguage()),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  MonthYearPickerLocalizations
                      .delegate, // ← Required for month_year_picker
                ],
                builder: (context, myWidget) {
                  myWidget = EasyLoading.init()(context, myWidget);
                  configLoading(context);
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                    systemNavigationBarColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    systemNavigationBarDividerColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    systemNavigationBarContrastEnforced: true,
                    systemStatusBarContrastEnforced: true,
                    systemNavigationBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light,
                    statusBarIconBrightness: Brightness.dark,
                  ));
                  myWidget = MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: Material(
                        child: Material(
                          child: Stack(children: [
                            myWidget,
                          ]),
                        ),
                      ));
                  return myWidget;
                },
              );
            })));
  }
}
