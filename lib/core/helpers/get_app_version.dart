import 'package:package_info_plus/package_info_plus.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';

Future<String> getBuildNumber() async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  debugPrintWidget('Version: ${info.version}');
  debugPrintWidget('Build: ${info.buildNumber}');
  return info.buildNumber;
}

Future<String> getAppVersion() async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  debugPrintWidget('Version: ${info.version}');
  debugPrintWidget('Build: ${info.buildNumber}');
  return info.version;
}
