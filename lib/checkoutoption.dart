import 'package:barterit_2/stripehelper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'model/product.dart';
import 'model/user.dart';

class CheckOutOption extends StatefulWidget {
  final User user;
  final Product product;
  const CheckOutOption({super.key, required this.user, required this.product});

  @override
  State<CheckOutOption> createState() => _CheckOutOptionState();
}

class _CheckOutOptionState extends State<CheckOutOption> {
  Map<String, dynamic>? paymentIntent;
  int groupValue=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Out"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 36,
            ),
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 3.0),
              ),
              child: Row(
                children: [
                  Radio(value: 1, groupValue: groupValue, onChanged: (value){
                    setState(() {
                      groupValue=value!;
                    });
                  },),
                  const Icon(Icons.money),
                  const SizedBox(width: 12,),
                  const Text("Cash on Delivery", 
                  style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            const SizedBox(
              height: 24),
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(width: 3.0),
              ),
              child: Row(
                children: [
                  Radio(value: 2, groupValue: groupValue, onChanged: (value){
                    setState(() {
                      groupValue=value!;
                    });
                  },),
                  const Icon(Icons.money),
                  const SizedBox(width: 12,),
                  const Text("Online Payment", 
                  style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            const SizedBox(height: 24,),
            ElevatedButton(
              onPressed: ()async {
                if(groupValue == 1){
                  Fluttertoast.showToast(
                     msg: "Order Success",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     fontSize: 16);
                }else{
                  final prprice = (widget.product.prprice)! * 100;
                  bool isSuccessfullyPayment = await StripeHelper.instance.makePayment(prprice.toString());
                  /*if(isSuccessfullyPayment){
                    Fluttertoast.showToast(
                     msg: "Payment Success",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     timeInSecForIosWeb: 1,
                     fontSize: 16);
                  }*/
                }

              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text("Continue", style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}

