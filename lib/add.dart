import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shrine/home.dart';
import 'package:get/get.dart';

import 'model/product_repo.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String defaultImage = "logo.png";
  String defaultImamgeURL = "https://handong.edu/site/handong/res/img/logo.png";
  String pickedImageName = "";

  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  PickedFile? pickedFile;

  XFile? upLoadimage;
  final ImagePicker _picker = ImagePicker();

  FirebaseStorage storage = FirebaseStorage.instance;

  // late XFile? image;
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
  Widget build(BuildContext context) {
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
        title: Text("Add"),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              addMessageToProduct();

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
                      defaultImamgeURL,
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

  Future<DocumentReference> addMessageToProduct() async {
    var time = FieldValue.serverTimestamp();
    int price = int.parse(_priceController.text);
    String newID = "";
    String image = await FirebaseStorage.instance
        .ref()
        .child(
          isLoaded ? pickedImageName : defaultImage,
        )
        .getDownloadURL();
    var returnValue =
        FirebaseFirestore.instance.collection('products').add(<String, dynamic>{
      'description': _descriptionController.text,
      'name': _productNameController.text,
      'image': image,
      'price': price,
      'liked': 0,
      'creator': FirebaseAuth.instance.currentUser!.uid,
      'uploadTime': time,
      'editedTime': time, //FieldValue.serverTimestamp(),
    });
    returnValue.then((value) => FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('${value.id}')
        .set({'liked': true}));
    returnValue.then((value) => FirebaseFirestore.instance
        .collection('wish')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('wish')
        .doc('${value.id}')
        .set({'wish': false}));
    return returnValue;
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
