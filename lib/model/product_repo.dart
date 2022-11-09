import 'dart:collection';

import 'package:firebase_storage/firebase_storage.dart';

import 'product.dart';

class ProductsRepository {
  static List<Product> loadProducts = [];
  static Map<String, bool> doILike = {};
  static Map<String, bool> doIWish = {};
  }