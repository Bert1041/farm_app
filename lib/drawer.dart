import 'package:farm_app/common/utils/theme.dart';
import 'package:farm_app/features/data_logging/pages/farm_log_screen.dart';
import 'package:farm_app/features/settings/pages/settings_screen.dart';
import 'package:farm_app/features/task/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: AppTheme.white,
          ),
          child: Text(
            'LOGO',
            style: AppTheme.title(fontWeight: FontWeight.w600),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(16),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Icon(
            Icons.person,
            size: 24.sp,
            color: AppTheme.secondary400,
          ),
          title: Text(
            'Reports',
            style: AppTheme.bodyText2(),
          ),
          onTap: () {

          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Icon(
            Icons.message,
            size: 24.sp,
            color: AppTheme.secondary400,
          ),
          title: Text(
            'FarmLog',
            style: AppTheme.bodyText2(),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataLogScreen()),
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Icon(
            Icons.settings,
            size: 24.sp,
            color: AppTheme.secondary400,
          ),
          title: Text(
            'Settings',
            style: AppTheme.bodyText2(),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          },
        ),
      ],
    ),
  );
}
