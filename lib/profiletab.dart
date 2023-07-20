import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:barterit_2/editprofile.dart';
import 'package:barterit_2/model/user.dart';
import 'package:barterit_2/registerscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'config.dart';
import 'loginscreen.dart';
import 'package:http/http.dart' as http;

import 'model/product.dart';

class ProfileTab extends StatefulWidget {
  final User user;
  const ProfileTab({super.key, required this.user});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  String maintitle = "Profile";
  int _currIndex = 0;
  late List<Widget> tabchildren;
  late double screenHeight, screenWidth, cardwitdh;
  File? _image;
  Random random = Random();
  var val = 50;
  bool isDisable = false;

  @override
  void initState(){
    super.initState();
    print("Profile");
  }

  @override
  void dispose(){
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text(maintitle),),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                            image: AssetImage("assets/images/profile.png"))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.teal[200]),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.user.name.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
              Text(widget.user.email.toString(), style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text("Phone: ${widget.user.phone.toString()}", style: const TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(height: 20),

              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async{
                    await Navigator.push(context,
                    MaterialPageRoute(
                      builder: (content)=> EditProfile(
                        user: widget.user)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                      side: BorderSide.none, shape: const StadiumBorder()),
                  child: const Text("Edit Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScreen(),
                      ),
                    );
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.indigo,
                    ),
                    child: const Icon(Icons.login, color: Colors.white),
                  ),
                  title: const Text("Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.arrow_right_alt_sharp,
                        size: 18.0, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const RegisterScreen(),
                      ),
                    );
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.indigo,
                    ),
                    child: const Icon(Icons.app_registration, color: Colors.white),
                  ),
                  title: const Text("Registration",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.arrow_right_alt_sharp,
                        size: 18.0, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: () {
                    /*Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const RegisterScreen(),
                      ),
                    );*/
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.indigo,
                    ),
                    child: const Icon(Icons.settings, color: Colors.white),
                  ),
                  title: const Text("Setting",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.arrow_right_alt_sharp,
                        size: 18.0, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    /*body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Flexible(
          flex: 4,
          child: Card(
            elevation: 10,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    shrinkWrap: true,
                    children:  [
                      MaterialButton(
                    onPressed: (){
                      Navigator.push(context, 
      MaterialPageRoute(builder: (content) => const RegisterScreen()));
                    },
                    child: const Text("REGISTER",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                   const Divider(
                    height: 2,
                  ),

                   MaterialButton(
                    onPressed: (){
                      Navigator.push(context, 
      MaterialPageRoute(builder: (content) => const LoginScreen()));
                    },
                    child: const Text("LOG IN",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                   const Divider(
                    height: 2,
                  ),
                    ],
                  )
                  ),
              ], 
            ),
          ),
        )
      ]),
      //child: Text(maintitle),
    )*/
  
  }
  