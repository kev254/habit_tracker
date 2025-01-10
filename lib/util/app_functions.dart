
import 'package:habit_tracker/models/habit.dart';


bool isHabitsCompletedToday(List<DateTime> completedDays){
  final today = DateTime.now();
  return completedDays.any((date) =>
    date.year == today.year &&
    date.month == today.month &&
    date.day == today.day,
   );
}

//prepare heatmap dataset
Map<DateTime,int>prepHeatMapDataset(List<Habit> habits){
  Map<DateTime,int>dataset ={};

  for(var habit in habits){
    for(var date in habit.completedDays){
      //normalize date to avoid time mismatch
      final normalizedDate = DateTime(date.year,date.month,date.day);
      //if present increment the count
      if(dataset.containsKey(normalizedDate)){
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;

      }
      else{
        //initialize it with count 1
        dataset[normalizedDate]=1;
      }
    }
  }
  return dataset;
}
String getDayOfWeek(DateTime date) {
  switch (date.weekday) {
    case 1: return "Mon";
    case 2: return "Tue";
    case 3: return "Wed";
    case 4: return "Thu";
    case 5: return "Fri";
    case 6: return "Sat";
    case 7: return "Sun";
    default: return "";
  }
}
