import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../models/primry_gamification_model.dart';
import '../../util/app_contants.dart';
import '../shared_preference.dart';

class HabitProvider with ChangeNotifier {
  bool isLoading=false;
  bool dataLoaded=false;
  PrimryGamificationModel ? gamificationData;
  // Create habit
  getauthToken() async {
    var prefUser = await UserPreferences.getUser();
    return prefUser?['session']??"";
  }

  Future<bool> createHabit(String habitName, String startDate, userId, {String description = '', String frequency = 'daily', String status = 'active', String imageUrl = ''}) async {

    final token = await this.getauthToken();
    isLoading=true;

    try {
      final response = await http.post(
        Uri.parse(AppContants().base_url+"create_habit"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token ',
        },
        body: json.encode({
          'habit_name': habitName,
          'start_date': startDate,
          'user_id': userId,
          'description': description,
          'frequency': frequency,
          'status': status,
          'image': imageUrl,
        }),
      );
      final responseData = json.decode(response.body);
      isLoading = false;
      return true;
    } catch (error) {
      isLoading = false;
      return false;
    }
  }

  // Get habits for a user
  Future<bool> getHabits() async {
    final token = await this.getauthToken();

    if (token == null) {
      print('No valid token found');
      throw Exception('No valid token found');
    }

    // Request body
    var requestBody = jsonEncode({"user_id": 1});

    // Request headers
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    isLoading = true;
    notifyListeners(); // Notify UI about loading state

    try {
      // API call to get progress
      final response = await http.post(
        Uri.parse(AppContants().base_url + "get_progress"),
        headers: headers,
        body: requestBody,
      );

      final responseData = json.decode(response.body);
      print('Response Data: $responseData');

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Parse the response into the model
        gamificationData = PrimryGamificationModel.fromJson(responseData['data']);
        isLoading = false;
        dataLoaded=true;
        notifyListeners(); // Notify UI about updated data
        return dataLoaded;
      } else {
        print('Error fetching progress: ${responseData['message']}');
        isLoading = false;
        dataLoaded=false;
        notifyListeners();
        return dataLoaded;
      }
    } catch (error) {
      print('Error: $error');
      isLoading = false;
      dataLoaded = false;
      notifyListeners();
      return dataLoaded;
    }
  }


// Update habit
  Future<Map<String, dynamic>> updateHabit(String habitId, String habitName, String startDate, String userId, {String description = '', String frequency = 'daily', String status = 'active', String imageUrl = ''}) async {
    final token = await this.getauthToken();
    try {
      final response = await http.put(
        Uri.parse(AppContants().base_url+"update_habit"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token()',
        },
        body: json.encode({
          'habit_id': habitId,
          'habit_name': habitName,
          'start_date': startDate,
          'user_id': userId,
          'description': description,
          'frequency': frequency,
          'status': status,
          'image': imageUrl,
        }),
      );

      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      return {'success': false, 'message': 'Failed to update habit: $error'};
    }
  }

  // Delete habit
  Future<Map<String, dynamic>> deleteHabit(String habitId) async {
    final token = await this.getauthToken();

    try {
      final response = await http.delete(
        Uri.parse(AppContants().base_url+"delete_habit"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token()',
        },
        body: json.encode({
          'habit_id': habitId,
        }),
      );

      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      return {'success': false, 'message': 'Failed to delete habit: $error'};
    }
  }
}
