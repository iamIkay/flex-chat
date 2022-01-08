import 'package:chat_app/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static final lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: Palette.primaryColor,
   // accentColor: Colors.black,
    /*textTheme: GoogleFonts.poppinsTextTheme()
        .apply(bodyColor: Colors.black, displayColor: Colors.black),*/
    scaffoldBackgroundColor: Colors.white,
  );

  static final darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: Palette.primaryColor,
   /* accentColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme()
        .apply(bodyColor: Colors.white60, displayColor: Colors.white60),
    scaffoldBackgroundColor: Color.fromRGBO(22, 22, 22, 1),*/
  );
  //scaffoldBackgroundColor: Colors.black);
}
