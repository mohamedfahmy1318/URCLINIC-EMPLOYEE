import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: appScreenBackground,
    primaryColor: appColorPrimary,
    primaryColorDark: appColorPrimary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColorPrimary,
      primary: appColorPrimary,
      secondary: appColorSecondary,
    ),
    useMaterial3: true,
    hoverColor: Colors.white54,
    dividerColor: const Color(0xFF626E8A),
    fontFamily: GoogleFonts.interTight().fontFamily,
    drawerTheme: const DrawerThemeData(backgroundColor: appScreenBackground),
    appBarTheme: AppBarTheme(
      surfaceTintColor: appLayoutBackground,
      backgroundColor: appLayoutBackground,
      iconTheme: const IconThemeData(color: textPrimaryColor),
      titleTextStyle: TextStyle(
        color: canvasColor,
        fontFamily: GoogleFonts.interTight().fontFamily,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark),
    ),
    tabBarTheme: TabBarThemeData(indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Color(0xFFB6D5EF), width: 3))),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: appColorPrimary),
    cardTheme: CardThemeData(color: Colors.white),
    cardColor: appSectionBackground,
    iconTheme: const IconThemeData(color: textPrimaryColor),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: whiteColor),
    textTheme: GoogleFonts.interTightTextTheme(),
    //visualDensity: VisualDensity.adaptivePlatformDensity,
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appScreenBackgroundDark,
    primaryColor: appColorPrimary,
    primaryColorDark: appColorPrimary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColorPrimary,
      primary: appColorPrimary,
      secondary: appColorSecondary,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    hoverColor: Colors.black12,
    dividerColor: canvasColor,
    fontFamily: GoogleFonts.interTight().fontFamily,
    drawerTheme: const DrawerThemeData(backgroundColor: fullDarkCanvasColorDark),
    appBarTheme: AppBarTheme(
      surfaceTintColor: appScreenBackgroundDark,
      backgroundColor: appScreenBackgroundDark,
      iconTheme: const IconThemeData(color: whiteColor),
      titleTextStyle: TextStyle(
        color: whiteTextColor,
        fontFamily: GoogleFonts.interTight().fontFamily,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light),
    ),
    tabBarTheme: TabBarThemeData(indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.white))),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: appColorPrimary),
    cardTheme: CardThemeData(color: fullDarkCanvasColor),
    cardColor: fullDarkCanvasColor,
    iconTheme: const IconThemeData(color: whiteColor),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: appBackgroundColorDark),
    textTheme: GoogleFonts.interTightTextTheme(),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
