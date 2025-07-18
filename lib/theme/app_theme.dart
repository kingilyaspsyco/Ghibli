import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() {
    return ThemeData(
      // style de la appbar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      textTheme: TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'RedditSansCondensed',
          fontWeight: FontWeight.w400,
        ),

        titleMedium: TextStyle(
          fontFamily: 'RedditSansCondensed',
          fontSize: 21,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}