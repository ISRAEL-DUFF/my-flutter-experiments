import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class CashlyThemeData {
  // static Color primaryColor = const Color(0xA30D99);
  static Color primaryColor = Colors.purple;
  static Color secondaryColor = const Color(0xFDE3FBFF);
  static Color accentColor = const Color(0xA30D99FF);
  static Color indicatorColor = const Color(0xff2E1B7B);
  static Color errorColor = const Color(0xffEB5757);
  static Color scaffoldColor = const Color(0xffffffff);
  static Color cardColor = const Color(0xffFAF6FF);
  // static Color textColor1 = const Color(0xffFFFFFF);
  // static Color textColor2 = const Color(0xffFFFFFF);
  static Color dividerColor = const Color(0xffB6B6B6);
  static Color darkColor = const Color(0xff282828);
  static Color coolYellow = const Color(0xffffce31);
  static Color textColor = Colors.white; // const Color(0xff525252);

  static ThemeData themeData() {
    return ThemeData(
      // textTheme: GoogleFonts.nunitoTextTheme(),
      // primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      errorColor: errorColor,
      indicatorColor: indicatorColor,
      scaffoldBackgroundColor: scaffoldColor,
      accentColor: accentColor,
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(
          color: darkColor,
        ),
      ),
      cursorColor: primaryColor,
      dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      dividerTheme: DividerThemeData(thickness: .5, color: dividerColor),
      cardTheme: CardTheme(
          elevation: 0.2,
          color: cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
