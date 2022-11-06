import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'login.dart';
import 'model/product_repo.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
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
      body: LoginPage.isGoogle? Container():Container(),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    LoginPage.go = false;
    ProductsRepository.loadProducts = [];
    Get.to(LoginPage());
  }
}
