import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils/theme.dart';
import '../../../common/widgets/reusable_app_bar_widget.dart';
import '../../../common/widgets/reusable_button_widget.dart';
import '../../../common/widgets/reusable_dropdown_widget.dart';
import '../../../common/widgets/reusable_textformfield_widget.dart';
import '../../../drawer.dart';

class DataLogScreen extends StatefulWidget {
  const DataLogScreen({super.key});

  @override
  State<DataLogScreen> createState() => _DataLogScreenState();
}

class _DataLogScreenState extends State<DataLogScreen> {
  String? _selectedBatch;
  String? _selectedWeight;
  String? _selectedTemp;
  String? _selectedFeedConsumption;
  String? _selectedWaterConsumption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: CustomScrollView(
            slivers: [
              const ReusableAppBar(title: 'Data Logging Form'),
              SliverToBoxAdapter(
                child: Container(
                  color: AppTheme.backgroundColor,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      ReusableDropdown<String>(
                        labelText: 'Select Batch',
                        items: ['Option 1', 'Option 2', 'Option 3'],
                        value: _selectedBatch,
                        onChanged: (value) {
                          setState(() {
                            _selectedBatch = value;
                          });
                        },
                      ),
                      SizedBox(height: 24.h),
                      ReusableDropdown<String>(
                        labelText: 'Weight (in grams)',
                        items: ['Option 1', 'Option 2', 'Option 3'],
                        value: _selectedWeight,
                        onChanged: (value) {
                          setState(() {
                            _selectedWeight = value;
                          });
                        },
                      ),
                      SizedBox(height: 24.h),
                      ReusableDropdown<String>(
                        labelText: 'Temperature (in Celsius)',
                        items: ['Option 1', 'Option 2', 'Option 3'],
                        value: _selectedTemp,
                        onChanged: (value) {
                          setState(() {
                            _selectedTemp = value;
                          });
                        },
                      ),
                      SizedBox(height: 24.h),
                      ReusableDropdown<String>(
                        labelText: 'Feed Consumption (in kilograms)',
                        items: ['Option 1', 'Option 2', 'Option 3'],
                        value: _selectedFeedConsumption,
                        onChanged: (value) {
                          setState(() {
                            _selectedFeedConsumption = value;
                          });
                        },
                      ),
                      SizedBox(height: 24.h),
                      ReusableDropdown<String>(
                        labelText: ' Water Consumption (in liters)',
                        items: ['Option 1', 'Option 2', 'Option 3'],
                        value: _selectedWaterConsumption,
                        onChanged: (value) {
                          setState(() {
                            _selectedWaterConsumption = value;
                          });
                        },
                      ),
                      SizedBox(height: 48.h),
                      SizedBox(
                        width: double.infinity,
                        child: ReusableButton(
                          label: 'SUBMIT',
                          color: AppTheme.blackSecondary,
                          onPressed: () {},
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
