import 'package:farm_app/features/task/pages/task_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils/theme.dart';
import '../../../common/widgets/reusable_app_bar_widget.dart';
import '../../../common/widgets/reusable_title_widget.dart';
import '../../../drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List<Map<String, String>> tasks = [
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'taskTitle': 'Check Poultry Litter',
      'taskSubTitle': 'Bedding',
      'taskDescription':
          'Spread clean, dry bedding evenly throughout the brooder area.',
      'timeDescription': '1 day age',
      'priorityDescription': 'Low Priority',
    },
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'taskTitle': 'Check Poultry Litter2',
      'taskSubTitle': 'Bedding 2',
      'taskDescription': 'Spread clean.',
      'timeDescription': '1 day age',
      'priorityDescription': 'Low Priority',
    },
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'taskTitle': 'Check Poultry',
      'taskSubTitle': 'Bedding 3',
      'taskDescription': 'Dry bedding evenly throughout the brooder area.',
      'timeDescription': '1 day age',
      'priorityDescription': 'Low Priority',
    },
  ];

  void goToNextTask() {
    setState(() {
      currentIndex = (currentIndex + 1) % tasks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: CustomScrollView(
            slivers: [
              const ReusableAppBar(title: 'Explore Tasks'),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  color: AppTheme.secondaryColor,
                  child: Column(
                    children: [
                      Container(
                        color: AppTheme.white,
                        padding: const EdgeInsets.all(16),
                        child: const TextField(
                          decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      Container(
                        color: AppTheme.backgroundColor,
                        width: double.infinity,
                        child: Column(
                          children: [
                            buildTaskSection('Missed Task'),
                            SizedBox(height: 8.h),
                            buildTaskSection('Today\'s Task')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Column buildTaskSection(String title) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableTitle(title: title),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      currentIndex = (currentIndex - 1) % tasks.length;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    goToNextTask();
                  },
                ),
              ],
            ),
          ],
        ),
        // SizedBox(height: 16.h),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(
                  imageUrl: tasks[currentIndex]['imageUrl']!,
                  taskTitle: tasks[currentIndex]['taskTitle']!,
                  taskSubTitle: tasks[currentIndex]['taskSubTitle']!,
                  taskDescription: tasks[currentIndex]['taskDescription']!,
                  timeDescription: tasks[currentIndex]['timeDescription']!,
                  priorityDescription: tasks[currentIndex]['priorityDescription']!,
                ),
              ),
            );
          },
          child: TaskCard(
            imageUrl: tasks[currentIndex]['imageUrl']!,
            taskTitle: tasks[currentIndex]['taskTitle']!,
            taskSubTitle: tasks[currentIndex]['taskSubTitle']!,
            taskDescription: tasks[currentIndex]['taskDescription']!,
            timeDescription: tasks[currentIndex]['timeDescription']!,
            priorityDescription: tasks[currentIndex]['priorityDescription']!,
          ),
        ),
      ],
    );
  }
}


class TaskCard extends StatelessWidget {
  final String imageUrl;
  final String taskTitle;
  final String taskSubTitle;
  final String taskDescription;
  final String timeDescription;
  final String priorityDescription;

  const TaskCard({
    super.key,
    required this.imageUrl,
    required this.taskTitle,
    required this.taskSubTitle,
    required this.taskDescription,
    required this.timeDescription,
    required this.priorityDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Image.network(
                imageUrl,
                height: 110.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskTitle,
                  style: AppTheme.bodyText1(),
                ),
                const SizedBox(height: 8.0),
                Text(
                  taskSubTitle,
                  style: AppTheme.bodyText2(),
                ),
                const SizedBox(height: 16.0),
                Text(
                  taskDescription,
                  style: AppTheme.bodyText3(),
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
          ],
        ),
      ),
    );
  }
}
