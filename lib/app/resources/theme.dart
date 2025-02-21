import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:momen/app/resources/styles_manager.dart';
import 'package:momen/app/resources/values.dart';

import 'color_manager.dart';
import 'font_manager.dart';

enum ThemeType {
  light,
}

const String light = "light";

ThemeMode currentThemeMode = ThemeMode.light;

extension ThemeTypeExtension on ThemeType {
  String getValue() {
    switch (this) {
      case ThemeType.light:
        return light;
    }
  }
}

ThemeData getApplicationLightTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: ColorManager.lightPrimary,
    secondaryHeaderColor: ColorManager.white,
    scaffoldBackgroundColor: ColorManager.lightBackground,
    canvasColor: ColorManager.lightPrimary,
    splashColor: ColorManager.primary,
    disabledColor: ColorManager.lightGrey,
    shadowColor: ColorManager.lightSecondary,
    unselectedWidgetColor: ColorManager.lightGrey,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ColorManager.lightPrimary,
      onPrimary: ColorManager.lightSecondary,
      secondary: ColorManager.lightSecondary,
      onSecondary: ColorManager.lightPrimary,
      error: ColorManager.error,
      onError: ColorManager.lightPrimary,
      surface: ColorManager.lightPrimary,
      onSurface: ColorManager.lightSecondary,
    ),
    cardTheme: CardTheme(
      color: ColorManager.white,
      shadowColor: ColorManager.lightSecondary,
      elevation: AppSize.s4.r,
    ),
    appBarTheme: AppBarTheme(
      color: ColorManager.lightPrimary,
      centerTitle: true,
      elevation: AppSize.s4.r,
      shadowColor: ColorManager.lightSecondary,
      titleTextStyle: TextStyle(
        fontFamily: FontConstants.meQuranFontFamily,
        fontWeight: FontWeightsManager.medium,
        color: ColorManager.primary,
        wordSpacing: AppSize.s5.w,
        letterSpacing: AppSize.s0_1.w,
      ),
      iconTheme: const IconThemeData(
        color: ColorManager.white,
      ),
    ),

    iconTheme: IconThemeData(color: ColorManager.black, size: AppSize.s24.r),

    buttonTheme: const ButtonThemeData(
      shape: StadiumBorder(),
      buttonColor: ColorManager.lightPrimary,
      disabledColor: ColorManager.lightGrey,
      splashColor: ColorManager.primary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.lightPrimary,
        disabledBackgroundColor: ColorManager.lightGrey,
        foregroundColor: ColorManager.primary,
        disabledForegroundColor: ColorManager.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s14.r),
        ),
        textStyle: getSemiBoldStyle(fontSize: FontSize.s14.r),
      ),
    ),
    textTheme: TextTheme(
      displayLarge:
          getBoldStyle(fontSize: FontSize.s32, color: ColorManager.primary),
      displayMedium:
          getBoldStyle(fontSize: FontSize.s28, color: ColorManager.primary),
      displaySmall:
          getBoldStyle(fontSize: FontSize.s24, color: ColorManager.primary),

      //Headline
      headlineLarge:
          getSemiBoldStyle(fontSize: FontSize.s20, color: ColorManager.primary),
      headlineMedium:
          getSemiBoldStyle(fontSize: FontSize.s18, color: ColorManager.primary),
      headlineSmall:
          getSemiBoldStyle(fontSize: FontSize.s16, color: ColorManager.primary),

      //Title
      titleLarge:
          getMediumStyle(fontSize: FontSize.s20, color: ColorManager.black),
      titleMedium:
          getMediumStyle(fontSize: FontSize.s18, color: ColorManager.black),
      titleSmall:
          getMediumStyle(fontSize: FontSize.s16, color: ColorManager.black),

      //Body
      bodyLarge:
          getRegularStyle(fontSize: FontSize.s18, color: ColorManager.black),
      bodyMedium:
          getRegularStyle(fontSize: FontSize.s16, color: ColorManager.black),
      bodySmall:
          getRegularStyle(fontSize: FontSize.s14, color: ColorManager.black),

      //label
      //text button
      labelLarge:
          getRegularStyle(fontSize: FontSize.s14, color: ColorManager.primary),
      //button label
      labelMedium:
          getRegularStyle(fontSize: FontSize.s12, color: ColorManager.primary),
      //caption
      labelSmall: getRegularStyle(
        fontSize: FontSize.s10,
        color: ColorManager.lightGrey,
      ),
    ),

    //input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(AppPadding.p8.w),
      hintStyle: getRegularStyle(
        fontSize: FontSize.s12,
        color: ColorManager.lightGrey,
      ),
      labelStyle: getMediumStyle(
        fontSize: FontSize.s12,
        color: ColorManager.lightGrey,
      ),
      errorStyle: getRegularStyle(
        fontSize: FontSize.s10,
        color: ColorManager.error,
      ),

      //enabled border style
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.lightGrey,
          width: AppSize.s1_5.r,
        ),
        borderRadius: BorderRadius.circular(AppSize.s8.r),
      ),

      //focused border style
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.lightPrimary,
          width: AppSize.s1_5.r,
        ),
        borderRadius: BorderRadius.circular(AppSize.s8.r),
      ),

      //error border style
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.error,
          width: AppSize.s1_5.r,
        ),
        borderRadius: BorderRadius.circular(AppSize.s8.r),
      ),
    ),
  );
}
