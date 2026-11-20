import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static const forest = Color(0xFF173F35);
  static const ivory = Color(0xFFF7F6F1);
  static const ink = Color(0xFF202B28);
  static const muted = Color(0xFF78817D);
  static const gold = Color(0xFFC6A477);
  static const error = Color(0xFFC65B5B);
  static const success = Color(0xFF4D8B69);
  static const line = Color(0xFFE5E7E2);
  static const tint = Color(0xFFEDF1ED);
  static const field = Color(0xFFDFE2DD);
}

TextStyle manrope(
  double size, {
  FontWeight w = FontWeight.w600,
  Color color = C.ink,
  double? h,
  double? ls,
}) => GoogleFonts.manrope(
  fontSize: size,
  fontWeight: w,
  color: color,
  height: h,
  letterSpacing: ls,
);

TextStyle dm(
  double size, {
  FontWeight w = FontWeight.w400,
  Color color = C.ink,
  double? h,
  double? ls,
}) => GoogleFonts.dmSans(
  fontSize: size,
  fontWeight: w,
  color: color,
  height: h,
  letterSpacing: ls,
);

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: C.ivory,
    colorScheme: ColorScheme.fromSeed(seedColor: C.forest, primary: C.forest),
  );
  return base.copyWith(textTheme: GoogleFonts.dmSansTextTheme(base.textTheme));
}

BoxDecoration cardBox({Color color = Colors.white, double r = 15}) =>
    BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(r),
      border: Border.all(color: C.line),
    );
