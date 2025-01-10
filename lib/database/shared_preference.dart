import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    print("clearing user prefs");
    Get.to(LoginPage());
  }
}
