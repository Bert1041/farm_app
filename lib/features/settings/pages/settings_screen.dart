import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/widgets/reusable_app_bar_widget.dart';

class SettingsScreen extends StatefulWidget {
  final String userName;

  const SettingsScreen({super.key, required this.userName});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // drawer: buildDrawer(context, null),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: CustomScrollView(
            slivers: [
              const ReusableAppBar(
                title: 'Profile',
                canPop: true,
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      // Add space between app bar and user info
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue, // Set background color
                          child: Text(
                            user != null ? widget.userName : "", // Get initials
                            style: const TextStyle(
                                fontSize: 28,
                                color: Colors.white), // Customize text style
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Add space between avatar and user info
                      if (user != null) ...[
                        const SizedBox(height: 10),
                        Text('Email: ${user.email ?? ""}'),
                        // Handle null email
                      ],
                      const SizedBox(height: 20),
                      // Add space between user info and notification toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Notifications'), // Notification label
                          Switch(
                            // Notification toggle
                            value: true, // Set the default value here
                            onChanged: (value) {
                              // Implement your logic for toggling notifications
                            },
                          ),
                        ],
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
