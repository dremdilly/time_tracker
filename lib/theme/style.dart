import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_tracker/constants/colors.dart';

ThemeData appThemeLight(BuildContext context) {
  return ThemeData(
          brightness: Brightness.light,
          textTheme: Theme.of(context).textTheme.apply(
              fontFamily: GoogleFonts.nunitoSans().fontFamily,
              bodyColor: AppColors.black,
              displayColor: AppColors.black))
      .copyWith(
          textSelectionTheme: TextSelectionThemeData(
              selectionColor: AppColors.lightRed.withOpacity(0.3),
              selectionHandleColor: AppColors.lightRed,
              cursorColor: AppColors.lightRed));
}

ThemeData appThemeDark(BuildContext context) {
  return ThemeData(
          brightness: Brightness.dark,
          textTheme: Theme.of(context).textTheme.apply(
              fontFamily: GoogleFonts.nunitoSans().fontFamily,
              bodyColor: AppColors.white,
              displayColor: AppColors.white))
      .copyWith(
          textSelectionTheme: TextSelectionThemeData(
              selectionColor: AppColors.lightRed.withOpacity(0.3),
              selectionHandleColor: AppColors.lightRed,
              cursorColor: AppColors.lightRed));
}
