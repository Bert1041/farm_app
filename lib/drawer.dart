import 'package:farm_app/features/auth/pages/login_screen.dart';
import 'package:farm_app/features/data_logging/pages/farm_log_screen.dart';
import 'package:farm_app/features/data_logging/pages/reports_screen.dart';
import 'package:farm_app/features/settings/pages/about_screen.dart';
import 'package:farm_app/features/task/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/helpers/authentication_helper.dart';
import 'core/utils/theme.dart';
import 'features/data_logging/pages/benchmark_screen.dart';

Drawer buildDrawer(BuildContext context, int currentDay) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: AppTheme.white,
          ),
          child: Image.asset('assets/images/logo.png'),
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(
            Icons.menu_book,
            size: 24.sp,
            color: AppTheme.secondary400,
          ),
          title: Text(
            'Task',
            style: AppTheme.bodyText2(),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(
            Icons.book_outlined,
            size: 24.sp,
            color: AppTheme.secondary400,
          ),
          title: Text(
            'Reports',
            style: AppTheme.bodyText2(),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ReportScreen(currentDay: currentDay),
              ),
            );
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(
            Icons.note_alt_outlined,
            size: 24.sp,
            color: AppTheme.secondary400,
          ),
          title: Text(
            'Benchmark',
            style: AppTheme.bodyText2(),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BenchmarkScreen(currentDay: currentDay),
              ),
            );
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(
            Icons.message,
            size: 24.sp,
            color: AppTheme.secondary400,
          ),
          title: Text(
            'Log',
            style: AppTheme.bodyText2(),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DataLogScreen(currentDay: currentDay),
              ),
            );
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(
            Icons.info_outline,
            size: 24.sp,
            color: AppTheme.secondary400,
          ),
          title: Text(
            'About',
            style: AppTheme.bodyText2(),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AboutScreen(currentDay: currentDay)),
            );
          },
        ),
        // ListTile(
        //   contentPadding: const EdgeInsets.all(16),
        //   leading: Icon(
        //     Icons.settings,
        //     size: 24.sp,
        //     color: AppTheme.secondary400,
        //   ),
        //   title: Text(
        //     'Settings',
        //     style: AppTheme.bodyText2(),
        //   ),
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const SettingsScreen()),
        //     );
        //   },
        // ),
        SizedBox(height: 100.h),
        ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(
            Icons.logout,
            size: 24.sp,
            color: AppTheme.error700,
          ),
          title: Text(
            'Logout',
            style: AppTheme.bodyText2(color: AppTheme.error700),
          ),
          onTap: () {
            AuthenticationHelper().signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ],
    ),
  );
}
