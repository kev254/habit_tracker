import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:habit_tracker/database/sync_manager.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:workmanager/workmanager.dart';

class HabitDatabase extends ChangeNotifier {
  static late Database _database;
  final List<Habit> syncyHabits = [];


  // Initialize the SQLite database
  static Future<void> initialize() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'habit_tracker.db');

    // Open the database and create tables if they don't exist
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the habits table with all fields from the Habit model
        await db.execute('''
          CREATE TABLE habits(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            frequency TEXT,
            startDate TEXT,
            createdAt TEXT,
            updatedAt TEXT,
            status TEXT,
            imageUrl TEXT,
            completedDays TEXT
          );
        ''');

        // Create the app_settings table for first launch tracking
        await db.execute('''
          CREATE TABLE app_settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstLaunchDate TEXT
          );
        ''');
      },
    );
  }

  // Get the SQLite database instance
  static Database get database => _database;

  // Save the first launch date of the app (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await _database.query('app_settings');

    if (existingSettings.isEmpty) {
      final settings = {'firstLaunchDate': DateTime.now().toIso8601String()};
      await _database.insert('app_settings', settings);
    }
  }

  // Get the first launch date of the app
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await _database.query('app_settings');
    if (settings.isNotEmpty) {
      return DateTime.parse(settings.first['firstLaunchDate'] as String);
    }
    return null;
  }

  // List of habits
  final List<Habit> currentHabits = [];

  // Create a new habit
  Future<void> addHabit(Habit newHabit) async {
    await _database.insert('habits', newHabit.toMap());
    syncyHabits.add(newHabit);
    readHabits();
    if(syncyHabits.isNotEmpty){
      HabitSyncManager().syncHabitPeriodically();
    }

  }


  // Read all habits from the database
  Future<void> readHabits() async {
    final List<Map<String, dynamic>> maps = await _database.query('habits',orderBy: 'id DESC',);
    currentHabits.clear();
    currentHabits.addAll(maps.map((map) => Habit.fromMap(map)).toList());

    notifyListeners();
  }



  // Update habit completion status (marking a habit as completed)
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await _getHabitById(id);

    if (habit != null) {
      await _database.transaction((txn) async {
        final today = DateTime.now();

        if (isCompleted && !habit.completedDays.contains(today)) {
          habit.completedDays.add(today);
        } else {
          habit.completedDays.remove(today); // Remove the DateTime object
        }

        await txn.update(
          'habits',
          habit.toMap(), // Habit object converted to Map for database
          where: 'id = ?',
          whereArgs: [id],
        );
      });

      // Re-read from DB
      readHabits();
    }
  }

  // Update habit details
  Future<void> updateHabit(Habit updatedHabit) async {
    final habit = await _getHabitById(updatedHabit.id!);

    if (habit != null) {
      await _database.update(
        'habits',
        updatedHabit.toMap(), // Use the updated habit's map
        where: 'id = ?',
        whereArgs: [updatedHabit.id],
      );

      // Re-read from DB to refresh the local data
      readHabits();
    }
  }


  // Delete habit
  Future<void> deleteHabit(int id) async {
    await _database.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Re-read from DB
    readHabits();
  }

  // Helper method to get a habit by id
  Future<Habit?> _getHabitById(int id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );

    return maps.isNotEmpty ? Habit.fromMap(maps.first) : null;
  }
}
