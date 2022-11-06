import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shrine/model/product.dart';

import 'home.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  String defaultImage = "";
  String defaultImamgeURL = "https://handong.edu/site/handong/res/img/logo.png";
  String pickedImageName = "";

  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  PickedFile? pickedFile;

  FirebaseStorage storage = FirebaseStorage.instance;
  bool isLoaded = false;
  List<String> url = [];

  Future getImageFromGalley() async {
    var image =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedFile = image!;
      if (pickedFile != null) isLoaded = true;
      url = pickedFile!.path.split("/");
      pickedImageName = url.last;
    });
    uploadFile();
  }
  @override
  void initState() {
    super.initState();

    _productNameController.text = widget.product.name;
    _priceController.text = "${widget.product.price}";
    _descriptionController.text = widget.product.description;
  }

  @override
  Widget build(BuildContext context) {
    // _productNameController.text = widget.product.name;
    // _priceController.text = "${widget.product.price}";
    // _descriptionController.text = widget.product.description;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            Get.off(HomePage());
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
        title: Text("Edit"),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              updateProduct();
              // isLoaded? uploadFile() : null;
              // FirebaseLoading.loading();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: (isLoaded)
                  ? Image.file(File(pickedFile!.path))
                  : Image.network(
                widget.product.image,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: getImageFromGalley,
                  icon: Icon(Icons.camera_alt),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _productNameController,
              // initialValue: widget.product.name,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Product Name',
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _priceController,

              decoration: const InputDecoration(
                filled: true,
                labelText: 'Price',
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _descriptionController,

              decoration: const InputDecoration(
                filled: true,
                labelText: 'Description',
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> updateProduct() async {
    int price = int.parse(_priceController.text);
    String image ="";
    if(isLoaded){
      image = await FirebaseStorage.instance.ref().child(pickedImageName).getDownloadURL();
    }
     FirebaseFirestore.instance
        .collection('products').doc(widget.product.id)
        .update(<String, dynamic>{
      'description': _descriptionController.text,
      // 'timestamp': DateTime.now().toString(),
      'name': _productNameController.text,
      'image': isLoaded ? image : widget.product.image,
      'price': price,
      'liked': 0,
      // 'creator': FirebaseAuth.instance.currentUser!.uid,
      // 'uploadTime' : DateTime.now(),
      'editedTime' : DateTime.now(), //FieldValue.serverTimestamp(),
    });
  }

  Future uploadFile() async {
    try {
      final ref = storage.ref().child(url.last);
      await ref.putFile(File(pickedFile!.path));
    } catch (e) {
      print('error occured');
    }
  }
}
