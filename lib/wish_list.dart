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
    List<Product> products2 = ProductsRepository.loadProducts;
    List<Product> products = [];

    if (products2.isEmpty) {
      return const <Card>[];
    }

    for (var p in products2) {
      var wish = ProductsRepository.doIWish[p.id]!;
      if (wish) products.add(p);
    }

    return products.map((product) {
      return Card(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flexible(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: product.name,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 50,
            ),
            IconButton(
              onPressed: () {
                wishProvider.removeCartItem(product);
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      );
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
