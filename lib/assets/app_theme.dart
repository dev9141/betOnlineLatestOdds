import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../utils/constants/define.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.secondary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.textColor),
      bodyMedium: TextStyle(color: AppColors.textColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: Size(double.infinity, 50),
      ),
    ),
  );
  static  TextStyle primaryButtonBoldTheme = TextStyle(
    fontFamily: 'Poppins',
    fontSize: normalFont,
    fontWeight: FontWeight.w700,
    color: isDarkTheme.value ? AppColors.black : AppColors.primary ,
  );

  static  TextStyle appBarTitleTheme = TextStyle(
    fontFamily: 'Poppins',
    fontSize: xxNormalFont,
    fontWeight: FontWeight.w700,
    color: isDarkTheme.value ? AppColors.primary : AppColors.black ,
  );

  static const TextStyle textFieldTheme = TextStyle(
    fontFamily: 'Poppins',
    fontSize: xxSmallFont,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const TextStyle normalTextTheme = TextStyle(
    fontFamily: 'Poppins',
    fontSize: xxSmallFont,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const TextStyle errorTextTheme = TextStyle(
    fontFamily: 'Poppins',
    fontSize: xSmallFont,
    fontWeight: FontWeight.w400,
    color: AppColors.red,
  );

  static  TextStyle largeTitleBoldTheme = TextStyle(
    fontFamily: 'Poppins',
    fontSize: largeFont,
    fontWeight: FontWeight.w700,
    color: isDarkTheme.value ? AppColors.primary : AppColors.black ,
  );
}