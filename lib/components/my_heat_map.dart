import 'package:flutter/material.dart';

import 'app_global_widgets.dart';

class buildCalenderHeatMap extends StatelessWidget {
  final Map<DateTime, int> datasets; // Map of dates to activity values
  final DateTime startDate;
  final int selectedIndex; // Index of the selected day, default to 0

  buildCalenderHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
    this.selectedIndex = 0, // Default to the first index
  });

  @override
  Widget build(BuildContext context) {
    // Generate the last 7 days including today
    final List<DateTime> last7Days = List.generate(
      7,
          (index) => startDate.subtract(Duration(days: index)),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: last7Days.map((date) {
            final isSelected = last7Days.indexOf(date) == selectedIndex;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: HomeCalenderCardWidget(isSelected: isSelected,date: date,),
            );
          }).toList(),
        ),
      ),
    );
  }

}
