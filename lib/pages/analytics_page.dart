import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:habit_tracker/database/local_database.dart';
import 'package:habit_tracker/database/rest_api/habit_provider.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/util/app_colors.dart';
import 'package:provider/provider.dart';
import '../components/app_global_widgets.dart';
import '../components/habit_add_edit_dialog.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/habit.dart';


class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key, required this.habit});
  final Habit? habit;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    // Load habits and progress data
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    Provider.of<HabitProvider>(context, listen: false).getHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: TitleText(
          text: "${widget.habit?.name ?? "Habit"} Stats",
          color: Provider.of<ThemeProvider>(context).themeData == darkMode
              ? AppColors.whiteColor
              : AppColors.secondaryBlack,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.greyColor,
              child: IconButton(
                icon: const Icon(Icons.calendar_month,
                    color: AppColors.whiteColor),
                onPressed: () {
                  // Future calendar functionality
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, _) {
          // Display loading indicator while fetching data
          var habitProgressData = habitProvider.gamificationData!;
          if (habitProgressData.habits.isEmpty ||
              habitProgressData.habits[0].progress.isEmpty) {
            return const Center(child: TitleText(text: 'No data available.'));
          }

          // Extract labels and data
          final labels = habitProgressData.habits[0].progress
              .map((progress) => '${progress.status}')
              .toList();


          final data = habitProgressData.habits[0].progress
              .map((progress) => progress.id.toDouble())
              .toList();
          print(data);
          print(labels);


          return ListView(
            padding: const EdgeInsets.all(10.0),
            children: [
              // Example bar chart
              BarChartWidget(
                title: "XP",
                subtitle: habitProgressData.userGamifications.xp.toString(),
                labels: labels,
                data: data,
                barBackgroundColor: Colors.grey[300]!,
                barColor: AppColors.primaryColor,
                touchedBarColor: AppColors.secondaryColor, badge_url: habitProgressData.userGamifications.badges.toString(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                child: TitleText(
                  text: 'Challenges',
                  color: AppColors.secondaryBlack,
                ),
              ),
              _buildHabitList(habitProgressData),
            ],
          );
        },
      ),
    );
  }

  // Build the list of habits with progress
  Widget _buildHabitList(var habitProgressData) {

    final habit = habitProgressData.habits
        .map((habit) => {
      'name': habit.habitName, // Extract the habit name
      'status': habit.progress
          .map((progress) => progress.status) // Extract progress status
          .toList(),
    })
        .toList();

    return ListView.builder(
      itemCount: habit.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habitData = habit[index]; // Get habit data for the current index

        // Check if habit progress contains 'Completed' (or any other status) for today
        final isCompletedToday = habitData['status']?.contains('Completed') ?? false;

        return HabitChallengesCard(
          name: habitData['name']?.toString() ?? 'Unknown Habit', // Display habit name
          status: habitData['status']?.toString() ?? 'Unknown status', // Display habit name
          isCompleted: isCompletedToday, // Display if the habit is completed today
          onChanged: (value) {
            // Handle checkbox state changes
          },
          editHabit: (context) {
            // Handle edit logic
          },
          deleteHabit: (context) {
            // Handle delete logic
          },
          setReminder: (context) {
            // Handle reminder logic
          },
          completedTasks: [], // Pass the progress status data
        );
      },
    );
  }
}

