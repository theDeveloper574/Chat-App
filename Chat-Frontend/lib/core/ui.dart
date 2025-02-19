import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppColors {
  // static const whiteColor = Color(0xffFFFFFF);
  static const whiteColor = Color(0xff262f40);
  // static const text = Color(0xff000000);
  static const text = Color(0xffc2cedd);
  static const primaryColor = Color(0xff161d2d);
  static const greyColor = Color(0xff161d2d);
  static const navBarColor = Color(0xff262f40);
  static const circleColor = Color(0xff315fc4);
  static const drawerColor = Color(0xFF1E3A8A);
}

class Themes {
  static ThemeData defaultTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.whiteColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.greyColor,
      // iconTheme: IconThemeData(color: AppColors.text),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.text,
      secondary: AppColors.text,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primaryColor, // Color for selected icon
      unselectedItemColor: AppColors.text, // Color for unselected icon
      backgroundColor: AppColors.navBarColor, // Background color of the bar
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600), // Optional
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400), // Optional
    ),
  );
}

class TextStyles {
  static TextStyle heading1 = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 48,
  );

  static TextStyle heading2 = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 32,
  );

  static TextStyle heading3 = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 28,
  );
  static TextStyle heading4 = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 24,
  );

  static TextStyle body1 = const TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.text,
    fontSize: 20,
  );

  static TextStyle body2 = const TextStyle(
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    fontSize: 18,
  );
  static TextStyle body3 = const TextStyle(
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    fontSize: 16,
  );
  static TextStyle body4 = const TextStyle(
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    fontSize: 14,
  );
}

Future<void> toast({required String message}) async {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.primaryColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
