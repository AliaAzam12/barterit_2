import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

final TextEditingController _nameEditingController = TextEditingController();
final TextEditingController _emailditingController = TextEditingController();
final TextEditingController _phoneEditingController = TextEditingController();
final TextEditingController _passEditingController = TextEditingController();
final TextEditingController _pass2EditingController = TextEditingController();
//bool _checked = false;
final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/registerbg.jpg',width: 1000),
            

            Card(
              elevation: 8,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Register", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                      TextFormField(
                        controller: _nameEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                        ? "name must be longer than 3" : null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.person),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )
                        ),
                      ),
                      TextFormField(
                         validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".")
                        ? "enter a valid email"
                        : null,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailditingController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.mail),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )
                        ),
                      ),
                      TextFormField(
                        validator: (val) => val!.isEmpty || (val.length < 10)
                        ? "phone must be longer or equal than 10" : null,
                        keyboardType: TextInputType.phone,
                        controller: _phoneEditingController,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.phone),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )
                        ),
                      ),
                      TextFormField(
                        validator: (val) => val!.isEmpty || (val.length < 5)
                        ? "passwordd must be longer than 5" : null,
                        obscureText: true,
                        controller: _passEditingController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.lock),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )
                        ),
                      ),
                      TextFormField(
                        validator: (val) => val!.isEmpty || (val.length < 5)
                        ? "password must be longer than 5" : null,
                        obscureText: true,
                        controller: _pass2EditingController,
                        decoration: const InputDecoration(
                          labelText: 'Re-enter Password',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.lock),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )
                        ),
                      ),

                      ElevatedButton(onPressed: _registerDialog, 
                      child: const Text("Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))
                    ],))
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  void _registerDialog() {
    if(!_formKey.currentState!.validate()){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incomplete")));
      return;
    }

    String pass1 = _passEditingController.text;
    String pass2 = _pass2EditingController.text;
    if(pass1 != pass2){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password not match")));
      return;
    }

    showDialog(context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text("Register New Account?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
          content: const Text("Are you sure?",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes", style: TextStyle(color: Colors.white),),
              onPressed: (){
                Navigator.of(context).pop();
                register();
              },
          ),
          TextButton(
              child: const Text("No", style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.of(context).pop();
              },
          ),
          ],
      );
    }
    );
  }
  
  void register() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registration..."),
        );
      },
    );

    String name = _nameEditingController.text;
    String email  = _emailditingController.text;
    String phone = _phoneEditingController.text;
    String pass1 = _passEditingController.text;
     print(name+ " "+email+" "+phone+ " "+ pass1);
   

     http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/register.php"),
        body: {
          "name": name, 
          "email": email, 
          "phone": phone, 
          "password": pass1})
    .then((response) {
      print(response.body);
   
           
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        if(data['status'] == 'success'){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Success"))
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Failed"))
          );
        }
        Navigator.pop(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Failed")));
          Navigator.pop(context);
      }
      
    });
    }  
  }