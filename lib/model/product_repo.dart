import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrine/model/product_repo2.dart';

import 'product.dart';

class ProductsRepository {
  static List<Product> loadProducts = [];

  static Future<void> getURL() async {
    for(var proudct in loadProducts){
      String image = await FirebaseStorage.instance.ref().child(proudct.image).getDownloadURL();
      ProductRepo2.loadProducts2.add(Product(name: proudct.name, price: proudct.price, image: image));
    }
  }

  }