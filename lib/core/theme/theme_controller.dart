import 'package:flutter/material.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.dark);

  static Future<void> init() async {
    final cachedMode = CacheHelper.getData(key: CacheKeys.themeMode) as String?;
    mode.value = cachedMode == ThemeMode.light.name
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  static void toggle() {
    final nextMode = mode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    mode.value = nextMode;
    CacheHelper.saveData(key: CacheKeys.themeMode, value: nextMode.name);
  }
}
