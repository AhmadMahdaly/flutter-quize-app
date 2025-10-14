import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smle/app.dart';
// import 'package:smle/core/bloc_observer.dart'; // Keep if you use it
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/fcm.dart';
import 'package:smle/core/network/dio_factory.dart';

void main() async {
  // 1. Ensure bindings are initialized FIRST. This is critical.
  WidgetsFlutterBinding.ensureInitialized();
  // 4. Initialize other services
  await Future.delayed(const Duration(milliseconds: 100));

  try {
    await CacheHelper.init();
  } catch (e) {
    print('SharedPreferences initialization failed: $e');
  }

  await setupGetIt();
  await DioFactory.init();
  // 2. Initialize Firebase
  try {
    await Firebase.initializeApp();
    await PushNotificationService().initialize();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  } catch (e) {
    debugPrint('Firebase Initialization Failed: $e');
  }

  // 3. Setup Hydrated Bloc Storage with a FALLBACK
  Directory storageDirectory;
  try {
    // Try to get the recommended directory
    storageDirectory = await getApplicationSupportDirectory();
  } catch (e) {
    // If it fails for any reason, fall back to a temporary directory
    debugPrint(
      'Getting ApplicationSupportDirectory Failed: $e. Using temporary directory.',
    );
    storageDirectory = await getTemporaryDirectory();
  }

  try {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: storageDirectory,
    );
  } catch (e) {
    debugPrint('HydratedStorage Build Failed: $e');
  }

  // 5. Setup HttpOverrides
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      HttpOverrides.global = MyHttpOverrides();
    }
  } catch (e) {
    debugPrint('HttpOverrides setup failed: $e');
  }

  // 6. Set orientation and run the App
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
    // Using debugPrint is better for development
    debugPrint('Failed to set orientation: $e');
  }
}
