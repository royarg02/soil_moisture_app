/*
 * app_info
 * 
 * Fetches the app properties from the system.
 */

import 'package:package_info/package_info.dart';

PackageInfo _appInfo;

loadAppInfo() async {
  _appInfo = await PackageInfo.fromPlatform();
}

PackageInfo get getAppInfo => _appInfo;
