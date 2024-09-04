import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:market_mobile/pages/login/login_page.dart';

OutlineInputBorder boxStyle() => OutlineInputBorder(
    borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16));
void main() {
  runApp(
    MaterialApp(
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 243, 236, 245),
          foregroundColor: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color.fromARGB(255, 243, 236, 245),
          enabledBorder: boxStyle(),
          focusedBorder: boxStyle(),
          errorBorder: boxStyle(),
          disabledBorder: boxStyle(),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    ),
  );
}
