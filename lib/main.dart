import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51NUqYZJYHilDWI389VjtWrPQDjMU5tGvuMY5Jw3mLv9jTmeQisrmH9XYcfkfPS0bvf0urdBrMBkAcBhRrtr3sCiu003PuFxOyJ";
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