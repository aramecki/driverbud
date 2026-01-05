import 'package:flutter/material.dart';
import 'package:mycargenie_2/theme/colors.dart';

ThemeData lightTheme = getTheme(true);
ThemeData darkTheme = getTheme(false);

ThemeData getTheme(bool isLight) {
  Color foregroundColor = Colors.deepOrange;
  Color backgroundColor = Colors.black;
  Color textColor = Colors.white;
  Color dividerColor = darkGrey;
  Color iconColor = lightGrey;

  if (isLight) {
    backgroundColor = Colors.white;
    textColor = Colors.black;
    dividerColor = lightGrey;
    iconColor = middleGrey;
  }

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.dark(
      primary: foregroundColor,
      //secondary: Colors.deepOrangeAccent,
      surface: backgroundColor,
      onSurface: textColor,
    ),

    iconTheme: IconThemeData(color: iconColor),

    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    ),

    // App bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: foregroundColor,
      ),
      iconTheme: IconThemeData(size: 30, color: foregroundColor),
      actionsIconTheme: IconThemeData(size: 30, color: foregroundColor),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: lightGrey,
    ),

    // Generic button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: foregroundColor,
        foregroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        iconColor: iconColor,
        side: BorderSide(color: foregroundColor, width: 2),
        textStyle: TextStyle(fontSize: 16, color: textColor),
      ),
    ),

    // Dropdown menu theme
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: textColor),
        labelStyle: TextStyle(color: textColor),
        hintStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return TextStyle(color: darkGrey);
          }
          return TextStyle(color: textColor);
        }),
        suffixIconColor: textColor,
      ),
      menuStyle: MenuStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: foregroundColor, width: 1.5),
          ),
        ),
      ),
      textStyle: TextStyle(color: textColor),
    ),

    // Single button in dropdown menu theme
    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all<Color>(foregroundColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 16, color: textColor),
        ),
      ),
    ),

    menuTheme: MenuThemeData(
      style: MenuStyle(
        elevation: const WidgetStatePropertyAll(6),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: foregroundColor, width: 1.5),
          ),
        ),
      ),
    ),

    // Dropdown button theme
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: foregroundColor, width: 2.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: darkGrey, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: foregroundColor, width: 2.0),
      ),
      labelStyle: TextStyle(color: textColor),
      hintStyle: TextStyle(color: textColor),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: alphaGrey,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: foregroundColor,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          );
        }
        return TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.normal,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: foregroundColor, size: 34);
        }
        return IconThemeData(color: textColor, size: 30);
      }),
      labelPadding: EdgeInsets.symmetric(vertical: 0),
      indicatorColor: Colors.transparent,
      elevation: 0,
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (states) => states.contains(WidgetState.selected)
            ? Colors.transparent
            : foregroundColor,
      ),
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (states) => states.contains(WidgetState.selected)
            ? foregroundColor
            : Colors.transparent,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
        (states) => states.contains(WidgetState.selected)
            ? backgroundColor
            : foregroundColor,
      ),
    ),

    // Divider theme
    dividerTheme: DividerThemeData(
      color: dividerColor,
      thickness: 1.5,
      radius: BorderRadius.circular(30.0),
    ),

    //ListTile theme
    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: middleGrey,
      ),
      leadingAndTrailingTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: middleGrey,
      ),
      enableFeedback: true,
    ),

    dialogTheme: DialogThemeData(
      iconColor: foregroundColor,
      titleTextStyle: TextStyle(fontSize: 18, color: textColor),
    ),
  );
}
