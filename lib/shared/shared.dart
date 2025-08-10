import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = 24;

  
Color primaryColor =  const Color(0xFFF9F9F9);
Color secondaryColor = const Color(0xFFDF5F46);
Color fontColor = const Color(0xFF171616);
Color darkColor = const Color(0xFFC6BABA);
Color another = const Color(0xffB9B7B7);
Color column = const Color(0xffD8D4D4);
Gradient gradient = const LinearGradient(
   colors: <Color>[Color(0xffD8D4D4), Color(0xffB9B7B7)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

TextStyle mediumTextStyle = GoogleFonts.poppins(fontSize: 24, color: fontColor,fontWeight: FontWeight.w800);
TextStyle smallTextStyle = GoogleFonts.poppins(fontSize: 12, color: fontColor,fontWeight: FontWeight.w500);
TextStyle normalTextStyle = GoogleFonts.poppins(fontSize: 16, color: fontColor,fontWeight: FontWeight.w500);
