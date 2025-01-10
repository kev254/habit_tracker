import 'dart:math';

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppContants {
  final List<Map<String, dynamic>> habit_types_data = [
    {
      'id': 1,
      'image': 'https://cdn4.iconfinder.com/data/icons/winter-activities-1/512/bike-riding-bycicle-cycling-mountain-64.png',
      'title': 'Work Out',
      'description': '07.00 for 10 km',
      'color': AppColors.cardColor1,
    },
    {
      'id': 2,
      'image': 'https://cdn4.iconfinder.com/data/icons/activity-1-1/32/94-64.png',
      'title': 'Eat Food',
      'selected': false,
      'color': AppColors.cardColor2,
    },
    {
      'id': 3,
      'image': 'https://cdn3.iconfinder.com/data/icons/fitness-2-1/48/82-64.png',
      'title': 'Music',
      'selected': false,
      'color': AppColors.cardColor3,
    },
    {
      'id': 4,
      'image': 'https://cdn2.iconfinder.com/data/icons/university-tuition-and-college-1/122/Icons-07-64.png',
      'title': 'Art & Design',
      'selected': false,
      'color': AppColors.cardColor4,
    },
    {
      'id': 5,
      'image': 'https://cdn2.iconfinder.com/data/icons/university-tuition-and-college-1/122/Icons-07-64.png',
      'title': 'Traveling',
      'selected': false,
      'color': AppColors.cardColor4,
    },
    {
      'id': 6,
      'image': 'https://cdn2.iconfinder.com/data/icons/university-tuition-and-college-1/122/Icons-07-64.png',
      'title': 'Read Books',
      'selected': false,
      'color': AppColors.cardColor4,
    },


  ];

  List<Color> colors = [
    AppColors.cardColor1,
    AppColors.cardColor2,
    AppColors.cardColor3,
    AppColors.cardColor4,
  ]..shuffle(Random());

  List<String> images = [
    "https://cdn4.iconfinder.com/data/icons/winter-activities-1/512/bike-riding-bycicle-cycling-mountain-64.png"
   "https://cdn4.iconfinder.com/data/icons/activity-1-1/32/94-64.png"
    "https://cdn2.iconfinder.com/data/icons/university-tuition-and-college-1/122/Icons-07-64.png",
    "https://cdn3.iconfinder.com/data/icons/fitness-2-1/48/82-64.png"
  ]..shuffle(Random());
  String base_url = "https://rental.okombakevin.co.ke/tacker?method=";
}
