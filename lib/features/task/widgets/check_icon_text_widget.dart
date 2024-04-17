import 'package:flutter/material.dart';

import '../../../core/utils/theme.dart';


class CheckIconWithText extends StatelessWidget {
  final String text;
  final double iconSize;
  final Color? iconColor;

  const CheckIconWithText({
    super.key,
    required this.text,
    this.iconSize = 18,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon(
        //   Icons.check_circle,
        //   size: iconSize,
        //   color: AppTheme.primary500,
        // ),
        // const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodyText3(color: AppTheme.error700),
          ),
        ),
      ],
    );
  }
}
