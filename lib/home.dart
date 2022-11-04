// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cards.dart';
import 'model/product.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  bool isLoggedIn = false;

  FirebaseStorage storage = FirebaseStorage.instance;

  // var products = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoggedIn
          ? AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.person,
                  semanticLabel: 'menu',
                ),
                onPressed: () {
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
                  onPressed: () {
                    print(isLoggedIn);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    semanticLabel: 'filter',
                  ),
                  onPressed: () {
                    isLoggedIn = false;
                    _signOut();
                  },
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoginPage();
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    isLoggedIn = true;
                  });
                });
                return CardPage();
              }
              return CardPage();
            }),
      ),
    );
  }

  Future<void> _signOut() async {
    isLoggedIn = false;
    await FirebaseAuth.instance.signOut();
  }
}
