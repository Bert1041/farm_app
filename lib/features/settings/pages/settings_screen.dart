import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_app_bar_widget.dart';
import '../../../core/common/widgets/reusable_button_widget.dart';
import '../../../core/utils/theme.dart';
import '../../../drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  String? _selectedBatch;
  String? _selectedWeight;
  String? _selectedTemp;
  String? _selectedFeedConsumption;
  String? _selectedWaterConsumption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context, null),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: CustomScrollView(
            slivers: [
              ReusableAppBar(
                title: 'Settings',
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'General'),
                    Tab(text: 'Notification'),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 400, // Adjust the height as per your requirement
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // General Tab Content
                      Center(
                        child: Column(
                          children: [
                            Text('General Tab Content'),
                            Expanded(child: SizedBox()),
                            SizedBox(
                              width: double.infinity,
                              child: ReusableButton(
                                label: 'Save Changes',
                                color: AppTheme.primary500,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Notification Tab Content
                      Center(
                        child: Text('Notification Tab Content'),
                      ),
                    ],
                  ),
                ),
              ),
              // SliverToBoxAdapter(
              //   child: Container(
              //     color: AppTheme.backgroundColor,
              //     width: double.infinity,
              //     child: Column(
              //       children: [
              //         // TabBarView(
              //         //   controller: _tabController,
              //         //   children: [
              //         //     // General Tab Content
              //         //     Center(
              //         //       child: Text('General Tab Content'),
              //         //     ),
              //         //     // Notification Tab Content
              //         //     Center(
              //         //       child: Text('Notification Tab Content'),
              //         //     ),
              //         //   ],
              //         // ),
              //       ],
              //     ),
              //     // child: Column(
              //     //   crossAxisAlignment: CrossAxisAlignment.start,
              //     //   children: [
              //     //     SizedBox(height: 24.h),
              //     //     ReusableDropdown<String>(
              //     //       labelText: 'Select Batch',
              //     //       items: ['Option 1', 'Option 2', 'Option 3'],
              //     //       value: _selectedBatch,
              //     //       onChanged: (value) {
              //     //         setState(() {
              //     //           _selectedBatch = value;
              //     //         });
              //     //       },
              //     //     ),
              //     //     SizedBox(height: 24.h),
              //     //     ReusableDropdown<String>(
              //     //       labelText: 'Weight (in grams)',
              //     //       items: ['Option 1', 'Option 2', 'Option 3'],
              //     //       value: _selectedWeight,
              //     //       onChanged: (value) {
              //     //         setState(() {
              //     //           _selectedWeight = value;
              //     //         });
              //     //       },
              //     //     ),
              //     //     SizedBox(height: 24.h),
              //     //     ReusableDropdown<String>(
              //     //       labelText: 'Temperature (in Celsius)',
              //     //       items: ['Option 1', 'Option 2', 'Option 3'],
              //     //       value: _selectedTemp,
              //     //       onChanged: (value) {
              //     //         setState(() {
              //     //           _selectedTemp = value;
              //     //         });
              //     //       },
              //     //     ),
              //     //     SizedBox(height: 24.h),
              //     //     ReusableDropdown<String>(
              //     //       labelText: 'Feed Consumption (in kilograms)',
              //     //       items: ['Option 1', 'Option 2', 'Option 3'],
              //     //       value: _selectedFeedConsumption,
              //     //       onChanged: (value) {
              //     //         setState(() {
              //     //           _selectedFeedConsumption = value;
              //     //         });
              //     //       },
              //     //     ),
              //     //     SizedBox(height: 24.h),
              //     //     ReusableDropdown<String>(
              //     //       labelText: ' Water Consumption (in liters)',
              //     //       items: ['Option 1', 'Option 2', 'Option 3'],
              //     //       value: _selectedWaterConsumption,
              //     //       onChanged: (value) {
              //     //         setState(() {
              //     //           _selectedWaterConsumption = value;
              //     //         });
              //     //       },
              //     //     ),
              //     //     SizedBox(height: 48.h),
              //     //     SizedBox(
              //     //       width: double.infinity,
              //     //       child: ReusableButton(
              //     //         label: 'Save Changes',
              //     //         color: AppTheme.primary500,
              //     //         onPressed: () {},
              //     //       ),
              //     //     ),
              //     //   ],
              //     // ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
