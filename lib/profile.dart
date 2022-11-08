import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'login.dart';
import 'model/product_repo.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  String defaultImamgeURL = "https://handong.edu/site/handong/res/img/logo.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: LoginPage.isGoogle
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 4,
                    child: Image.network(
                      defaultImamgeURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(FirebaseAuth.instance.currentUser!.uid),
                  Divider(
                    height: 8,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.grey,
                  ),
                  Text(FirebaseAuth.instance.currentUser!.email!),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Daeseok Kim"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("I promise to take the test honestly before GOD ."),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 4,
                    child: Image.network(
                      defaultImamgeURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("anonymous uid"),
                  Divider(
                    height: 8,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.grey,
                  ),
                  Text("Anonymous"),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Daeseok Kim"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("I promise to take the test honestly before GOD ."),
                ],
              ),
            ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    LoginPage.go = false;
    ProductsRepository.loadProducts = [];
    ProductsRepository.doIWish = {};
    ProductsRepository.doILike = {};
    Get.to(LoginPage());
  }
}
