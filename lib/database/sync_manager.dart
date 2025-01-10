import 'dart:convert';
import 'package:habit_tracker/database/local_database.dart';
import 'package:habit_tracker/database/rest_api/habit_provider.dart';
import 'package:workmanager/workmanager.dart';
import '../models/habit.dart';

class HabitSyncManager {
  // List of habits to be synced
  static List<Habit> syncyHabits = HabitDatabase().syncyHabits;

  // Sync habit periodically
  Future<bool> syncHabitPeriodically() async {
    print("syncing habits now");
    // Register periodic task for each habit in syncyHabits list
    for (var habit in syncyHabits) {
      await Workmanager().registerPeriodicTask(
        "taskId: sync_habit_${habit.id}",
        "simpleTask",
        frequency: Duration(seconds: 0), // Sync every 4 seconds (adjust as needed)
        inputData: {
          'habit': jsonEncode(habit.toMap()), // Pass habit data as JSON
        },
      );
    }

    // Call the API to sync the habits
    bool success = await _syncHabitsToServer(syncyHabits);

    // Clear the list after syncing
    if (success) {
      syncyHabits.clear();
      HabitDatabase().syncyHabits.clear();
    }

    // Return success or failure
    return success;
  }

  // Sync habits with the server
  Future<bool> _syncHabitsToServer(List<Habit> habits) async {
    for(var habit in habits){
      HabitProvider().createHabit(habit.name, habit.createdAt.toString(), "1");
    }
    return true;
  }
}
