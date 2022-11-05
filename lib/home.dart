

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'detail.dart';
import 'model/product.dart';
import 'login.dart';
import 'model/product_repo.dart';
import 'model/product_repo2.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  FirebaseStorage storage = FirebaseStorage.instance;
  late QuerySnapshot querySnapshot;
  List<Product> products = [];
  static bool isFirst = true;

    List<String> query = <String>['ASC', 'DESC'];

  List<Card> _buildGridCards(BuildContext context) {
    if (isFirst) {
      ProductsRepository.getURL();
      // isFirst = !isFirst;
    }
    products = ProductRepo2.loadProducts2;
    // products = ProductRepo2.loadProductsSet.toList();
    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.network(product.image),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.subtitle2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                              Size(16, 9),
                            ),
                          ),
                          onPressed: () {
                            Get.to(DetailPage(
                              product: product,
                            ));
                          },
                          child: Text("more"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            semanticLabel: 'menu',
          ),
          onPressed: () {
            print(FirebaseAuth.instance.currentUser?.uid);
            print('Menu button');
          },
        ),
        title: const Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              semanticLabel: 'filter',
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(), //로딩되는 동그라미 보여주기
              );
            }
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                var one = snapshot.data!.docs[i];
                if(ProductsRepository.loadProducts.contains(one.get('name')))
                  print("111!!!  !!!");
                ProductsRepository.loadProducts.add(Product(
                  name: one.get('name'),
                  price: one.get('price'),
                  image: one.get('image'),
                  description: one.get('description'),
                ));
              }
            }

            return Column(
              children: <Widget>[
                Container(
                    color: Colors.grey,
                  height: 100,

                ),
                SizedBox(height: 15,),
                Expanded(
                  child: SafeArea(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(16.0),
                      childAspectRatio: .75,
                      children: _buildGridCards(context),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    LoginPage.go = false;
    Get.to(LoginPage());
  }



// Future<String> _getImageURL(String imageUrl) async {
//   final ref = FirebaseStorage.instance.ref().child(imageUrl);
//   var url = await ref.getDownloadURL();
//   return url;
// }
}
