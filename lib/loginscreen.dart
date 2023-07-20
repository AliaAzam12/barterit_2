//import 'dart:js';
import 'dart:convert';
import 'package:barterit_2/mainscreen.dart';
import 'package:barterit_2/registerscreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'config.dart';
import 'model/user.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

final TextEditingController _passEditingController = TextEditingController();
final TextEditingController _emailditingController = TextEditingController();
final _formKey = GlobalKey<FormState>();
bool _checked = false;

@override
void initState(){
  super.initState();
  loadPref();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/loginbg.jpg', width: 1000),
            Card(
              elevation: 8,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Log In", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Form(
                      key: _formKey,
                      child: Column(children: [
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

                      Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                      Checkbox(
                     value: _checked,
                     onChanged: (bool? value) {
                      _rememberMe(value!);
                    setState(() {
                      _checked = value;
             });
             },
            ),  
                    const Flexible(
                      child: Text('Remember me',
                      style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
             )),),
            MaterialButton(
              color: Colors.indigo,
             shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(5.0)),
             minWidth: 100,
             height: 35,
             child: const Text('Log In'),
             elevation: 10,
             onPressed: _login,
             ),
]),
                      ])
                    )
                  ]
                )
              )
            ),
            Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: <Widget>[
         const Text("Register new account? ",
         style: TextStyle(fontSize: 18, color: Colors.white)),
             GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const RegisterScreen()))
                  },
                  child: const Text(" Click here",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, color: Colors.orange
                        ),
                              ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ]
        )
      )
    );
  }

  void _login() {
     //FocusScope.of(context as BuildContext).requestFocus(FocusNode());
   if (!_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: "Please fill in the login credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
             
            fontSize: 16);
        return;
   }
   String email = _emailditingController.text;
    String pass = _passEditingController.text;
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/login.php"),
        body: {
          "email": email, 
          "password": pass})
          .then((response) {
          print(response.body);

          if(response.statusCode == 200){
            var data = jsonDecode(response.body);
            if(data['status'] == 'success'){
              User user = User.fromJson(data['data']);
              print(user.name);
              print(user.email);ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Success")));
              Navigator.pushReplacement(context, 
              MaterialPageRoute(
                builder: (content) => MainScreen(user: user,)));
            }else{
              ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Failed")));
            }
          }
        });
}
  void savepref(bool value) async {
  FocusScope.of(context as BuildContext).requestFocus(FocusNode());
  String email = _emailditingController.text;
  String password = _passEditingController.text;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if(value){
    if(!_formKey.currentState!.validate()){
      Fluttertoast.showToast(
        msg: "Please complete the login form",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16);
        _checked = false;
        return;
    }
    await prefs.setString('email', email);
    await prefs.setString('pass', password);
    Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
           
          fontSize: 16);
  }else{
    await prefs.setString('email', '');
    await prefs.setString('pass', '');
    setState(() {
        _emailditingController.text = '';
        _passEditingController.text = '';
        _checked = false;
      });
       Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
           
          fontSize: 16);
  }
}

void _rememberMe (bool newValue) => setState(() {
        _checked = newValue;
        if (_checked) {
          savepref(true);
        } else {
          savepref(false);
        }
      });
      
        Future <void> loadPref() async{
           SharedPreferences prefs = await SharedPreferences.getInstance();
           String email = (prefs.getString('email')) ?? '';
           String password = (prefs.getString('pass')) ?? '';
           if (email.length > 1) {
             setState(() {
              _emailditingController.text = email;
              _passEditingController.text = password;
              _checked = true;
      });
    }
  }

        }
