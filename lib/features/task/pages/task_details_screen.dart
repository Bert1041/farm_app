import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_app_bar_widget.dart';
import '../../../core/utils/theme.dart';
import '../widgets/check_icon_text_widget.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskTitle;
  final String taskSubTitle;
  final String taskDescription;
  final String timeDescription;
  final String priorityDescription;
  final String reasonDescription;

  const TaskDetailsScreen({
    super.key,
    required this.taskTitle,
    required this.taskSubTitle,
    required this.taskDescription,
    required this.timeDescription,
    required this.priorityDescription,
    required this.reasonDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: CustomScrollView(
            slivers: [
              const ReusableAppBar(
                title: 'Check Details',
                canPop: true,
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: AppTheme.backgroundColor,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      Text('Task: $taskTitle', style: AppTheme.bodyText1()),
                      SizedBox(height: 24.h),
                      Text('Category: $taskSubTitle', style: AppTheme.bodyText2()),
                      SizedBox(height: 18.h),
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
                                style: AppTheme.bodyText2(
                                    color: AppTheme.error700),
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
                                'Priority: $priorityDescription',
                                style: AppTheme.bodyText2(
                                    color: AppTheme.error700),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      SizedBox(height: 18.h),
                      Text('Description', style: AppTheme.title1()),
                      SizedBox(height: 10.h),
                      Text(
                        taskDescription,
                        style: AppTheme.bodyText3(fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 30.h),
                      Text('Note', style: AppTheme.title1()),
                      SizedBox(height: 10.h),
                      CheckIconWithText(
                        text: reasonDescription,
                      ),
                      SizedBox(height: 18.h),
                    ],
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
