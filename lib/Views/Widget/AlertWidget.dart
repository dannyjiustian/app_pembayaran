import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

MotionToast AlertWidget(double mediaQueryWidth, IconData iconType,
    Color alertColor, String title, String description) {
  return MotionToast(
    icon: iconType,
    primaryColor: alertColor,
    title: Text(
      "${title}",
      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
    ),
    description: Text(
      "${description}",
      style: GoogleFonts.poppins(fontSize: 11),
    ),
    width: mediaQueryWidth * 0.9,
    height: 80,
    animationType: AnimationType.fromRight,
  );
}
