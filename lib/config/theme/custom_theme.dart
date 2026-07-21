/*
 * @Author: Km Muzahid
 * @Date: 2026-02-02 17:29:30
 * @Email: km.muzahid@gmail.com
 */
import 'package:cubit_template/config/color/app_color.dart';
import 'package:flutter/material.dart';

String fontFamily = 'Inter';
TextTheme baseTextTheme(ThemeColor appColor) =>
    ThemeData.light().textTheme.apply(
      fontFamily: fontFamily,
      displayColor: appColor.tEXT_white,
      bodyColor: appColor.tEXT_white,
    );

ThemeData commonThemeData(ThemeColor appColor) => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: appColor.background,
  textTheme: baseTextTheme(appColor),
  brightness: Brightness.light,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor:
          appColor.ratingPremiumTags_goldAccent, // OK / Cancel text color
      backgroundColor: appColor.ratingPremiumTags_goldAccent.withValues(
        alpha: .2,
      ),
    ),
  ),

  datePickerTheme: DatePickerThemeData(
    backgroundColor: appColor.bACKGROUND_darkCard,
    headerBackgroundColor: appColor.bACKGROUND_darkCard,
    headerForegroundColor: appColor.tEXT_white,

    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.amber;
      }
      return appColor.tEXT_white;
    }),

    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return appColor.background;
      }
      return appColor.background;
    }),

    // Border for selected day
    dayShape: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const CircleBorder(
          side: BorderSide(color: Colors.amber, width: 2),
        );
      }
      return const CircleBorder();
    }),

    todayForegroundColor: WidgetStateProperty.all(appColor.tEXT_white),
    todayBackgroundColor: WidgetStateProperty.all(appColor.background),
    todayBorder: BorderSide(color: appColor.background, width: 1.5),

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  extensions: [appColor],
  appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
  colorScheme: ColorScheme.fromSeed(
    seedColor: appColor.pRIMARY_brandClr,
    primary: appColor.pRIMARY_brandClr, // button, Snackbar Info
    onPrimary: appColor.tEXT_white, // text on button
    secondary: appColor.tEXT_sub, // unselected radio
    surface: appColor.bACKGROUND_darkCard, //card color, SnackBar Background
    onSurface: appColor.tEXT_white, //text on card
    outline: appColor.bACKGROUND_darkCardBoarder, // border color
    tertiary: const Color(0xFFF59E0B), // SnackBar Warning
    error: const Color(0xFFEF4444), // SnackBar Error
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: appColor.bACKGROUND_darkPage,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: BorderSide(
        color: appColor.bACKGROUND_darkCardBoarder,
        width: 1.5,
      ),
    ),

    hintStyle: TextStyle(
      color: Colors.grey.shade500,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ), //hint and prefix color
  ),

  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF061512),
      hintStyle: const TextStyle(
        color: Color(0xFF6B7280),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: appColor.bACKGROUND_darkCardBoarder,
          width: 1.5,
        ),
      ),
    ),
    textStyle: const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(80, 50),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      backgroundBuilder: (context, states, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF184F3A), Color(0xFF2F6F57)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),

            borderRadius: BorderRadius.circular(8),
          ),
          // The 'child' here is the internal label/icon of the button
          child: Center(child: child),
        );
      },
      shadowColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.orangeAccent, //loader color
      textStyle: const TextStyle(color: Colors.white), //title color
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1.5, color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);
