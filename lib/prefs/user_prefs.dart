/*
* user_prefs

* For saving user preferences/settings on device. Currently used only to determine the theme
* of the app.
*/

// * External Packages import
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _userPrefs;

loadPrefs() async {
  _userPrefs = await SharedPreferences.getInstance();
}

SharedPreferences get getPrefs => _userPrefs;
