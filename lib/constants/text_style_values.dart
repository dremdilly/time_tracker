import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_tracker/constants/colors.dart';

class AppTextStyles {
  static final TextStyle h2_white = TextStyle(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: AppColors.white,
    fontSize: 28.sp,
    letterSpacing: 0.41.w,
  );

  static final TextStyle h3_white = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: AppColors.white,
    fontSize: 20.sp,
  );

  static final TextStyle regular_white = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: AppColors.white,
    fontSize: 24.sp,
  );

  static final TextStyle regular_black = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    color: AppColors.black,
    fontSize: 24.sp,
  );
}