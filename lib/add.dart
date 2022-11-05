import 'package:flutter/material.dart';
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

  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

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
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: Image.network(defaultImamgeURL, fit: BoxFit.cover,),
          ),
        ],
      ),
    );
  }
}
