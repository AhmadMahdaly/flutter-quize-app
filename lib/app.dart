import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/config_loading.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/routing/app_router.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/theme_controller.dart';
import 'package:smle/core/theme/themes.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/notification/cubit/notification_cubit.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, themeMode, _) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<PlayListCubit>()),
          BlocProvider(
            create: (context) =>
                getIt<CheckSubscriptionCubit>()..loadAllSubscriptions(),
          ),
          BlocProvider(create: (context) => getIt<NotificationCubit>()),
          BlocProvider(create: (context) => getIt<MainLayoutCubit>()),
        ],
        child: MaterialApp(
          onGenerateRoute: AppRouter().generateRoute,
          initialRoute: AppRoutes.splashScreen,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          title: 'SMLE Gate',
          debugShowCheckedModeBanner: false,
          builder: (context, myWidget) {
            myWidget = EasyLoading.init()(context, myWidget);
            configLoading(context);
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
