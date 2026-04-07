// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smle/app.dart';
import 'package:smle/core/init/initialization_app.dart';

// const bool isResponsiveTest = false;
void main() async {
  await initApp();
  runApp(
    // DevicePreview(
    //   enabled: (!kReleaseMode && isResponsiveTest) ? true : false,
    //   builder: (context) =>
    const MyApp(),
    // ),
  );
}
