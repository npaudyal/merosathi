import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
   
  static String sharedprefsUserNameKey = "userNameKey";
  static String userEmailKey = "userEmailKey";

  static Future<bool> saveUserNameSharedPref(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(sharedprefsUserNameKey, userName);

  }
  static Future<bool> saveUserEmailSharedPref(String userEmail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(userEmailKey, userEmail);

  }

  static Future<String> getUserNameSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getString(sharedprefsUserNameKey);

  }

  static Future<String> getUserEmailSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getString(userEmailKey);

  }






}