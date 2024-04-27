import 'package:farm_app/features/data_logging/pages/performance_log_screen.dart';
import 'package:farm_app/features/data_logging/pages/reduction_log_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_app_bar_widget.dart';
import '../../../core/utils/theme.dart';
import '../../../drawer.dart';
import 'health_log_screen.dart';

class DataLogScreen extends StatefulWidget {
  final int currentDay;

  const DataLogScreen({super.key, required this.currentDay});

  @override
  State<DataLogScreen> createState() => _DataLogScreenState();
}

class _DataLogScreenState extends State<DataLogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context, widget.currentDay),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: CustomScrollView(
            slivers: [
              const ReusableAppBar(title: 'Data Logging Forms'),
              SliverToBoxAdapter(
                child: Container(
                  color: AppTheme.backgroundColor,
                  width: double.infinity,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 1.3,
                      children: [
                        FormCard(
                          icon: Icons.assignment,
                          formName: 'Performance Form',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PerformanceLogScreen(
                                  currentDay: widget.currentDay,
                                ),
                              ),
                            );
                          },
                        ),
                        FormCard(
                          icon: Icons.favorite,
                          formName: 'Health Form',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HealthFormScreen(
                                  currentDay: widget.currentDay,
                                ),
                              ),
                            );
                          },
                        ),
                        FormCard(
                          icon: Icons.trending_down,
                          formName: 'Reduction Form',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReductionFormScreen(
                                  currentDay: widget.currentDay,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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

class FormCard extends StatelessWidget {
  final IconData icon;
  final String formName;
  final VoidCallback onTap;

  const FormCard({
    super.key,
    required this.icon,
    required this.formName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30.0,
                color: AppTheme.primary500,
              ),
              const SizedBox(height: 10.0),
              Text(
                formName,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
