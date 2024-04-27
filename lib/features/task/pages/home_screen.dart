import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_app/features/task/pages/sections/missed_section.dart';
import 'package:farm_app/features/task/pages/sections/pre_arrival_section.dart';
import 'package:farm_app/features/task/pages/sections/today_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/common/widgets/reusable_app_bar_widget.dart';
import '../../../core/helpers/authentication_helper.dart';
import '../../../core/services/firestore.dart';
import '../../../core/services/tasks.dart';
import '../../../core/utils/theme.dart';
import '../../../drawer.dart';
import '../../auth/pages/login_screen.dart';
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
  List<DocumentSnapshot> todayTasks = [];
  User? user = FirebaseAuth.instance.currentUser;

  late TabController _tabController;
  late TaskService _taskService;
  int _currentDay = 0;
  double _progressValue = 0.0;
  bool _isLoading = true;
  bool _initialTasksAdded = false;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService();
    _tabController = TabController(length: 3, vsync: this);
    fetchPreArrivalTasks();
    _fetchCurrentDay();
    _checkInitialTasks();
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

  Future<void> _checkInitialTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool initialTasksAdded =
        prefs.getBool(FirebaseAuth.instance.currentUser!.uid) ?? false;
    print('initialTasksAdded');
    print(FirebaseAuth.instance.currentUser!.uid);
    print(initialTasksAdded);
    if (!initialTasksAdded) {
      await _addInitialTasks();
      // prefs.setBool(FirebaseAuth.instance.currentUser!.uid, true);
    } else {
      setState(() {
        _isLoading = false;
        _initialTasksAdded = true;
      });
    }
  }

  Future<void> _addInitialTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirestoreService.addInitialTasksForUser(
        FirebaseAuth.instance.currentUser!.uid,
        (double progress) {
          _updateProgress(progress);
        },
      );
    } catch (error) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProgress(double progress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _progressValue = progress;
    });

    if (_progressValue >= 1) {
      prefs.setBool(FirebaseAuth.instance.currentUser!.uid, true);
      _refreshPage();
    }
  }

  void _refreshPage() {
    // Implement your logic to refresh the page here
    // For example, you can use Navigator to pop and push the current route
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(user: user),
      ),
    );
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
    if (user != null) {
      return _taskService.getTasksForDayStream(_currentDay);
    } else {
      // Return an empty stream if _currentDay or user is null
      return Stream.value([]);
    }
  }

  Stream<List<DocumentSnapshot>> fetchMissedTasks() {
    if (user != null) {
      return _taskService.getMissedTasks(_currentDay);
    } else {
      // Return an empty stream if _currentDay or user is null
      return Stream.value([]);
    }
  }

  Stream<bool> checkHealthLogs(int day) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('healthLogs')
          .where('userId', isEqualTo: user.uid)
          .where('day', isEqualTo: day)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) {
          return true;
        }
        if (snapshot.docs.isNotEmpty) {
          final healthLog = snapshot.docs.first.data();
          // Check if all health indicators are normal
          final isNormal = healthLog.values
              .every((value) => value is Map ? value['Normal'] == true : true);
          return isNormal;
        }
        return false;
      });
    }
    // Return an empty stream if user is not logged in
    return Stream.value(false);
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
                          Tab(text: 'Critical Tasks'),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: double.maxFinite,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Column(
                              // mainAxisSize: MainAxisSize.max,
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
                                          _currentDay,
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
                                          _currentDay);
                                    }
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(height: 18.h),
                                StreamBuilder<bool>(
                                  stream: checkHealthLogs(_currentDay),
                                  builder: (context, criticalTasksSnapshot) {
                                    if (criticalTasksSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    } else {
                                      final bool isHealthNormal =
                                          criticalTasksSnapshot.data ?? false;
                                      if (isHealthNormal) {
                                        return const Center(
                                          child: Text(
                                            'No Critical Tasks',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            ListTile(
                                              title: const Text('Contact Vet'),
                                              tileColor: AppTheme.error700
                                                  .withOpacity(0.7),
                                              onTap: () {
                                                // Implement your logic for contacting vet
                                              },
                                            ),
                                            ListTile(
                                              tileColor: AppTheme.error700
                                                  .withOpacity(0.5),
                                              title: const Text(
                                                  'Quarantine Birds'),
                                              onTap: () {
                                                // Implement your logic for quarantining birds
                                              },
                                            ),
                                            ListTile(
                                              tileColor: AppTheme.error700
                                                  .withOpacity(0.2),
                                              title: const Text('Investigate'),
                                              onTap: () {
                                                _showInvestigateDialog(context);
                                              },
                                            ),
                                          ],
                                        );
                                      }
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
                    PreferredSize(
                      preferredSize: const Size.fromHeight(100.0),
                      // Set your custom height here
                      child: Container(
                        color: AppTheme.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                AuthenticationHelper().signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isUserNull)
                      Visibility(
                        visible: !_initialTasksAdded,
                        child: LinearProgressIndicator(
                          value: _progressValue,
                          backgroundColor: Colors.grey,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    if (!_initialTasksAdded) const SizedBox(height: 20),
                    if (isUserNull)
                      if (!_initialTasksAdded)
                        const Text('Setting up daily tasks...'),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          buildPreArrivalTaskSection(
                            'Pre Arrival Tasks',
                            preArrivalTasks,
                            context,
                          ),
                        ],
                      ),
                    ),
                    SignUpButton(isUserNull: isUserNull),
                    Visibility(
                      visible: _initialTasksAdded,
                      child: StartTrackingButton(
                        isUserNull: isUserNull,
                      ),
                    ),
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

void _showInvestigateDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Investigate'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInvestigateTable(
                'Poor Chick Quality',
                'Inadequate diet of source flock\nHealth and hygiene status of source flock, hatchery, and equipment\nIncorrect parameters for egg storage, relative humidity, temperatures, and equipment management\nIncorrect moisture loss during incubation\nIncorrect incubation temperature\nDehydration caused by excessive spread of hatch time or late removal of chicks',
                'Source flock health and hygiene status\nEgg handling, storage, and transport\nHatchery sanitation, incubation, and management\nChick processing, handling, and transport',
              ),
              const SizedBox(height: 20),
              _buildInvestigateTable(
                'Small Chicks Days 1-4',
                'Less than 95% of chicks with adequate crop fill by 24 hours post placement\nWeak chicks\nInadequate feeders and drinkers\nInadequate feed and water levels\nEquipment location and maintenance issues\nInappropriate brooding temperature and environment',
                'Feed, Light, Air, Water, and Space:\nCrop fill at 24 hours post chick placement\nAvailability and accessibility to feed and water\nBird comfort and welfare',
              ),
              const SizedBox(height: 20),
              _buildInvestigateTable(
                'Troubleshooting common issues after 7 days of age',
                'Disease:\nMetabolic\nBacterial\nViral\nFungal\nProtozoal\nParasitic\nToxin',
                'Poor environmental conditions\nPoor biosecurity\nHigh disease challenge\nLow disease protection\nInadequate or improper\nimplementation of disease\nprevention\nPoor feed quality\nPoor bird access to feed\nExcessive or insufficient\nventilation',
              ),
              const SizedBox(height: 20),
              _buildInvestigateTable(
                'Stress',
                'Inadequate farm management\nInadequate equipment\nInadequate bird comfort and welfare',
                'Potential stressors:\nTemperature\nManagement\nImmunosuppressive disorders',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

Widget _buildInvestigateTable(
    String title, String likelyCauses, String investigate) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      Text(
        'Likely Causes:\n$likelyCauses',
        style: const TextStyle(color: Colors.redAccent),
      ),
      const SizedBox(height: 10),
      Text('Investigate:\n$investigate',
          style: const TextStyle(color: AppTheme.secondary400)),
    ],
  );
}
