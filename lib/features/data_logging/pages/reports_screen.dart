import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_app_bar_widget.dart';
import '../../../core/utils/theme.dart';
import '../../../drawer.dart';
import 'benchmark_screen.dart';

class ReportScreen extends StatefulWidget {
  final int currentDay;

  const ReportScreen({super.key, required this.currentDay});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Stream<List<QueryDocumentSnapshot>> dataLogsStream;

  @override
  void initState() {
    super.initState();
    dataLogsStream = FirebaseFirestore.instance
        .collection('performanceLogs')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('day', isEqualTo: widget.currentDay)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context, widget.currentDay),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: CustomScrollView(
            slivers: [
              const ReusableAppBar(title: 'Report Page'),
              SliverToBoxAdapter(
                child: Container(
                  color: AppTheme.backgroundColor,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Day ${widget.currentDay}',
                          style: const TextStyle(
                              fontSize: 24, color: AppTheme.secondary400),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      StreamBuilder<List<QueryDocumentSnapshot>>(
                        stream: dataLogsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final List<QueryDocumentSnapshot> documents =
                                snapshot.data ?? [];

                            if (documents.isNotEmpty) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ReportCard(documents: documents),
                                  const SizedBox(height: 60),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BenchmarkScreen(
                                                    currentDay:
                                                        widget.currentDay),
                                          ),
                                        );
                                      },
                                      child: const Text('Benchmark Page'))
                                ],
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'Data has not been logged',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
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

class ReportCard extends StatelessWidget {
  final List<QueryDocumentSnapshot> documents;

  const ReportCard({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: documents.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Batch Name:  ',
                        style: AppTheme.title1(),
                      ),
                      TextSpan(
                        text: '${data["batchName"]}',
                        style: AppTheme.bodyText1(),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Feed Consumption:  ',
                        style: AppTheme.title1(),
                      ),
                      TextSpan(
                        text: '${data["feedConsumption"]}',
                        style: AppTheme.bodyText1(),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Temperature:  ',
                        style: AppTheme.title1(),
                      ),
                      TextSpan(
                        text: '${data["temperature"]}',
                        style: AppTheme.bodyText1(),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Water Consumption:  ',
                        style: AppTheme.title1(),
                      ),
                      TextSpan(
                        text: '${data["waterConsumption"]}',
                        style: AppTheme.bodyText1(),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Weight:  ',
                        style: AppTheme.title1(),
                      ),
                      TextSpan(
                        text: '${data["weight"]}',
                        style: AppTheme.bodyText1(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
