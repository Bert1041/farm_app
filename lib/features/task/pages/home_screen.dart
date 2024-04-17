import 'package:farm_app/features/task/pages/sections/missed_section.dart';
import 'package:farm_app/features/task/pages/sections/pre_arrival_section.dart';
import 'package:farm_app/features/task/pages/sections/today_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_app_bar_widget.dart';
import '../../../core/services/tasks.dart';
import '../../../core/utils/theme.dart';
import '../../../drawer.dart';
import '../widgets/task_buttons.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Stream<bool>? isStartedFarmingStream;
  late List<DocumentSnapshot> preArrivalTasks = [];
  User? user = FirebaseAuth.instance.currentUser;

  late TabController _tabController;
  late TaskService _taskService;
  int? _currentDay;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService();
    _tabController = TabController(length: 2, vsync: this);
    fetchPreArrivalTasks();
    _fetchCurrentDay();
    if (user != null) {
      isStartedFarmingStream = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .map<bool>((snapshot) {
        final data = snapshot.data();
        if (data != null && data['isFarmingStarted'] != null) {
          return data['isFarmingStarted'];
        } else {
          return false;
        }
      });
    }
  }

  Future<void> _fetchCurrentDay() async {
    final taskStartDate = await _taskService.getTaskStartDate();
    if (taskStartDate != null) {
      setState(() {
        _currentDay = _taskService.getCurrentDay(taskStartDate);
      });
    } else {
      // Handle the case where task start date is not found
    }
  }

  Future<void> fetchPreArrivalTasks() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('pre-arrival-tasks')
          .get();
      setState(() {
        preArrivalTasks = querySnapshot.docs;
      });
    } catch (error) {
      print('Error fetching pre-arrival tasks: $error');
    }
  }

  Stream<List<DocumentSnapshot>> fetchTodayTasksStream() {
    if (_currentDay != null) {
      return _taskService.getTasksForDayStream(_currentDay!);
    } else {
      // Return an empty stream if _currentDay is null
      return Stream.value([]);
    }
  }

  // Future<List<DocumentSnapshot>> fetchCompletedTasks() async {
  //   if (_currentDay != null) {
  //     final completedTasks =
  //         await _taskService.getCompletedTasksForDay(_currentDay!);
  //     return completedTasks;
  //   } else {
  //     return [];
  //   }
  // }

  Stream<List<DocumentSnapshot>> fetchMissedTasks() {
    return _taskService.getMissedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context, _currentDay),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: StreamBuilder<bool>(
            stream: isStartedFarmingStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                // Farming process has started, hide the button
                return CustomScrollView(
                  slivers: [
                    ReusableAppBar(
                      title: 'Explore Tasks',
                      bottom: TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Today\'s Tasks'),
                          Tab(text: 'Missed Tasks'),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Column(
                              children: [
                                //TODO: // Text('Current Day: $_currentDay'),
                                Container(
                                  color: AppTheme.backgroundColor,
                                  width: double.infinity,
                                  child: StreamBuilder<List<DocumentSnapshot>>(
                                    stream: fetchTodayTasksStream(),
                                    builder: (context, todayTasksSnapshot) {
                                      if (todayTasksSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox.shrink();
                                      } else {
                                        final List<DocumentSnapshot>
                                            todayTasks =
                                            todayTasksSnapshot.data ?? [];
                                        return buildTaskSection(
                                          'Today\'s Task(s)',
                                          todayTasks,
                                          _currentDay!,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(height: 18.h),
                                StreamBuilder(
                                  stream: fetchMissedTasks(),
                                  builder: (context, missedTasksSnapshot) {
                                    if (missedTasksSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    } else {
                                      return buildMissedTaskSection(
                                          'Missed Task(s)',
                                          missedTasksSnapshot.data!,
                                          _currentDay!);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              } else {
                // Farming process has not started, show the button
                bool isUserNull = user != null;
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          buildPreArrivalTaskSection(
                              'Pre Arrival Tasks', preArrivalTasks),
                        ],
                      ),
                    ),
                    SignUpButton(isUserNull: isUserNull),
                    StartTrackingButton(isUserNull: isUserNull),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
