import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:habit_tracker/database/local_database.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/util/app_colors.dart';
import 'package:habit_tracker/util/app_contants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/util/app_functions.dart';
import '../components/app_global_widgets.dart';
import '../components/drawer_pop_up.dart';
import '../components/habit_add_edit_dialog.dart';
import 'analytics_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now = DateTime.now();
  String? today_data;
  bool isItemSelected= false;
  Habit? selected_habit;

  @override
  void initState() {
    //read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
    today_data = DateFormat('EEEE, d').format(now);
  }



  void checkHabitOnOff(bool? value, Habit habit) {
    //update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id!, value);
    }
  }


//delete habit
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          //delete
          MaterialButton(
            onPressed: () {
              //save to db
              context.read<HabitDatabase>().deleteHabit(habit.id!);
              isItemSelected= false;
              //pop box
              Navigator.pop(context);
            },
            child: const Text(style: TextStyle(color: Colors.red), 'Delete'),
          ),
          //cancel
          MaterialButton(
            onPressed: () {
              //pop the box
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> setReminder(context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // Schedule the notification
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'HabitTrackerApp',
          title: 'Notification!',
          body: 'This is a reminder to complete your scheduled habit!',
          wakeUpScreen: true,
          notificationLayout: NotificationLayout.Default,
        ),


      );
    }
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
        // Center the title
        title: TitleText(text: today_data ?? ""),
        actions: [
          // Right icon with circular background
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor:
                  AppColors.greyColor, // Custom circular background
              child: IconButton(
                icon: const Icon(Icons.calendar_month,
                    color: AppColors.whiteColor),
                onPressed: () {
                  setReminder(context);
                },
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: isItemSelected ? null : FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) => CreateHabitDialog(onSave: (Habit ) {  },),
          );
        },
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Provider.of<ThemeProvider>(context).themeData == darkMode
              ? AppColors.whiteColor
              : AppColors.secondaryBlack,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          _buildHeatMap(),
          NotificationCardWidget(
            imageUrl:
                'https://cdn2.iconfinder.com/data/icons/university-tuition-and-college-1/122/Icons-07-64.png',
            title: 'Notification!',
            subtitle:
                'Now it is the time to read books,\nYou can change it in the app settings',
            icon: Icons.info,
            iconColor: Provider.of<ThemeProvider>(context).themeData == darkMode
                ? AppColors.whiteColor
                : AppColors.secondaryBlack,
            bg_color: Provider.of<ThemeProvider>(context).themeData == darkMode
                ? AppColors.secondaryBlack
                : AppColors.whiteColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15,right: 15),
            child: TitleText(text: '${today_data ?? 'No'} Habits', color: Provider.of<ThemeProvider>(context).themeData == darkMode
                ? AppColors.whiteColor
                : AppColors.secondaryBlack,),
          ),
          buildOptions(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),

        ],
      ),

      bottomNavigationBar: isItemSelected
          ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: BottomAppBar(
                    shape: const CircularNotchedRectangle(),
                    elevation: 0,
                    color: Colors.transparent,
                    child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0)
              ),
              color: AppColors.whiteColor,
            ),
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBottomBarButton(
                  imageUrl: "https://cdn1.iconfinder.com/data/icons/modern-universal/32/icon-17-64.png",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreateHabitDialog(onSave: (Habit ) { },habit: selected_habit,),
                    );
                  },
                ),
                _buildBottomBarButton(
                  imageUrl: "https://cdn4.iconfinder.com/data/icons/computer-and-web-2/500/Delete-64.png",
                  onPressed: () {
                   deleteHabitBox(selected_habit!);
                  },
                ),
                _buildBottomBarButton(
                  imageUrl: "https://cdn0.iconfinder.com/data/icons/business-and-finance-103/64/diagram-data-stats-graph-statistics-64.png",
                  onPressed: () {
                    setState(() {
                      Get.to(AnalyticsPage(habit: selected_habit,));
                      isItemSelected = false;
                    });
                  },
                ),
              ],
            ),
                    ),
                  ),
          )
          : null,
      // Hide BottomAppBar when no item is selected
    );
  }


  Widget _buildBottomBarButton({
    String? imageUrl,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Image.network(
                imageUrl!,
                width: 25,
                height: 25,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.broken_image,
                  color: AppColors.greyColor,
                  size: 25,
                ),
              )
          ],
        ),
      ),
    );
  }



  //build heatmap
  Widget _buildHeatMap() {
    //habit database
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return heatmap UI
    return FutureBuilder<DateTime?>(
        future: habitDatabase.getFirstLaunchDate(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return buildCalenderHeatMap(
              startDate: snapshot.data!,
              datasets: prepHeatMapDataset(currentHabits),
            );
          } else {
            return Container();
          }
        }));
  }

  Widget buildOptions({
    bool shrinkWrap = true,
    ScrollPhysics? physics,
  }) {
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;
    if(currentHabits.isEmpty){
      setState(() {
        isItemSelected = false;
      });
      return Center(child: SubTitleText(text: "No habits found, create one", color: Provider.of<ThemeProvider>(context).themeData == darkMode
          ? AppColors.whiteColor
          : AppColors.secondaryBlack,));
    }
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics ?? ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.0,
      ),
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isItemSelected && selected_habit == currentHabits[index]) {
                // If this habit is already selected, deselect it
                selected_habit = null;
                isItemSelected = false;
              } else {
                // Select the new habit
                selected_habit = currentHabits[index];
                isItemSelected = true;
              }
            });
          },
          child: CustomCard(
            imageUrl1: "https://cdn3.iconfinder.com/data/icons/home-activity-1/512/yoga-excercise-woman-wellness-pose-64.png",
            title: currentHabits[index].name ?? "No name",
            subtitle: currentHabits[index].description ?? "No description",
            color: selected_habit == currentHabits[index] // Check if this habit is selected
                ? AppColors.primaryColor // Use primary color if selected
                : AppContants().colors[index % AppContants().colors.length], // Default color if not selected
          ),
        );

      },
    );
  }
}
