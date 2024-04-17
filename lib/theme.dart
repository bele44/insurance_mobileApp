import 'package:flutter/material.dart';

// primary and secondary colors
const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.green;
const Color textColor = Colors.black;

//  theme data
final ThemeData appTheme = ThemeData(
  primaryColor: primaryColor,
  secondaryHeaderColor: secondaryColor,
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
  ),
  textTheme: TextTheme(
    headline6: TextStyle(
      color: textColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
   
  ),
);
