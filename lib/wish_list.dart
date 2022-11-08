import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/product.dart';
import 'model/product_repo.dart';
import 'model/wish_list_model.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List<Product> wishList = [];

  List<Card> _buildListCards(BuildContext context) {
    final wishProvider = Provider.of<WishProvider>(context);
    List<Product> products = ProductsRepository.loadProducts;

    if (products.isEmpty) {
      return const <Card>[];
    }

    return products.map((product) {
      var wish = ProductsRepository.doIWish[product.id]!;

      return wish
          ? Card(
              clipBehavior: Clip.antiAlias,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 50,
                    height: 80,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(product.name),
                ],
              ),
            )
          : Card();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Wish List"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        children: _buildListCards(context),
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}
