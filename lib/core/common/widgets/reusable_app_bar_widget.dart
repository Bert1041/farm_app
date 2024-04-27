import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_app/core/common/widgets/reusable_title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../features/settings/pages/settings_screen.dart';
import '../../utils/theme.dart';

class ReusableAppBar extends StatelessWidget {
  final String title;
  final bool canPop;
  final PreferredSizeWidget? bottom;

  const ReusableAppBar({
    super.key,
    required this.title,
    this.canPop = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    print('display');

    return SliverAppBar.large(
        backgroundColor: AppTheme.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                canPop ? Icons.arrow_back_outlined : Icons.menu,
                color: AppTheme.secondaryColor,
              ),
              onPressed: canPop
                  ? () {
                      Navigator.of(context).pop();
                    }
                  : () {
                      Scaffold.of(context).openDrawer();
                    },
            );
          },
        ),
        title: ReusableTitle(title: title),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: AppTheme.secondaryColor,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
          if (user != null)
            FutureBuilder(
              future: _getUserData(user.uid),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                // Retrieve username from Firestore
                String userName =
                    (snapshot.data!.data() as Map)['userName'] ?? 'Unknown';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SettingsScreen(userName: userName[0])),
                    );
                  },
                  child: CircleAvatar(
                      radius: 24,
                      child: Text(
                        userName[0],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      )),
                );
              },
            ),
          if (user == null)
            CircleAvatar(
              radius: 24,
              child: Image.network('https://via.placeholder.com/150'),
            ),
        ],
        bottom: bottom);
  }

  Future<DocumentSnapshot> _getUserData(String userId) {
    return FirebaseFirestore.instance.collection('users').doc(userId).get();
  }
}
