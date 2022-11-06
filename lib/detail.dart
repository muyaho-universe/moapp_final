import 'dart:ui';

import 'package:flutter/material.dart';

import 'model/product.dart';
import 'package:intl/intl.dart';
import 'src/widgets.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail"),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.create)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
        ],
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: Image.network(
              widget.product.image,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 220,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.thumb_up, color: Colors.red)),
                    Text('0'),
                  ],
                ),
                Text(
                  formatter.format(widget.product.price,),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Divider(
                  height: 8,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                  color: Colors.grey,
                ),
                SizedBox(height: 20,),
                Text(widget.product.description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void format() {}
}
