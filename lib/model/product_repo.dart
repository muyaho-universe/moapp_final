import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrine/model/product_repo2.dart';

import 'product.dart';

class ProductsRepository {
  static List<Product> loadProducts = [];

  static Future<void> getURL() async {
    var loadProduct = loadProducts.toSet();
    for(var proudct in loadProduct){
      bool go = true;
      for(var product in ProductRepo2.loadProducts2){
        if(product.name == proudct.name){
          print(proudct.name);
          print(" find it!!!!!!!!!!!!!!!!!!");
          go = !go;
        }
      }
      print(go);
      if(go){
        String image = await FirebaseStorage.instance.ref().child(proudct.image).getDownloadURL();
        ProductRepo2.loadProducts2.add(Product(name: proudct.name, price: proudct.price, image: image, description: proudct.description));
      }
    }
    // ProductRepo2.loadProducts2 = ProductRepo2.loadProducts2.toSet().toList();
  }

  }