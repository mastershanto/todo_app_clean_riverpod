import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app_clean_riverpod/core/theme/app_colors.dart';
import 'package:todo_app_clean_riverpod/core/theme/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.card,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.textStylec24c333333NunitoSans700,
      displayMedium: AppTextStyles.textStylec20c333333NunitoSans700,
      displaySmall: AppTextStyles.textStylec18c333333NunitoSans700,
      headlineMedium: AppTextStyles.textStylec16c333333NunitoSans700,
      headlineSmall: AppTextStyles.textStylec14c333333NunitoSans600,
      titleLarge: AppTextStyles.textStylec12cB7BAC0NunitoSans600,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTextStyles.textStylec20c333333NunitoSans700.copyWith(
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.textStylec16c333333NunitoSans700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: AppTextStyles.textStylec14c333333NunitoSans600.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
  );
}
