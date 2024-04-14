import 'package:flutter/material.dart';

import '../utils/theme.dart';

class ReusableTitle extends StatelessWidget {
  final String title;
  final FontWeight? fontWeight;

  const ReusableTitle({super.key, required this.title, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTheme.title(fontWeight: fontWeight ?? FontWeight.w500),
      maxLines: 2,
      textAlign: TextAlign.center,
    );
  }
}
