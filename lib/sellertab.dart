import 'dart:convert';
import 'dart:developer';

import 'package:barterit_2/cartscreen.dart';
import 'package:barterit_2/newproduct.dart';
import 'package:barterit_2/sellerdetailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit_2/model/product.dart';
import 'package:barterit_2/model/user.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:barterit_2/config.dart';

//for buyer screen

class SellerTab extends StatefulWidget {
  final User user;
  const SellerTab({super.key, required this.user});

  @override
  State<SellerTab> createState() => _SellerTabState();
}

class _SellerTabState extends State<SellerTab> {
  String maintitle = "Seller";
  List<Product> productList = <Product>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  int noPage = 1, currPage = 1;
  int numberofresult = 0;
  var color;
  int cartqty = 0;

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadProduct();
    print("Seller");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        actions: [
          IconButton(
              onPressed: () {
                showsearchDialog();
              },
              icon: const Icon(Icons.search)),
          TextButton.icon(
            icon: const Icon(
              Icons.shopping_cart, color: Colors.white,
            ), // Your icon here
            label: Text(cartqty.toString()), // Your text here
            onPressed: () {
              if (cartqty > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CartScreen(
                              user: widget.user,
                            )));
                            loadProduct();
              }else{
                 ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No item in cart")));
              }
            },
          )
          
        ],
      ),
      body: productList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Container(
                height: 20,
                alignment: Alignment.center,
                child: Text(
                  "$numberofresult Product Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        productList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onTap: () async {
                                Product product =
                                    Product.fromJson(productList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            SellerDetailScreen(
                                              user: widget.user,
                                              product: product,
                                            )));
                                loadProduct();
                              },
                              child: Column(children: [
                                CachedNetworkImage(
                                  height: 100,
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${MyConfig().SERVER}/barter_it/images/product/${productList[index].prid}.jpg",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  productList[index].prname.toString(),
                                  style: const TextStyle(fontSize: 20, color: Colors.white),
                                ),
                                Text(
                                  "RM ${double.parse(productList[index].prprice.toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  "${productList[index].prqty} available",
                                  style: const TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ]),
                            ),
                          );
                        },
                      ))),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: noPage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    
                    if ((currPage - 1) == index) {
                      
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return TextButton(
                        onPressed: () {
                          currPage = index + 1;
                          loadProduct();
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ));
                  },
                ),
              ),
            ]),
            floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: "New Product",
            labelStyle: const TextStyle(fontSize: 24, color: Colors.white),
            onTap: () => newProduct(),
          ),
        ],
      ),
    );
  }

   Future <void> loadProduct() async {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/loadproduct.php"),
        body: {
          "userid": widget.user.id,
          "pageno": currPage.toString()
        }).then((response) {
      //print(response.body);
      log(response.body);
      productList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          if(extractdata['products'] != null){
            print("success");
            setState(() {
              noPage = int.parse(jsondata['noPage']); //get number of pages
              numberofresult = int.parse(jsondata['noResult']);
              print(numberofresult);
              cartqty = int.parse(jsondata['cartqty'].toString());
              print(cartqty);
              productList = List <Product>.from(
                extractdata['products'].map((toolJson) => Product.fromJson(toolJson)),
              );
              print(productList[0].prname);
            });
          }
 
        }
       
      }
    });
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Search?",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchProduct(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future <void> searchProduct(String search) async {
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/loadproduct.php"),
        body: {
          "cartuserid": widget.user.id,
          "search": search
        }).then((response) {
      //print(response.body);
      log(response.body);
      productList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          if(extractdata['products'] != null){
            print("success");
            setState(() {
              noPage = int.parse(jsondata['noPage']); //get number of pages
              numberofresult = int.parse(jsondata['noResult']);
              print(numberofresult);
              cartqty = int.parse(jsondata['cartqty'].toString());
              print(cartqty);
              productList = List <Product>.from(
                extractdata['products'].map((toolJson) => Product.fromJson(toolJson)),
              );
              print(productList[0].prname);
            });
          }
        }
      
      }
    });
  }
  
  void newProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>  NewProductScreen(user: widget.user,)));
  }
}

