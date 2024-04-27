import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_app_bar_widget.dart';
import '../../../core/utils/theme.dart';
import '../../../drawer.dart';

class AboutScreen extends StatefulWidget {
  final int currentDay;

  const AboutScreen({super.key, required this.currentDay});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context, widget.currentDay),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: CustomScrollView(
            slivers: [
              const ReusableAppBar(
                title: 'About',
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: AppTheme.backgroundColor,
                  width: double.infinity,
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Elevate your broiler farming with our specialized Poultry Management System designed for farmers using the "All-In-All-Out" method.',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Seamlessly stay on top of your farm operations, receive timely alerts for all your tasks daily, monitor health, track performance, and optimize resources for better results.',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Experience streamlined operations and enhanced productivity.',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
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
