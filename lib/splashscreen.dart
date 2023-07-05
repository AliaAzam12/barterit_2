import 'dart:async';
import 'dart:convert';
import 'package:barterit_2/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'model/user.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    checkAndLogin();
    //Timer(
      //const Duration(seconds: 3),
      //() => Navigator.pushReplacement(context, 
     // MaterialPageRoute(builder: (content) => const MainScreen(user: user))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash.jpg'),
                fit: BoxFit.cover
                )
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const[
                  Text(
                    "BARTERIT",
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  CircularProgressIndicator(),
                  Text(
                    "Version 3.0",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )

        ],
      ),
    );
  }
  
  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pas')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;

    if(ischeck){
      try{
        http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/login.php"),
        body: {
          "email": email,
          'password': password,
        }).then((response){
          if(response.statusCode == 200){
            var data = jsonDecode(response.body);
            user = User.fromJson(data['data']);
            Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (content) => MainScreen(user: user)))
            );
          }else{
            user = User(
              id: "na",
              name: "na", 
              email: "na", 
              phone: "na", 
              password: "na", 
              datereg: "na");

            Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (content) => MainScreen(user: user,))));
          }
          }).timeout(const Duration(seconds: 5), onTimeout: () {
          // Time has run out, do what you wanted to do.
        });
      } on TimeoutException catch (_) {
        print("Time out");
      }
    } else {
      user = User(
          id: "na",
          name: "na",
          email: "na",
          phone: "na",
          datereg: "na",
          password: "na",);
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
        }
      }
    }