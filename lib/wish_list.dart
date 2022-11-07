import 'package:flutter/material.dart';

import 'model/product.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  static List<Product> wishList = [];
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
