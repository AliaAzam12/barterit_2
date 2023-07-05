import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.anaheimTextTheme(
          Theme.of(context).textTheme.apply(),
        )
      ),
      home: const SplashScreen(),
    );
  }
}