import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:habit_tracker/util/app_colors.dart';
import 'package:habit_tracker/util/app_contants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../pages/choosing_habit_page.dart';
import '../shared_preference.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading=false;
  String _authToken = '';

  String get authToken => _authToken;
  String get getBaseUrl => AppContants().base_url;

  // Register user
  register(BuildContext context, String username, String email, String password, String? google_id) async {
    isLoading = true;

    try {
      final response = await http.post(
        Uri.parse(getBaseUrl+"register"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'google_id': google_id ?? null
        }),
      );

      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode == 200 && responseData['success']) {
        _authToken = responseData['token'];
        isLoading = false;
        notifyListeners();
        AnimatedSnackBar(
          builder: ((context) {
            return  MaterialAnimatedSnackBar(
              titleText: 'REGISTRATION SUCCESS ',
              messageText: responseData['message'],
              type: AnimatedSnackBarType.success,
              foregroundColor: AppColors.secondaryBlack,
              titleTextStyle: TextStyle(
                color: AppColors.whiteColor,
              ),

            );
          }),
        ).show(context);
        //invoking login method
        login(context, email, password, google_id);

      } else {
        isLoading = false;
        AnimatedSnackBar(
          builder: ((context) {
            return  MaterialAnimatedSnackBar(
              titleText: 'RIGSTRATION ERROR! ',
              messageText: responseData['message'],
              type: AnimatedSnackBarType.error,
              foregroundColor: AppColors.secondaryBlack,
              titleTextStyle: TextStyle(
                color: AppColors.whiteColor,
              ),

            );
          }),
        ).show(context);

      }
    } catch (error) {
      isLoading = false;
      AnimatedSnackBar(
        builder: ((context) {
          return  MaterialAnimatedSnackBar(
            titleText: 'RIGSTRATION ERROR! ',
            messageText: '$error',
            type: AnimatedSnackBarType.error,
            foregroundColor: AppColors.secondaryBlack,
            titleTextStyle: TextStyle(
              color: AppColors.whiteColor,
            ),

          );
        }),
      ).show(context);
    }
  }

  // Login user
  login(BuildContext context, String email, String? password, String? google_id) async {
    isLoading = true;

    try {
      final response = await http.post(
        Uri.parse(getBaseUrl+"login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'google_id': google_id
        }),
      );

      final responseData = json.decode(response.body);
      print(responseData);


      if (response.statusCode == 200 && responseData['success']) {
        _authToken = responseData['user']['session'];
        notifyListeners();
        isLoading = false;
        AnimatedSnackBar(
          builder: ((context) {
            return  MaterialAnimatedSnackBar(
              titleText: 'LOGIN SUCCESS ',
              messageText: responseData['message'],
              type: AnimatedSnackBarType.success,
              foregroundColor: AppColors.secondaryBlack,
              titleTextStyle: TextStyle(
                color: AppColors.whiteColor,
              ),

            );
          }),
        ).show(context);


        UserPreferences.saveUser(responseData['user']);

        Get.to(ChoosingHabitScreen());

      } else {
        isLoading = false;
        AnimatedSnackBar(
          builder: ((context) {
            return  MaterialAnimatedSnackBar(
              titleText: 'LOGIN FAILED ',
              messageText: responseData['message'],
              type: AnimatedSnackBarType.error,
              foregroundColor: AppColors.secondaryBlack,
              titleTextStyle: TextStyle(
                color: AppColors.whiteColor,
              ),
            );
          }),
        ).show(context);

      }
    } catch (error) {
      isLoading = false;

      AnimatedSnackBar(
        builder: ((context) {
          return  MaterialAnimatedSnackBar(
            titleText: 'LOGIN FAILED',
            messageText: '$error',
            type: AnimatedSnackBarType.error,
            foregroundColor: AppColors.secondaryBlack,
            titleTextStyle: TextStyle(
              color: AppColors.whiteColor,
            ),
          );
        }),
      ).show(context);
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated {
    return _authToken.isNotEmpty;
  }
}
