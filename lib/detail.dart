import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shrine/edit.dart';
import 'package:shrine/home.dart';

import 'model/product.dart';
import 'package:intl/intl.dart';
import 'model/product_repo.dart';
import 'model/wish_list_model.dart';
import 'src/widgets.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.product, required this.num}) : super(key: key);
  final Product product;
  final int num;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFirst = true;


  @override
  Widget build(BuildContext context) {
    final wishProvider = Provider.of<WishProvider>(context);
    bool isLiked = ProductsRepository.doILike[widget.product.id]!;
    var wish = ProductsRepository.doIWish[widget.product.id]!;
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    int liked = (isFirst)? widget.num : widget.num + 1;
    var snackBar = SnackBar(
      content: (isLiked && isFirst)
          ? Text('I LIKE IT')
          : Text("You can only do it once !!"),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail"),
        actions: <Widget>[
          (FirebaseAuth.instance.currentUser!.uid == widget.product.creator)
              ? IconButton(
                  onPressed: () {
                    Get.off(EditPage(product: widget.product));
                    print("same");
                  },
                  icon: Icon(Icons.create))
              : IconButton(
                  onPressed: () {
                    print("not same");
                  },
                  icon: Icon(Icons.create)),
          (FirebaseAuth.instance.currentUser!.uid == widget.product.creator)
              ? IconButton(
                  onPressed: () async {
                    print(widget.product.id);
                    FirebaseFirestore.instance
                        .collection('products')
                        .doc(widget.product.id)
                        .delete()
                        .then((value) => print("User Deleted"))
                        .catchError(
                            (error) => print("Failed to delete user: $error"));
                    Get.off(HomePage());
                  },
                  icon: Icon(Icons.delete))
              : IconButton(
                  onPressed: () {
                    print("not user");
                  },
                  icon: Icon(Icons.delete)),
        ],
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: Image.network(
              widget.product.image,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                    ),
                    (isLiked && isFirst)
                        ? IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              liked++;
                              print(liked);
                              setState(() {
                                print("it runs");

                                isFirst = !isFirst;
                                isLiked = !isLiked;
                              });
                              FirebaseFirestore.instance
                                  .collection(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  .doc(widget.product.id)
                                  .set(<String, dynamic>{'liked': false},
                                      SetOptions(merge: true));
                              FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(widget.product.id)
                                  .update(<String, dynamic>{
                                'liked': liked,
                              });
                            },
                            icon: Icon(Icons.thumb_up, color: Colors.red),
                          )
                        : IconButton(
                            onPressed: () {
                              print(liked);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: Icon(Icons.thumb_up, color: Colors.red),
                          ),
                    Text("${liked}"),
                  ],
                ),
                Text(
                  formatter.format(
                    widget.product.price,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Divider(
                  height: 8,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(widget.product.description),
                SizedBox(height: 100),
                Row(
                  children: [
                    Text(
                      "Creator: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      widget.product.creator,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      widget.product.uploadTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      " Created",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      widget.product.editedTime,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      " Modified",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(!wish){
            wishProvider.addCartItem(widget.product);
            // setState(() {
            //   ProductsRepository.doIWish[widget.product.id] = true;
            // });

          }
          else{
            print("already on list");
          }
        },
        // backgroundColor: Colors.green,
        child: Icon(wish ? Icons.check : Icons.shopping_cart),
      ),
    );
  }

  void format() {}
}
