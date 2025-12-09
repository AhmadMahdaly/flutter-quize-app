import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/constants.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/config_loading.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/routing/app_router.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/themes.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<PlayListCubit>()),
          BlocProvider(
            create: (context) =>
                getIt<CheckSubscriptionCubit>()..loadSubscription(),
          ),
        ],
        child: MaterialApp(
          onGenerateRoute: AppRouter().generateRoute,
          initialRoute: CacheHelper.getData(key: CacheKeys.isFirstOpen) == true
              ? AppRoutes.mainLayoutScreen
              : AppRoutes.splashScreen,
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
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            MonthYearPickerLocalizations.delegate,
          ],
          builder: (context, myWidget) {
            myWidget = EasyLoading.init()(context, myWidget);
            configLoading(context);
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                systemNavigationBarColor: Theme.of(
                  context,
                ).scaffoldBackgroundColor,
                systemNavigationBarDividerColor: Theme.of(
                  context,
                ).scaffoldBackgroundColor,
                systemNavigationBarContrastEnforced: true,
                systemStatusBarContrastEnforced: true,
                systemNavigationBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark,
              ),
            );
            myWidget = MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Material(
                child: Material(child: Stack(children: [myWidget])),
              ),
            );
            return myWidget;
          },
        ),
      ),
    );
  }
}
