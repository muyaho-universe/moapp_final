import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

class FinalApp extends StatelessWidget {
  const FinalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
      builder: (context, snapshot) {

        if(snapshot.hasError){
          return const Center(
            child: Text("firebase load failed"),
          );
        }
        if(snapshot.connectionState == ConnectionState.done){
          return LoginPage();
        }
        return const CircularProgressIndicator();
      }
    );
  }
}