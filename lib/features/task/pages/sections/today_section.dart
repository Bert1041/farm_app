import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_app/core/utils/theme.dart';
import 'package:farm_app/features/task/pages/task_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/reusable_title_widget.dart';
import '../../../../core/common/widgets/reussable_info_window_widget.dart';
import '../../widgets/task_card_widget.dart';

Column buildTaskSection(
    String title, List<DocumentSnapshot> tasksList, int currentDay) {
  // Filter completed tasks
  final completedTasks =
      tasksList.where((task) => task['isCompleted'] == true).toList();
  final unCompletedTasks =
      tasksList.where((task) => task['isCompleted'] == false).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ReusableInfoWindow(
        title:
            'Day $currentDay:  You have ${tasksList.length} task(s) today, you have completed ${completedTasks.length} of ${tasksList.length}',
      ),
      SizedBox(height: 10.h),
      ExpansionTile(
        collapsedBackgroundColor: AppTheme.tile,
        initiallyExpanded: true,
        title: const SizedBox.shrink(),
        leading: ReusableTitle(
          title: title,
          fontWeight: FontWeight.w500,
        ),
        children: <Widget>[
          SizedBox(height: 16.h),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: unCompletedTasks.isEmpty ? 1 : unCompletedTasks.length,
            itemBuilder: (context, index) {
              if (unCompletedTasks.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('No tasks available'),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(
                          taskTitle: unCompletedTasks[index]['taskTitle'],
                          taskSubTitle: unCompletedTasks[index]['category'],
                          taskDescription: unCompletedTasks[index]
                              ['description'],
                          timeDescription: unCompletedTasks[index]['time'],
                          priorityDescription: unCompletedTasks[index]
                              ['priority'],
                          reasonDescription: unCompletedTasks[index]['reason'],
                          isCompleted: unCompletedTasks[index]['isCompleted'],
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('day')
                                .doc(currentDay.toString())
                                .collection('dailyTasks')
                                .doc(unCompletedTasks[index].id)
                                .update({'isCompleted': true}).then((_) {
                              print('Task marked as completed successfully');
                            }).catchError((error) {
                              print('Failed to mark task as completed: $error');
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TaskCard(
                      taskTitle: unCompletedTasks[index]['taskTitle'],
                      taskSubTitle: unCompletedTasks[index]['category'],
                      taskDescription: unCompletedTasks[index]['description'],
                      timeDescription: unCompletedTasks[index]['time'],
                      priorityDescription: unCompletedTasks[index]['priority'],
                      isCompleted: unCompletedTasks[index]['isCompleted'],
                      currentIndex: index,
                      totalTasks: unCompletedTasks.length,
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('day')
                            .doc(currentDay.toString())
                            .collection('dailyTasks')
                            .doc(unCompletedTasks[index].id)
                            .update({'isCompleted': true}).then((_) {
                          print('Task marked as completed successfully');
                        }).catchError((error) {
                          print('Failed to mark task as completed: $error');
                        });
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    ],
  );
}
