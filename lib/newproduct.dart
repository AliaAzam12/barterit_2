import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'config.dart';
import 'model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class NewProductScreen extends StatefulWidget {
  final User user;
   const NewProductScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  String maintitle = "Seller";
  File? _image;
  var pathAsset = "assets/images/cam.jpg";
  double screenWidth = 0.0, screenHeight = 0.0;
  bool _isChecked = false;
  late Position currPosition;
  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

    final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final TextEditingController _prnameEditingController = TextEditingController();
  final TextEditingController _prdescEditingController = TextEditingController();
  final TextEditingController _prpriceEditingController = TextEditingController();
  final TextEditingController _prdelEditingController = TextEditingController();
  final TextEditingController _prqtyEditingController = TextEditingController();
  final TextEditingController _prstateEditingController = TextEditingController();
  final TextEditingController _prlocalEditingController = TextEditingController();

@override
  void initState() {
    super.initState();
    determinePosition();
  }
  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert New Product"), 
      ),
      body: Column(children: [
        Flexible(
          flex: 4,
          child: GestureDetector(
            onTap: selectImage,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _image == null
                      ? AssetImage(pathAsset)
                      : FileImage(_image!) as ImageProvider,
                      fit: BoxFit.scaleDown)
                  ),
                ),
              ),),
          )),

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
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus);
                        },
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
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus);
                        },
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
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus1);
                        },
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
                        focusNode: focus1,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus2);
                        },
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
                        focusNode: focus3,
                           onFieldSubmitted: (v) {
                           FocusScope.of(context).requestFocus(focus4);},
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

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(screenWidth, screenHeight / 13)
                        ),
                        child: const Text('Add Product',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        onPressed: () => {
                          newProductDialog(),
                        },
                      ),
                    ],
                  )),
              ),))
      ],),
    );
    
   
  }
  
  void searchDialog() {}
  
  void selectImage() {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Select from", style: TextStyle(color: Colors.white),),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth / 4, screenHeight / 6)
                ),
                child: const Text('Gallery'),
                onPressed: () => {
                  Navigator.of(context).pop(),
                  selectGallery(),
                },),

                ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth / 4, screenHeight / 6)
                ),
                child: const Text('Camera'),
                onPressed: () => {
                  Navigator.of(context).pop(),
                  selectCamera(),
                },),
            ],
          ),
        );
      });
  }
  
  void newProductDialog() {
    if(!_formKey.currentState!.validate()){
    Fluttertoast.showToast(
      msg: "Please fill in all information",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 14);
      return;
   }

   if(_image == null){
    Fluttertoast.showToast(
      msg: "Please take a product picture",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 14);
      return;
   }

   showDialog(
    context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text("Are you sure", style: TextStyle(),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                addNewProd();
              }, 
              child: const Text("Yes", style: TextStyle())),

              TextButton(
                child: const Text("No", style: TextStyle(),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
          ],
      );
    });
  }
  
  Future <void> selectGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800);

      if(pickedFile != null){
        _image = File(pickedFile.path);
        cropImage();
      }else{
        print('No image selected');
      }
  }
  
  Future <void> selectCamera( ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800);

      if(pickedFile != null){
        _image = File(pickedFile.path);
        cropImage();
      }else{
        print('No image selected');
      } 
  }
  
  
  Future <void> cropImage()async{
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blueAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio3x2,
          lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
          ),
      ]
      );

      if(croppedFile != null){
        File imageFile = File(croppedFile.path);
        _image = imageFile;
        int? sizeInBytes = _image?.lengthSync();
        double sizeInMb = sizeInBytes! / (1024 * 1024);
        print(sizeInMb);
        setState(() {
          
        });
      }
  }

  void determinePosition() async{
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error('Location service are disabled');
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('Location permission are denied');      
        }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error('Location permission are permanently denied');
    }
    currPosition = await Geolocator.getCurrentPosition();
    getAddress(currPosition);
  }
  
  getAddress(Position pos)async {
    List <Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if(placemarks.isEmpty){
      _prlocalEditingController.text = "Changlun";
      _prstateEditingController.text = "Kedah";
      prlat = "6.443455345";
      prlong = "100.05488449";
    }else{
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text = placemarks[0].administrativeArea.toString();
      prlat = currPosition.latitude.toString();
      prlong = currPosition.longitude.toString();
    }
    setState(() {
     
    });
  }

  void addNewProd(){
    String prname = _prnameEditingController.text;
    String prdesc = _prdescEditingController.text;
    String prprice = _prpriceEditingController.text;
    String prqty = _prqtyEditingController.text;
    String prdel = _prdelEditingController.text;
    String prstate = _prstateEditingController.text;
    String prloc = _prlocalEditingController.text;

    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
    message: const Text("Adding new product.."),
    title: const Text("Processing.."));
    progressDialog.show();

    String base64Image = base64Encode(_image!.readAsBytesSync());

    http.post(Uri.parse("${MyConfig().SERVER}/barter_it/php/new_product.php"),
    body: {
      "pridowner": widget.user.id,
      "prname": prname,
      "prdesc": prdesc,
      "prprice": prprice,
      "prqty": prqty,
      "prdel": prdel,
      "prstate": prstate,
      "prloc": prloc,
      "prlat": prlat,
      "prlong": prlong,
      "image": base64Image,
    }).then((response){
      print(response.body);

      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        if(data['status'] == 'success'){
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14);
            progressDialog.dismiss();
            Navigator.of(context).pop();
            return;
        }
      }else{
        Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14);
          progressDialog.dismiss();
          return;
      }
    } );
  }
}