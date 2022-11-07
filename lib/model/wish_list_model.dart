import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/model/product_repo.dart';

class CartProvider with ChangeNotifier {
  late CollectionReference wishReference;
  List<Product> wishList = [];

  CartProvider({reference}) {
    wishReference = reference ??
        FirebaseFirestore.instance
            .collection('wish')
            .doc(FirebaseAuth.instance.currentUser!.uid).collection("wish");
  }

  Future<void> fetchWishItemsOrCreate() async {
    wishReference.snapshots().listen((snapshots) {
      ProductsRepository.doIWish = {};
      for (var doc in snapshots.docs) {
        ProductsRepository.doIWish[doc.id] = doc.get('wish');
      }
      notifyListeners();
    });
  }

  Future<void> addCartItem(Product product) async {
    ProductsRepository.doIWish[product.id] = true;
    await wishReference.doc(product.id).set({'wish': true}, SetOptions(merge: true));
    notifyListeners();
  }

  Future<void> removeCartItem(Product product) async {
    ProductsRepository.doIWish[product.id] = false;

    await wishReference.doc(product.id).set({'wish': false}, SetOptions(merge: true));
    notifyListeners();
  }

  // bool isCartItemIn(Item item) {
  //   return cartItems.any((element) => element.id == item.id);
  // }
}
