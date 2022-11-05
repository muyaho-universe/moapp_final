import 'package:flutter/material.dart';

import 'model/product.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
