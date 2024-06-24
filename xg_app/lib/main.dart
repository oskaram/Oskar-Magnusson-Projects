import 'package:flutter/material.dart';
import './homepage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xG Calculator',
      theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme()),
      home: const MyHomePage(title: 'xG Calculator'),
    );
  }
}
