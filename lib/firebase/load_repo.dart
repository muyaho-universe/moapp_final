import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';
import '../model/product_repo.dart';
import '../model/product_repo2.dart';

class FirebaseLoading {
  static Future<void> loading() async {

    print("loading working");
   FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshots) async {
      for (var doc in snapshots.docs) {
        bool go = true;
        for (var p in ProductsRepository.loadProducts) {
          if (p.name == doc.get('name')) {
            go = false;
          }
        }
        if (go) {
          String image = await FirebaseStorage.instance.ref().child(doc.get('image')).getDownloadURL();
          ProductsRepository.loadProducts.add(Product(
            name: doc.get('name'),
            price: doc.get('price'),
            image: image,
            description: doc.get('description'),
          ));
        }
      }
      // notifyListeners();
    });
   ProductsRepository.loadProducts = ProductsRepository.loadProducts.toSet().toList();
  }
  static prints(){
    print(ProductsRepository.loadProducts.length);
    for(var p in ProductsRepository.loadProducts){
      String ment ="name: " + p.name ;
      print(ment);
    }
  }
}
