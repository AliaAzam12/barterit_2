import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'config.dart';
import 'model/product.dart';
import 'model/user.dart';

class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameEditingController = TextEditingController();
final TextEditingController _emailditingController = TextEditingController();
final TextEditingController _phoneEditingController = TextEditingController();
final TextEditingController _passEditingController = TextEditingController();
final TextEditingController _pass2EditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

@override
  void initState() {
    super.initState();
    _nameEditingController.text = widget.user.name.toString();
    _emailditingController.text = widget.user.email.toString();
    _phoneEditingController.text = widget.user.phone.toString();
     _passEditingController.text = widget.user.password.toString();
    _pass2EditingController.text = widget.user.password.toString();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 8,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
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
                        textInputAction: TextInputAction.next,
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
                        textInputAction: TextInputAction.next,
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
                        textInputAction: TextInputAction.next,
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
                        textInputAction: TextInputAction.next,
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

                      ElevatedButton(onPressed: editdialog, 
                      child: const Text("Save", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))
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

 void editdialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    String pass1 = _passEditingController.text;
    String pass2 = _pass2EditingController.text;
    if(pass1 != pass2){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password not match")));
      return;
    }

    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          title: const Text(
            "Update your profile?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              onPressed: (){
                Navigator.of(context).pop();
                editProfile();
              },),
              TextButton(
                child: const Text("No", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                onPressed: (){
                  Navigator.of(context).pop();
                },)
          ],
        );
      });
  }
  
  void editProfile() {
    String name = _nameEditingController.text;
    String email = _emailditingController.text;
    String phone = _phoneEditingController.text;
    String pass1 = _passEditingController.text;

    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/updateprofile.php"),
    body: {
      "userid": widget.user.id,
       "name": name, 
          "email": email, 
          "phone": phone, 
          "password": pass1,
    }).then((response){
      print(response.body);
      if (response.statusCode == 200){
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success'){
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
          Navigator.pop(context);
        } else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else{
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
  }
}