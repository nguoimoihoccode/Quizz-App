import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedInKey = "USERLOGGEDINKEY";
  // @required thử các loại của packed khác
  static Future<void> saveUserLoggedInDetails({@required bool? isLoggedin}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(userLoggedInKey, isLoggedin ?? false);
    } catch (e) {
      print('Error saving user login status: $e');
    }
  }

  static Future<bool> getUserLoggedInDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoggedInKey) ?? false;
  }


}
