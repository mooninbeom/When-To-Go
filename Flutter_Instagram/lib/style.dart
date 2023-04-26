import 'package:flutter/material.dart';

var theme = ThemeData(
    iconTheme: IconThemeData(
      color: Colors.blue,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.black,
      ),
        elevation: 1,
        color: Colors.white,
        actionsIconTheme: IconThemeData(
          color: Colors.black,
          size: 30,
        ),
        toolbarTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.w400,
        )
    ),
    textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 18,
        )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
    )

);