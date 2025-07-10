import 'package:flutter/material.dart';

ThemeData lightmode=ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.blue.shade300,
    secondary: Colors.black
  )
);


ThemeData darkmode=ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade800,
    primary: Colors.blue.shade800,
    secondary: Colors.white
  )
);