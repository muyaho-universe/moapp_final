import 'dart:ui';

import 'package:flutter/material.dart';

import 'model/product.dart';
import 'package:intl/intl.dart';

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
          Row(
            children: [
              Text(widget.product.name),
              IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up)),
            ],
          ),
          Text(
            formatter.format(widget.product.price),
          ),
          Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          Flexible(
            child: RichText(
              maxLines: 100,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: widget.product.description),
                ],
                style: const TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void format() {}
}
