import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.white,
    required this.onPressed,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 24.h,
            child: Image.asset(
              iconPath,
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16.0,
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
