import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shrine/model/product.dart';

class CartProvider with ChangeNotifier {
  late CollectionReference wishReference;
  List<Product> wishList = [];

  CartProvider({reference}) {
    wishReference = reference ?? FirebaseFirestore.instance.collection('wish');
  }

  Future<void> fetchCartItemsOrCreate(String uid) async {
    if (uid == ''){
      return ;
    }
    final wishSnapshot = await wishReference.doc(uid).get();
    if(wishSnapshot.exists) {
      Map<String, dynamic> wishItemsMap = wishSnapshot.data() as Map<String, dynamic>;
      List<Product> temp = [];
      for (var item in wishItemsMap['items']) {
        temp.add(Product.fromMap(item));
      }
      wishList = temp;
      notifyListeners();
    } else {
      await wishReference.doc(uid).set({'items': []});
      notifyListeners();
    }
  }

  Future<void> addCartItem(String uid, Product product) async {
    wishList.add(product);
    Map<String, dynamic> cartItemsMap = {
      'items': wishList.map( (item) {
        return item.toSnapshot();
      }).toList()
    };
    await wishReference.doc(uid).set(cartItemsMap);
    notifyListeners();
  }

  Future<void> removeCartItem(String uid, Item item) async {
    cartItems.removeWhere((element) => element.id == item.id);
    Map<String, dynamic> cartItemsMap = {
      'items': cartItems.map((item) {
        return item.toSnapshot();
      }).toList()
    };

    await cartReference.doc(uid).set(cartItemsMap);
    notifyListeners();
  }

  bool isCartItemIn(Item item) {
    return cartItems.any((element) => element.id == item.id);
  }
}