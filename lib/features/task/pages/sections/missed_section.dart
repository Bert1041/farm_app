import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/reusable_title_widget.dart';
import '../../../../core/common/widgets/reussable_info_window_widget.dart';
import '../../../../core/utils/theme.dart';
import '../../widgets/task_card_widget.dart';
import '../task_details_screen.dart';

ExpansionTile buildMissedTaskSection(
    String title, List<DocumentSnapshot> tasksList, int currentDay) {
  // Filter tasks that are not on the current day
  List<DocumentSnapshot> missedTasks = tasksList.where((task) {
    int taskDay = task[
        'day']; // Assuming 'day' is the field representing the day of the task
    return taskDay < currentDay;
  }).toList();

  // Group missed tasks by day
  Map<int, List<DocumentSnapshot>> missedTasksByDay = {};
  for (var task in missedTasks) {
    int taskDay = task['day'];
    missedTasksByDay.putIfAbsent(taskDay, () => []);
    missedTasksByDay[taskDay]?.add(task);
  }

  // Build sections for each available day
  List<Widget> daySections = [];
  missedTasksByDay.forEach((day, tasks) {
    daySections.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: ReusableInfoWindow(
              title: 'Day $day',
              // Assuming you want to display the day number as the section title
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 4.h),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsScreen(
                        taskTitle: tasks[index]['taskTitle'],
                        taskSubTitle: tasks[index]['category'],
                        taskDescription: tasks[index]['description'],
                        timeDescription: tasks[index]['time'],
                        priorityDescription: 'Low currentPreArrivalTaskIndex',
                        reasonDescription: tasksList[index]['reason'],

                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TaskCard(
                    taskTitle: tasks[index]['taskTitle'],
                    taskSubTitle: tasks[index]['category'],
                    taskDescription: tasks[index]['description'],
                    timeDescription: tasks[index]['time'],
                    priorityDescription: tasks[index]['priority'],
                    currentIndex: index,
                    totalTasks: tasks.length,
                    onPressed: () {},
                    isCompleted: tasks[index]['isCompleted'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  });

  return ExpansionTile(
    collapsedBackgroundColor: AppTheme.tile2,
    initiallyExpanded: false,
    title: const SizedBox.shrink(),
    leading: ReusableTitle(
      title: title,
      fontWeight: FontWeight.w500,
    ),
    children: daySections,
  );
}
