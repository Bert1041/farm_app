import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_app/core/common/widgets/reusable_title_widget.dart';
import 'package:farm_app/features/task/pages/task_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/pre_arrival_task_card_widget.dart';

Column buildPreArrivalTaskSection(
    String title, List<DocumentSnapshot> tasksList) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ReusableTitle(
        title: title,
        fontWeight: FontWeight.w500,
      ),
      SizedBox(height: 16.h),
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tasksList.isEmpty ? 1 : tasksList.length,
        itemBuilder: (context, index) {
          if (tasksList.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('No pre-arrival tasks available'),
            );
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailsScreen(
                      taskTitle: tasksList[index]['taskTitle'],
                      taskSubTitle: tasksList[index]['category'],
                      taskDescription: tasksList[index]['description'],
                      timeDescription: tasksList[index]['time'],
                      priorityDescription: tasksList[index]['priority'],
                      reasonDescription: tasksList[index]['reason'],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PreArrivalTaskCard(
                  taskTitle: tasksList[index]['taskTitle'],
                  taskSubTitle: tasksList[index]['category'],
                  taskDescription: tasksList[index]['description'],
                  timeDescription: tasksList[index]['time'],
                  priorityDescription: tasksList[index]['priority'],
                  currentIndex: index,
                  totalTasks: tasksList.length,
                ),
              ),
            );
          }
        },
      ),
    ],
  );
}
