import 'package:flutter/material.dart';

import 'model/product.dart';
import 'model/product_repo.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List<Product> wishList = [];

  List<Card> _buildListCards(BuildContext context) {
    List<Product> products = ProductsRepository.loadProducts;

    if (products.isEmpty) {
      return const <Card>[];
    }

    return products.map((product) {
      var wish = ProductsRepository.doIWish[product.id]!;

      return wish? Card(
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 130,
              child: Image.network(
                product.image,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 20,),
            Text(product.name),
          ],
        ),
      ): Card();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        children: _buildListCards(context),
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}
