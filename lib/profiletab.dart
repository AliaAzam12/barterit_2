import 'package:barterit_2/model/user.dart';
import 'package:barterit_2/registerscreen.dart';
import 'package:flutter/material.dart';
import 'loginscreen.dart';

class ProfileTab extends StatefulWidget {
  final User user;
  const ProfileTab({Key? key, required this.user}): super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String maintitle = "Profile";
  int _currIndex = 0;

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
    return Center(
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
    );
  }

}