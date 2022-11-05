import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';
import '../model/product_repo.dart';

class FirebaseLoading {
  static void loading() async {
   FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshots) {
      for (var doc in snapshots.docs) {
        bool go = true;
        for (var p in ProductsRepository.loadProducts) {
          if (p.name == doc.get('name')) {
            go = false;
          }
        }
        if (go) {
          ProductsRepository.loadProducts.add(Product(
            name: doc.get('name'),
            price: doc.get('price'),
            image: doc.get('image'),
            description: doc.get('description'),
          ));
        }
      }
      // notifyListeners();
    });

    // StreamBuilder(
    //   stream: FirebaseFirestore.instance.collection('products').snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.hasData) {
    //       for (int i = 0; i < snapshot.data!.docs.length; i++) {
    //         var one = snapshot.data!.docs[i];
    //         var go = true;
    //         for (var p in ProductsRepository.loadProducts) {
    //           if (p.name == one.get('name')) {
    //             go = false;
    //           }
    //         }
    //         if (go) {
    //           ProductsRepository.loadProducts.add(Product(
    //             name: one.get('name'),
    //             price: one.get('price'),
    //             image: one.get('image'),
    //             description: one.get('description'),
    //           ));
    //         }
    //       }
    //     }
    //   },
    // );
  }
}
