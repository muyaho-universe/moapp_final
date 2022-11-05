import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shrine/home.dart';
import 'package:get/get.dart';

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
    print(pickedFile!.path);
    print(url.last);
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
            onPressed: () {},
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
        child: Column(
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
}
