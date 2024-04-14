import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // static const Color primaryColor = Color(0xFF3A006B);
  // static const Color black = Color(0xFF292D32);
  static const Color secondaryColor = Color(0xFF8E92BC);
  static const Color buttonColor = Color(0xFF0E64D2);
  static const Color socialButtonColor = Color(0xFF1877F2);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color black = Color(0xFF000000);
  static const Color blackSecondary = Color(0xFF141522);
  static const Color secondary400 = Color(0xFF54577A);
  static const Color primary500 = Color(0xFF546FFF);
  static const Color error700 = Color(0xFFB71112);
  static const Color white = Color(0xFFFFFFFF);

  static TextStyle title({
    Color color = AppTheme.black,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return GoogleFonts.poppins(
      fontSize: 24.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle title1({
    Color color = AppTheme.black,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.poppins(
      fontSize: 20.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle textField({
    Color color = AppTheme.black,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      fontSize: 12.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle linkText({
    Color color = AppTheme.black,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle bodyText1({
    Color color = AppTheme.blackSecondary,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 16.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle bodyText2({
    Color color = AppTheme.secondary400,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 16.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle bodyText3({
    Color color = AppTheme.blackSecondary,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: 12.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

// static InputBorder enabledBorder() {
//   return OutlineInputBorder(
//     borderSide: BorderSide(
//       color: AppTheme.grey100.withOpacity(0.1),
//       width: 1.0,
//     ),
//     borderRadius: BorderRadius.all(
//       Radius.circular(8.r),
//     ),
//   );
// }
//
// static InputBorder focusedBorder() {
//   return OutlineInputBorder(
//     borderSide: const BorderSide(color: AppTheme.primaryColor500),
//     borderRadius: BorderRadius.circular(8.r),
//   );
// }
//
// static InputBorder errorBorder() {
//   return OutlineInputBorder(
//     borderSide: const BorderSide(color: AppTheme.errorRed),
//     borderRadius: BorderRadius.circular(8.r),
//   );
// }
//
// static InputBorder focusedErrorBorder() {
//   return OutlineInputBorder(
//     borderSide: const BorderSide(color: AppTheme.errorRed),
//     borderRadius: BorderRadius.circular(8.r),
//   );
// }
//
// static InputBorder disabledBorder() {
//   return OutlineInputBorder(
//     borderSide: BorderSide(
//       color: AppTheme.grey100.withOpacity(0.1),
//       width: 1.0,
//     ),
//     borderRadius: BorderRadius.all(
//       Radius.circular(8.r),
//     ),
//   );
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
  ),
  cardTheme: const CardTheme(color: Colors.white),
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
);
