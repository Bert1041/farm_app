import 'package:farm_app/common/widgets/reusable_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/theme.dart';

class ReusableAppBar extends StatelessWidget {
  final String title;
  final bool canPop;
  final PreferredSizeWidget? bottom;
  const ReusableAppBar({
    super.key,
    required this.title,
    this.canPop = false, this.bottom,
  });

  @override
  Widget build(BuildContext context) {
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
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
      ],
      bottom: bottom
    );
  }
}
