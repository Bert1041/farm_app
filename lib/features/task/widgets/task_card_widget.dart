import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/theme.dart';

class TaskCard extends StatelessWidget {
  final String taskTitle;
  final String taskSubTitle;
  final String taskDescription;
  final String timeDescription;
  final String priorityDescription;
  final VoidCallback onPressed; // Callback for the button press
  final int currentIndex;
  final int totalTasks;
  final bool isCompleted;

  const TaskCard({
    super.key,
    required this.taskTitle,
    required this.taskSubTitle,
    required this.taskDescription,
    required this.timeDescription,
    required this.priorityDescription,
    required this.onPressed,
    required this.currentIndex,
    required this.totalTasks,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskTitle,
                  maxLines: 1,
                  style: AppTheme.bodyText1(),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                Text(
                  taskSubTitle,
                  style: AppTheme.bodyText2(),
                ),
                const SizedBox(height: 16.0),
                Text(
                  taskDescription,
                  maxLines: 2,
                  style: AppTheme.bodyText3(),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppTheme.secondary400,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      timeDescription,
                      style: AppTheme.bodyText2(color: AppTheme.error700),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.priority_high,
                      color: AppTheme.secondary400,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      priorityDescription,
                      style: AppTheme.bodyText2(color: AppTheme.error700),
                    ),
                  ],
                ),
              ],
            ),

            // Display the count
            const SizedBox(height: 18.0),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Task ${currentIndex + 1} of $totalTasks',
                style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic),
              ),
            ),
            // const SizedBox(height: 10.0),
            // Visibility(
            //   visible: !isCompleted,
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ReusableButton(
            //       label: 'Mark as completed',
            //       color: Colors.lightGreen,
            //       onPressed: onPressed,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
