import 'dart:io';
import 'package:barterit_2/deleteproduct.dart';
import 'package:barterit_2/editproduct.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'config.dart';
import 'model/product.dart';
import 'model/user.dart';

class SellerDetailScreen extends StatefulWidget {
  final Product product;
  final User user;
  const SellerDetailScreen({super.key, required this.product, required this.user});

  @override
  State<SellerDetailScreen> createState() => _SellerDetailScreenState();
}

class _SellerDetailScreenState extends State<SellerDetailScreen> {
  late double screenHeight, screenWidth, cardWidth;
  int qty = 0;
  int userqty = 0;
  double totalprice = 0.0;
  double price = 0.0;

  @override
  void initState(){
    super.initState();
    qty = int.parse(widget.product.prqty.toString());
    totalprice = double.parse(widget.product.prprice.toString());
    price = double.parse(widget.product.prprice.toString());
  }

  //final df = DateFormat('dd-MM-yyyy HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, 
                MaterialPageRoute(builder: (content) =>  
                EditProduct(user: widget.user,
                            product: widget.product,)));
              },
              icon: const Icon(Icons.edit)),
              IconButton(
              onPressed: (){
                Navigator.push(context, 
                MaterialPageRoute(builder: (content) =>  
                DeleteProduct(user: widget.user,
                            product: widget.product,)));
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: Container(
                  width: screenWidth,
                  child: CachedNetworkImage(
                    width: screenWidth,
                    fit: BoxFit.cover,
                    imageUrl: "${MyConfig().SERVER}/barter_it/images/product/${widget.product.prid}.jpg",
                    placeholder: (context, url) => const LinearProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                ),
              ),)),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.product.prname.toString(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 0, 0)),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Table(
                    columnWidths: const{
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(6),
                    },
                    children: [
                      TableRow(
                        children: [
                          const TableCell(
                            child: Text("Description :",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),)),
                            TableCell(
                              child: Text(widget.product.prdesc.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 18),)),
                        ]
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Text("Quantity :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                          )),
                          TableCell(
                              child: Text(widget.product.prqty.toString(), 
                              style: const TextStyle(color: Colors.white, fontSize: 18),)),
                        ]
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Text("Location :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                          )),
                          TableCell(
                              child: Text("${widget.product.prloc}/${widget.product.prstate}", 
                              style: const TextStyle(color: Colors.white, fontSize: 18),)),
                        ]
                      ),
                      /*TableRow(
                        children: [
                          const TableCell(
                            child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          TableCell(
                              child: Text(df.format(DateTime.parse(widget.product.prdate.toString()))),
                      )]
                      ),*/
                    ],
                  ),
                )),

                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: (){
                          if(userqty <= 1){
                            userqty = 1;
                            totalprice = price * userqty;
                          } else{
                            userqty = userqty - 1;
                            totalprice = price * userqty;
                          }
                          setState(() {});
                        }, 
                        icon: const Icon(Icons.remove)),
                        Text(
                          userqty.toString(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: (){
                            if(userqty <= 1){
                            userqty = 1;
                            totalprice = price * userqty;
                          } else{
                            userqty = userqty - 1;
                            totalprice = price * userqty;
                          }
                          setState(() {});
                          }, 
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                ),

                Text("RM ${totalprice.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),),
                /*ElevatedButton(
                  onPressed: (){
                    addtocart();
                  }, 
                  child: const Text("Add to Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
      )*/
      ],
      ),
    );
  }
  
  void addtocart() {}
}