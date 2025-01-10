import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle titleTextStyle({Color color = Colors.black}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle subTitleTextStyle({Color color = Colors.black}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle buttonTextStyle({Color color = Colors.white}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle descriptionTextStyle({Color color = Colors.black}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }

}
