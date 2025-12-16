import 'package:flutter/material.dart';
import 'package:mycargenie_2/theme/colors.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.deepOrange,
    secondary: Colors.deepOrangeAccent,
    surface: Colors.white,
    onPrimary: Colors.black,
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),

  // App bar theme
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.deepOrange,
    ),
    iconTheme: IconThemeData(size: 30, color: Colors.deepOrange),
    actionsIconTheme: IconThemeData(size: 30, color: Colors.deepOrange),
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.grey[100],
  ),

  // Generic button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
  ),

  // Outlined button theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.black,
      side: BorderSide(color: Colors.deepOrange, width: 2),
      // minimumSize: Size(double.infinity, 55),
      // alignment: AlignmentGeometry.directional(-1.2, 0),
      textStyle: TextStyle(
        fontSize: 18,
        color: Colors.black,
        // fontWeight: FontWeight.w400
      ),
    ),
  ),

  // Dropdown menu theme(not button)
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      //backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(color: Colors.deepOrange, width: 1.5),
        ),
      ),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      ),
      fixedSize: WidgetStatePropertyAll(Size.fromWidth(200)),
    ),
  ),

  // Single button in dropdown menu theme
  menuButtonTheme: MenuButtonThemeData(
    style: ButtonStyle(
      //backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
      overlayColor: WidgetStateProperty.all<Color>(Colors.grey),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          //side: const BorderSide(color: Colors.deepOrange, width: 1.5),
        ),
      ),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    ),
  ),

  menuTheme: MenuThemeData(
    style: MenuStyle(
      // backgroundColor: const WidgetStatePropertyAll(Color(0xFF1E1E1E)),
      elevation: const WidgetStatePropertyAll(6),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(color: Colors.deepOrange, width: 1.5),
        ),
      ),
    ),
  ),

  // Dropdown button theme
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.deepOrange, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
    ),
    hintStyle: TextStyle(color: Colors.black),
    // focusedBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(50.0),
    //   borderSide: const BorderSide(color: Colors.green, width: 2.5),
    // ),
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: alphaGrey,
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.selected)) {
        return const TextStyle(
          color: Colors.deepOrange,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        );
      }
      return const TextStyle(
        color: Colors.black,
        fontSize: 10,
        fontWeight: FontWeight.normal,
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((
      Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: Colors.deepOrange, size: 34);
      }
      return const IconThemeData(color: Colors.black, size: 30);
    }),
    labelPadding: EdgeInsets.symmetric(vertical: 0),
    indicatorColor: Colors.transparent,
    elevation: 0,
  ),

  // Switch theme
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith<Color?>(
      (states) => states.contains(WidgetState.selected)
          ? Colors.deepOrange
          : Colors.transparent,
    ),
    trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
      (states) => states.contains(WidgetState.selected)
          ? Colors.transparent
          : Colors.black,
    ),
  ),

  // Divider theme
  dividerTheme: DividerThemeData(
    color: (lightGrey),
    thickness: 1.5,
    radius: BorderRadius.circular(30.0),
  ),

  //ListTile theme
  listTileTheme: ListTileThemeData(
    titleTextStyle: TextStyle(
      color: Colors.black,
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
);
