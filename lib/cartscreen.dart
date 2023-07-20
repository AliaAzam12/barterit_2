import 'package:barterit_2/billscreen.dart';
import 'package:barterit_2/model/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'model/cart.dart';

class CartScreen extends StatefulWidget {
  final User user;
  const CartScreen({super.key, required this.user});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> cartList = <Cart> [];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  double totalprice = 0.0;

   @override
  void initState() {
    super.initState();
    loadcart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Column(
        children: [
          cartList.isEmpty
          ? Container()
          : Expanded(
            child: ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          width: screenWidth / 3,
                          fit: BoxFit.cover,
                          imageUrl: "${MyConfig().SERVER}/barter_it/images/product/${cartList[index].prid}.jpg",
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),),
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  cartList[index].prname.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                     MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        if(int.parse(cartList[index].cartqty.toString()) <= 1){
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("Quantity less than 1")));
                                        }else{
                                          int newqty = int.parse(cartList[index].cartqty.toString()) - 1;
                                          double newprice = double.parse(cartList[index].prprice.toString()) * newqty;
                                          updateCart(index, newqty, newprice);
                                        }
                                        setState(() {
                                          
                                        });
                                      }, 
                                      icon: const Icon(Icons.remove)),
                                      Text(cartList[index].cartqty.toString()),
                                      IconButton(
                                        onPressed: (){
                                          if(int.parse(cartList[index].prqty.toString()) >
                                          int.parse(cartList[index].cartqty.toString())) {
                                            int newqty = int.parse(cartList[index].cartqty.toString()) + 1;
                                            double newprice = double.parse(cartList[index].prprice.toString()) * newqty;
                                            updateCart(index, newqty, newprice);
                                          } else{
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text("Quantity not available")));
                                          }
                                        }, 
                                        icon: const Icon(Icons.add))
                                  ],
                                ),
                                Text("RM ${double.parse(cartList[index].cartprice.toString()).toStringAsFixed(2)}")
                              ],
                            ),)),
                            IconButton(
                              onPressed: (){
                                deletedialog(index);
                              }, 
                              icon: const Icon(Icons.delete))
                      ],
                    ),),
                );
              })),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Price RM ${totalprice.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(context,
                        MaterialPageRoute(
                          builder: (content) => BillScreen(
                            user: widget.user,
                            totalprice: totalprice,
                          )));
                          loadcart();
                      }, 
                      child: const Text("Check Out"))
                    ],
                  ),
                ),)
        ],
      ),
    );
  }
  
  Future <void> loadcart()async {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/loadcart.php"),
    body: {
      "pridowner": widget.user.id,
    }).then((response){
      print(response.body);
      cartList.clear();
      if(response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if(jsondata['status'] == "success"){
          var extractdata = jsondata['data'];
          if(extractdata['products'] != null){
            print("success");
            setState(() {
              cartList = List <Cart>.from(
                extractdata['carts'].map((toolJson) => Cart.fromJson(toolJson)),
              );
              //print(cartList[0].prname);
            });
            totalprice = 0.0;
            for (var element in cartList) {
            totalprice =
                totalprice + double.parse(element.cartprice.toString());
            //print(element.catchPrice);
          }
          }
          /*var extractdata = jsondata['data'];
          extractdata['carts'].forEach((v) {
            cartList.add(Cart.fromJson(v));
            // totalprice = totalprice +
            //     double.parse(extractdata["carts"]["cart_price"].toString());
          });
          totalprice = 0.0;
          cartList.forEach((element) {
            totalprice = totalprice + double.parse(element.cartprice.toString());
          });*/
        }else{
          Navigator.of(context).pop();
        }
        setState(() {
          
        });
      }
    });
  }
  
  void updateCart(int index, int newqty, double newprice) {
     http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/updatecart.php"),
        body: {
          "cartid": cartList[index].cartid,
          "newqty": newqty.toString(),
          "newprice": newprice.toString()
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          loadcart();
        } else {}
      } else {}
    });
  }
  
  void deletedialog(int index) {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          title: const Text("Delete this product?", style: TextStyle(color: Colors.white),),
          content: const Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
                deletecart(index);
              }, 
              child: const Text("Yes", style: TextStyle(color: Colors.white)),),

              TextButton(
                onPressed: (){
                Navigator.of(context).pop();
              },  
                child: const Text("No", style: TextStyle(color: Colors.white)),),
          ],
        );

      });
  }
  
  void deletecart(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/deletecart.php"),
    body: {
      "cartid": cartList[index].cartid,
    }).then((response) {
      print(response.body);
      if(response.statusCode == 200){
        var jsondata = jsonDecode(response.body);
        if(jsondata['status'] == 'success'){
          loadcart();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
        }else{
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
      }else{
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Delete Failed")));
      }
    });
  }
}