// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trealapp/core/colors/colors.dart';

class TextStyles {
  static TextStyle title32 = GoogleFonts.lato(
      fontSize: 32, fontWeight: FontWeight.w600, color: grayColor);
  static final title26 = title32.copyWith(fontSize: 26);
  static final title24 = title32.copyWith(fontSize: 24);
  static final title22 = title32.copyWith(fontSize: 22);
  static final title20 = title32.copyWith(fontSize: 20);
  static final title18 = title32.copyWith(fontSize: 18);
  static final title16 = title32.copyWith(fontSize: 16);
  static final title14 = title32.copyWith(fontSize: 14);
  static final title12 = title32.copyWith(fontSize: 12);
  static final title11 = title32.copyWith(fontSize: 11);

  static TextStyle regular16 = GoogleFonts.lato(
      fontSize: 16, color: grayColor, fontWeight: FontWeight.normal);
  static TextStyle regular16Thin100 = GoogleFonts.lato(
      fontSize: 16, color: grayColor, fontWeight: FontWeight.w100);
  static TextStyle regular16Thin200 = GoogleFonts.lato(
      fontSize: 16, color: grayColor, fontWeight: FontWeight.w200);
  static TextStyle regular16Thin300 = GoogleFonts.lato(
      fontSize: 16, color: grayColor, fontWeight: FontWeight.w300);
  static TextStyle regular16Thin400 = GoogleFonts.lato(
      fontSize: 16, color: grayColor, fontWeight: FontWeight.w400);

  static TextStyle regular14Thin200 = GoogleFonts.lato(
      fontSize: 14, color: grayColor, fontWeight: FontWeight.w200);
  static TextStyle regular14Thin300 = GoogleFonts.lato(
      fontSize: 14, color: grayColor, fontWeight: FontWeight.w300);
  static TextStyle regular14Thin400 = GoogleFonts.lato(
      fontSize: 14, color: grayColor, fontWeight: FontWeight.w400);

  static final regular14 = regular16.copyWith(fontSize: 14);
  static final regular12 = regular16.copyWith(fontSize: 12);
  static final regular10 = regular16.copyWith(fontSize: 10);
}
