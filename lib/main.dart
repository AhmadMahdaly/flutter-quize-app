import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smle/app.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/debug_print_extension.dart';
import 'package:smle/core/network/dio_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 100));

  try {
    await CacheHelper.init();
  } catch (e) {
    'SharedPreferences initialization failed: $e'.dPrint();
  }

  await setupGetIt();
  await DioFactory.init();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase Initialization Failed: $e');
  }

  Directory storageDirectory;
  try {
    storageDirectory = await getApplicationSupportDirectory();
  } catch (e) {
    debugPrint(
      'Getting ApplicationSupportDirectory Failed: $e. Using temporary directory.',
    );
    storageDirectory = await getTemporaryDirectory();
  }

  try {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(storageDirectory.path),
    );
  } catch (e) {
    debugPrint('HydratedStorage Build Failed: $e');
  }

  try {
    if (Platform.isAndroid || Platform.isIOS) {
      HttpOverrides.global = MyHttpOverrides();
    }
  } catch (e) {
    debugPrint('HttpOverrides setup failed: $e');
  }

  await setLockedOrientation();

  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> setLockedOrientation() async {
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    debugPrint('Failed to set orientation: $e');
  }
}
