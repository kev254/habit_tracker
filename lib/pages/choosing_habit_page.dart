import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:habit_tracker/database/local_database.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/util/app_colors.dart';
import 'package:habit_tracker/util/app_contants.dart';
import 'package:provider/provider.dart';
import '../components/app_global_widgets.dart';



class ChoosingHabitScreen extends StatefulWidget {
  const ChoosingHabitScreen({super.key});

  @override
  State<ChoosingHabitScreen> createState() => _HomePageState();
}

class _HomePageState extends State<ChoosingHabitScreen> {
  DateTime now = DateTime.now();
  bool isItemSelected= false;
  List<int> selected_habits=[];

  @override
  void initState() {
    //read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 45.0, bottom: 4, left: 15,right: 15),
            child: TitleText(text: 'Choose Habit', color: Provider.of<ThemeProvider>(context).themeData == darkMode
                ? AppColors.whiteColor
                : AppColors.secondaryBlack,),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4, left: 15,right: 15),
            child: SubTitleText(text: 'Choose your daily habits, you can choose more than one.', color: Provider.of<ThemeProvider>(context).themeData == darkMode
                ? AppColors.whiteColor
                : AppColors.greyColor,),
          ),
          buildOptions(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AppButton(label: "Get Started", color: AppColors.secondaryBlack, textColor: AppColors.whiteColor, onPressed: (){
              print(selected_habits);
              Get.to(HomePage());
            }),
          )

        ],
      ),

    );
  }


  Widget buildOptions({
    bool shrinkWrap = true,
    ScrollPhysics? physics,
  }) {

    List<Map<String, dynamic>> currentHabits = AppContants().habit_types_data;
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
            if(selected_habits.contains(currentHabits[index]['id'])){
              selected_habits.remove(currentHabits[index]['id']);
            }
            else{
              selected_habits.add(currentHabits[index]['id']);
            }
            setState(() {
              selected_habits=selected_habits;
            });

          },
          child: CustomCardWithBorader(
            imageUrl1: currentHabits[index]['image'] ?? "https://cdn3.iconfinder.com/data/icons/home-activity-1/512/yoga-excercise-woman-wellness-pose-64.png",
            title: currentHabits[index]['title'] ?? "No name",
            color: selected_habits.contains(currentHabits[index]['id'])
                ? AppColors.whiteColor // Use primary color if selected
                : AppContants().colors[index % AppContants().colors.length],
            borderColor: selected_habits.contains(currentHabits[index]['id'])
                ? AppColors.primaryColor // Use primary color if selected
                : AppColors.greyColor,// Default color if not selected
          ),
        );

      },
    );
  }
}
