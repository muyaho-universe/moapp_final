import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shrine/model/wish_list_model.dart';
import 'package:shrine/profile.dart';

import 'add.dart';
import 'detail.dart';
import 'firebase/load_repo.dart';
import 'model/product.dart';
import 'login.dart';
import 'model/product_repo.dart';
import 'model/product_repo2.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static bool orderDesc = false;
  static bool orderDesc2 = false;
  final user = FirebaseAuth.instance.currentUser;

  FirebaseStorage storage = FirebaseStorage.instance;
  late QuerySnapshot querySnapshot;
  List<Product> products = [];
  static bool isFirst = true;

  static List<String> query = <String>['ASC', 'DESC'];
  String dropdownValue = query.first;

  List<Card> _buildGridCards(BuildContext context) {
    products = [];

    products = ProductsRepository.loadProducts;
    // products = ProductRepo2.loadProductsSet.toList();
    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      bool wish = ProductsRepository.doIWish[product.id]!;
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children:<Widget> [
                AspectRatio(
                  aspectRatio: 18 / 11,
                  child: Image.network(product.image),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        wish ? Icons.check_circle : null,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
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
                              num: product.liked,
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

  List<Card> _buildReverseGridCards(BuildContext context) {
    products = [];

    products = List.from(ProductsRepository.loadProducts.reversed);
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
                              num: product.liked,
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
            Get.to(ProfilePage());
          },
        ),
        title: const Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Get.to(AddPage());
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              print("cart");
              // Get.to(AddPage());
            },
          ),
        ],
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('products').snapshots(),
      //   builder: (context,
      //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(), //로딩되는 동그라미 보여주기
      //       );
      //     }
      //     if (snapshot.hasData) {
      //       for (int i = 0; i < snapshot.data!.docs.length; i++) {
      //         var one = snapshot.data!.docs[i];
      //         var go = true;
      //         for (var p in ProductsRepository.loadProducts) {
      //           if (p.name == one.get('name')) {
      //             go = false;
      //           }
      //         }
      //         if (go) {
      //           ProductsRepository.loadProducts.add(Product(
      //             name: one.get('name'),
      //             price: one.get('price'),
      //             image: one.get('image'),
      //             description: one.get('description'),
      //           ));
      //         }
      //       }
      //     }

      body: Consumer<FirebaseLoading>(
        builder: (context, appState, _) =>
            Column(
              children: <Widget>[
                Container(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                        if (value! == 'ASC') {
                          orderDesc = false;
                        } else {
                          orderDesc = true;
                        }
                      });
                      print("changed");
                      print(orderDesc);
                    },
                    items: query.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  height: 50,
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: SafeArea(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(16.0),
                      childAspectRatio: .75,
                      children: orderDesc
                          ? _buildReverseGridCards(context)
                          : _buildGridCards(context),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

// Future<String> _getImageURL(String imageUrl) async {
//   final ref = FirebaseStorage.instance.ref().child(imageUrl);
//   var url = await ref.getDownloadURL();
//   return url;
// }
class FirebaseLoading extends ChangeNotifier {
  FirebaseLoading() {
    WishProvider w = new WishProvider();
    w.fetchWishItemsOrCreate();
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        loading();
      }
      // } else {
      //   _guestBookMessages = [];
      //   _guestBookSubscription?.cancel();
      //   _attendingSubscription?.cancel();
      // }
      notifyListeners();
    });
  }

  Future<void> loading() async {
    // sleep(const Duration(seconds:1));

    print("loading working");
    FirebaseFirestore.instance
        .collection('products')
        .orderBy('price', descending: _HomePageState.orderDesc2)
        .snapshots()
        .listen((snapshots) async {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.size == 0) {
          for (var doc in snapshots.docs) {
            FirebaseFirestore.instance
                .collection(FirebaseAuth.instance.currentUser!.uid)
                .doc(doc.id)
                .set({'liked': true, 'wish': false}, SetOptions(merge: true));
          }
        }
        notifyListeners();
      });

      FirebaseFirestore.instance
          .collection('wish')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("wish")
          .snapshots()
      .listen((snapshot) {
        if(snapshot.size == 0){
          for (var doc in snapshots.docs) {
            FirebaseFirestore.instance
                .collection('wish')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("wish")
                .doc(doc.id).set({'wish': false}, SetOptions(merge: true));
          }
        }
        notifyListeners();
      });

      ProductsRepository.loadProducts = [];
      for (var doc in snapshots.docs) {
        bool go = true;
        for (var p in ProductsRepository.loadProducts) {
          if (p.name == doc.get('name')) {
            go = false;
          }
        }
        if (go) {
          // String image = await FirebaseStorage.instance.ref().child(doc.get('image')).getDownloadURL();
          try {
            ProductsRepository.loadProducts.add(Product(
              id: doc.id,
              name: doc.get('name'),
              price: doc.get('price'),
              image: doc.get('image'),
              description: doc.get('description'),
              liked: doc.get('liked'),
              creator: doc.get('creator'),
              uploadTime:
              (doc.data()['uploadTime'] as Timestamp).toDate().toString(),
              editedTime:
              (doc.data()['editedTime'] as Timestamp).toDate().toString(),

            ));
          } catch (e) {}
        }
      }
      notifyListeners();
    });

    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) async {
      ProductsRepository.doILike = {};
      for (var doc in snapshot.docs) {
        ProductsRepository.doILike[doc.id] = doc.get('liked');
      }
      notifyListeners();
    });

    FirebaseFirestore.instance
        .collection('user')
        .snapshots()
        .listen((snapshots) {
      bool first = true;
      for (var snap in snapshots.docs) {
        if (snap.id == FirebaseAuth.instance.currentUser!.uid) first = false;
      }
      if (first) {
        print("welcome");
        if (LoginPage.isGoogle) {
          FirebaseFirestore.instance
              .collection('user')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'email': FirebaseAuth.instance.currentUser!.email,
            'name': FirebaseAuth.instance.currentUser!.displayName,
            'status_message': "I promise to take the test honestly before GOD.",
            "uid": FirebaseAuth.instance.currentUser!.uid,
          }, SetOptions(merge: true));
        }
        else {
          FirebaseFirestore.instance
              .collection('user')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'status_message': "I promise to take the test honestly before GOD.",
            "uid": FirebaseAuth.instance.currentUser!.uid,
          }, SetOptions(merge: true));
        }
      }
      notifyListeners();
    });
  }

  static prints() {
    print(ProductsRepository.loadProducts.length);
    for (var p in ProductsRepository.loadProducts) {
      String ment = "name: " + p.name;
      print(ment);
    }
  }
}
