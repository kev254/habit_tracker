import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/util/app_colors.dart';
import 'package:habit_tracker/util/app_text_styles.dart';
import 'package:habit_tracker/util/app_functions.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../theme/dark_mode.dart';
import '../theme/theme_provider.dart';

// Home Calender card start
class HomeCalenderCardWidget extends StatefulWidget {
  bool isSelected;
  final DateTime date;
  HomeCalenderCardWidget(
      {super.key, required this.isSelected, required this.date});

  @override
  State<HomeCalenderCardWidget> createState() => _HomeCalenderCardWidgetState();
}

class _HomeCalenderCardWidgetState extends State<HomeCalenderCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.date);
      },
      child: Card(
        elevation: widget.isSelected
            ? 8.0
            : 4.0, // Higher elevation for the selected day
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: 60,
          height: 80,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primaryColor
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the day of the week (e.g., Wed)
              Text(
                getDayOfWeek(widget.date),
                style: widget.isSelected
                    ? AppTextStyles.descriptionTextStyle(
                        color: AppColors.whiteColor)
                    : AppTextStyles.descriptionTextStyle(),
              ),
              // Display the date (e.g., 29) in bold
              Text(
                '${widget.date.day}',
                style: widget.isSelected
                    ? AppTextStyles.titleTextStyle(color: AppColors.whiteColor)
                    : AppTextStyles.titleTextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Home calender card end

// habit card start
class HabitChallengesCard extends StatelessWidget {
  final Habit? habit;
  final String name;
  final String status;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;
  final void Function(BuildContext)? setReminder;
  final List<Habit> completedTasks;

  const HabitChallengesCard({
    super.key,
    this.habit,
    required this.name,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
    required this.setReminder,
    required this.completedTasks, required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // Add your Slidable actions here
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              // Toggle completion status
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image on the Left
                Image.network(
                  'https://cdn3.iconfinder.com/data/icons/fitness-2-1/48/79-64.png',
                  // Replace with your left image URL or asset path
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                // Space between the left image and the title

                // Title and Subtitle at the Center
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TitleText(text: name, color: isCompleted
                          ? Colors.white
                          : Theme.of(context).colorScheme.inversePrimary),
                      const SizedBox(height: 4),
                      SubTitleText(
                          text: status,
                          color: AppColors.greenColor)

                    ],
                  ),
                ),

                // Image on the Right with Additional Content Below
                Column(
                  children: [
                    Image.network(
                      'https://cdn4.iconfinder.com/data/icons/nature-life-in-color/128/fire-simple-red-64.png',
                      // Replace with your right image URL or asset path
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '420 calls',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted
                            ? Colors.white
                            : Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoHabit extends StatelessWidget {
  final String habitName;
  final List<Habit> completedTasks;

  const InfoHabit({
    Key? key,
    required this.habitName,
    required this.completedTasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredTasks =
        completedTasks.where((habit) => habit.name == habitName).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Logs"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.builder(
          itemCount: filteredTasks.length,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: ListTile(
                title: filteredTasks.isEmpty
                    ? const Text(
                        "No Record of finishing this habit",
                        style: TextStyle(fontSize: 18),
                      )
                    : Text(
                        'Habit: ',
                        style: const TextStyle(fontSize: 18),
                      ),
                contentPadding: const EdgeInsets.all(12),
              ),
            );
          },
        ),
      ),
    );
  }
}

// habit card end

//titletext widget
class TitleText extends StatelessWidget {
  final String text;
  final Color color;

  const TitleText({Key? key, required this.text, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.titleTextStyle(color: color),
    );
  }
}

// SubTitleText Widget
class SubTitleText extends StatelessWidget {
  final String text;
  final Color color;

  const SubTitleText({Key? key, required this.text, this.color = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.subTitleTextStyle(color: color),
    );
  }
}

// DescriptionText Widget
class DescriptionText extends StatelessWidget {
  final String text;
  final Color color;

  const DescriptionText(
      {Key? key, required this.text, this.color = Colors.black54})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.descriptionTextStyle(color: color),
    );
  }
}

class NotificationCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bg_color;

  const NotificationCardWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor = AppColors.whiteColor,
    this.bg_color = AppColors.secondaryBlack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 4.0,
        color: bg_color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Row(
            children: [
              // Circular Image on the left
              ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 16.0), // Space between the image and text

              // Title and Subtitle on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleTextStyle(color: iconColor),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: AppTextStyles.subTitleTextStyle(color: iconColor),
                    ),
                  ],
                ),
              ),

              // Small icon on the top-right
              Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundColor: bg_color,
                  child: Icon(
                    icon,
                    size: 16.0,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String imageUrl1;
  final String title;
  final String subtitle;
  final Color color;

  const CustomCard({
    Key? key,
    required this.imageUrl1,
    required this.title,
    required this.subtitle,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl1,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).themeData ==
                              darkMode
                          ? AppColors.secondaryBlack
                          : AppColors.whiteColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Provider.of<ThemeProvider>(context).themeData ==
                              darkMode
                          ? AppColors.whiteColor
                          : AppColors.primaryColor,
                      size: 24.0, // Adjust icon size if needed
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0), // Spacing between images and text
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0), // Spacing between title and subtitle
              // Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardWithBorader extends StatelessWidget {
  final String imageUrl1;
  final String title;
  final Color color;
  final Color borderColor;

  const CustomCardWithBorader({

    Key? key,
    required this.imageUrl1,
    required this.title,
    required this.color,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: borderColor,
              width: 1.0, // Outline width
            ),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl1,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),

                ],
              ),
              SizedBox(height: 16.0), // Spacing between images and text
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0), // Spacing between title and subtitle
              // Subtitle

            ],
          ),
        ),
      ),
    );
  }
}


class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

class AppPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const AppPasswordField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  _AppPasswordFieldState createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: _toggleVisibility,
          ),
        ),
      ),
    );
  }
}


class AppDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String format;

  const AppDatePicker({
    Key? key,
    required this.controller,
    required this.label,
    this.format = 'yyyy-MM-dd',
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      final DateFormat formatter = DateFormat(format);
      controller.text = formatter.format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              labelText: label,
              labelStyle: TextStyle(color: Colors.grey[600]),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final String? imagePath; // Optional image path

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null) ...[
            Image.asset(
              imagePath!,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8), // Spacing between image and label
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class AppDropdown extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final String? selectedItem;
  final Function(String?) onChanged;

  const AppDropdown({
    Key? key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.selectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: DropdownButtonFormField<String>(
        value: selectedItem,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }
}


class BarChartWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String badge_url;
  final List<String> labels;
  final List<double> data;
  final Color barBackgroundColor;
  final Color barColor;
  final Color touchedBarColor;

  BarChartWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.labels,
    required this.data,
    this.barBackgroundColor = const Color(0xFFD3D3D3),
    this.barColor = AppColors.primaryColor,
    this.touchedBarColor = Colors.green, required this.badge_url,
  });

  @override
  State<StatefulWidget> createState() => _BarChartState();
}
//bar widget chart starts
class _BarChartState extends State<BarChartWidget> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TitleText(
                  text:widget.title,
                  color: Provider.of<ThemeProvider>(context).themeData == darkMode
                    ? AppColors.whiteColor
                    : AppColors.secondaryBlack,
                ),
                const SizedBox(height: 4),
                SubTitleText(text: widget.subtitle,
                  color: Provider.of<ThemeProvider>(context).themeData == darkMode
                      ? AppColors.whiteColor
                      : AppColors.secondaryBlack,),
                const SizedBox(height: 38),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(), // No animation, using mainBarData directly
                      duration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.topRight,
              child: Image.network(
                  height: 50,
                  width: 50,
                  widget.badge_url
              ),
            ),
          )
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : widget.barColor,
          width: 15,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 15,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(widget.data.length, (i) {
      return makeGroupData(i, widget.data[i], isTouched: i == touchedIndex);
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      space: 16,
      meta: meta,
      // Pass meta directly
      child: DescriptionText(
        text: widget.labels[value.toInt()],
        color: Provider.of<ThemeProvider>(context).themeData == darkMode
            ? AppColors.whiteColor
            : AppColors.secondaryBlack,
      ),
    );
  }

  BarChartData randomData() {
    final random = Random();
    final randomData = List.generate(
      widget.data.length,
          (_) => random.nextDouble() * 20,
    );

    return BarChartData(
      barGroups: List.generate(widget.labels.length, (i) {
        return makeGroupData(i, randomData[i]);
      }),
    );
  }

  Future<void> refreshState() async {
    setState(() {});
    await Future<void>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    // Removed playing functionality
  }
}
//bar widget chart end

//custom snakbar widget start
class AppSnackbar extends StatefulWidget {
  final String label;
  final bool isSuccess;
  final Color color;
  final Color bgColor;

  AppSnackbar({required this.label, required this.isSuccess, required this.color, required this.bgColor});

  @override
  _AppSnackbarState createState() => _AppSnackbarState();
}

class _AppSnackbarState extends State<AppSnackbar> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) {
          // Custom SnackBar
          final snackBar = SnackBar(
            content: Row(
              children: [
                Icon(
                  widget.isSuccess ? Icons.check_circle : Icons.error,
                  color: widget.color,
                ),
                SizedBox(width: 10),
                Expanded(child: SubTitleText(text: widget.label, color: widget.color,)),
              ],
            ),
            backgroundColor: widget.bgColor,
            duration: Duration(seconds: 3),
          );

          // Show SnackBar
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });

          return Container(); // Placeholder widget
        },
      ),
    );
  }
}
//custom snakbar widget end


