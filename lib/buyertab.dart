import 'package:barterit_2/model/user.dart';
import 'package:flutter/material.dart';

class BuyerTab extends StatefulWidget {
  final User user;
  const BuyerTab({Key? key, required this.user}): super(key: key);
  
  @override
  State<BuyerTab> createState() => _BuyerTabState();
}

class _BuyerTabState extends State<BuyerTab> {
  String maintitle = "Buyer";
  int _currIndex = 2;

  @override
  void initState(){
    super.initState();
    print("Buyer");
  }

  @override
  void dispose(){
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(maintitle),
    );
  }
}