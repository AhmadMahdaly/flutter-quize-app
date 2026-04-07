import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smle/core/bloc_observer.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/fcm.dart';
import 'package:smle/core/functions/debug_print_extension.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 100));

  try {
    await CacheHelper.init();
  } catch (e) {
    'SharedPreferences initialization failed: $e'.dPrint();
  }

  await setupGetIt();
  await DioFactory.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Directory storageDirectory;
  try {
    storageDirectory = await getApplicationSupportDirectory();
  } catch (e) {
    debugPrintWidget(
      'Getting ApplicationSupportDirectory Failed: $e. Using temporary directory.',
    );
    storageDirectory = await getTemporaryDirectory();
  }

  try {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(storageDirectory.path),
    );
  } catch (e) {
    debugPrintWidget('HydratedStorage Build Failed: $e');
  }

  await FCMService.instance.requestPermission();

  try {
    await FCMService.instance.initialize();
  } catch (e) {
    debugPrintWidget('FCMService setup failed: $e');
  }
  Bloc.observer = MyBlocObserver();
  await setLockedOrientation();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

Future<void> setLockedOrientation() async {
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    debugPrintWidget('Failed to set orientation: $e');
  }
}
