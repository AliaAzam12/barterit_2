import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'config.dart';
import 'model/product.dart';
import 'model/user.dart';

class DeleteProduct extends StatefulWidget {
  final User user;
  final Product product;
  const DeleteProduct({super.key, required this.user, required this.product});

  @override
  State<DeleteProduct> createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  File? _image;
  var pathAsset = "assets/images/cam.jpg";
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _prnameEditingController = TextEditingController();
  final TextEditingController _prdescEditingController = TextEditingController();
  final TextEditingController _prpriceEditingController = TextEditingController();
  final TextEditingController _prdelEditingController = TextEditingController();
  final TextEditingController _prqtyEditingController = TextEditingController();
  final TextEditingController _prstateEditingController = TextEditingController();
  final TextEditingController _prlocalEditingController = TextEditingController();
  bool _isChecked = false;
  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _prnameEditingController.text = widget.product.prname.toString();
    _prdescEditingController.text = widget.product.prdesc.toString();
    _prpriceEditingController.text = double.parse(widget.product.prprice.toString()).toStringAsFixed(2);
     _prdelEditingController.text = double.parse(widget.product.prdel.toString()).toStringAsFixed(2);
    _prqtyEditingController.text = widget.product.prqty.toString();
    _prstateEditingController.text = widget.product.prstate.toString();
    _prlocalEditingController.text = widget.product.prloc.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Product"),
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
                    errorWidget: (context, url, error) => const Icon(Icons.error),),
                ),
              ),)),
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                        ? "Product name must be longer than 3"
                        : null,
                        onFieldSubmitted: (v) {},
                          controller: _prnameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Product Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )
                          ),
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 10)
                        ? "Product description must be longer than 10"
                        : null,
                        onFieldSubmitted: (v) {},
                          controller: _prdescEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Product Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.note),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )
                          ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                        ? "Product price must contain value"
                        : null,
                        onFieldSubmitted: (v) {},
                          controller: _prpriceEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Product Price',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.money),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )
                          ),
                            )),
                            Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty
                        ? "Quantity should be more than 0"
                        : null,
                          controller: _prqtyEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Product Quantity',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.ad_units),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )
                          ),
                            )),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                        ? "State"
                        : null,
                        enabled: false,
                          controller: _prstateEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'States',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.flag),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )
                          ),
                            )),
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                              enabled: false,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                        ? "Locality"
                        : null,
                          controller: _prlocalEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Locality',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.map),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )
                          ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty 
                        ? "Must be more than 0"
                        : null,
                          controller: _prdelEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Delivery charge/km',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.delivery_dining),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )
                          ),
                            )),
                            Flexible(
                            flex: 5,
                            child: CheckboxListTile(
                              title: const Text("Legal Item?", style: TextStyle(color: Colors.white),),
                              value: _isChecked,
                              onChanged: (bool? value){
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            )),
                        ],
                      ),
                      const SizedBox(height: 16,),

                      SizedBox(
                        width: screenWidth / 1.2,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (){
                            deleteDialog();
                          }, 
                          child: const Text("Delete", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  )),
              ),))
              
        ],
      ),
    );
  }
  
  void deleteDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
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
            "Delete you product?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              onPressed: (){
                Navigator.of(context).pop();
                deleteProduct();
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
  
  void deleteProduct() {
     ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Deleting product.."),
        title: const Text("Processing..."));
    progressDialog.show();
    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/delete_product.php"),
        body: {
          "prid": widget.product.prid,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
              progressDialog.dismiss();
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        progressDialog.dismiss();
        return;
      }
    });
  }
  
}