import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:habit_tracker/database/local_database.dart';
import 'package:habit_tracker/database/rest_api/auth_provider.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/choosing_habit_page.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'database/rest_api/habit_provider.dart';
import 'database/sync_manager.dart';
import 'models/habit.dart';
import 'pages/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init the local database
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  HabitSyncManager syncManager = HabitSyncManager();
  syncManager.syncHabitPeriodically();

  runApp(MultiProvider(
    providers: [
      //habit provider
      ChangeNotifierProvider(create: (context) => HabitDatabase()),
      //theme provider
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      //Rest habit provider
      ChangeNotifierProvider(create: (context) => HabitProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
    ],
    child: const MyApp(),
  ));
}
void callbackDispatcher() {
  // This is where the WorkManager task will run
  Workmanager().executeTask((task, inputData) async {
    // Get the habit data from inputData
    String habitJson = inputData?['habit'] ?? '';

    // You can decode the habit here if needed, or perform any action
    print('Executing sync for habit: $habitJson');

    // Return true to indicate success, or false to indicate failure
    return Future.value(true);
  });
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      title: "HabitTracker",
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
