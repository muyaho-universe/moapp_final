import 'package:flutter/material.dart';

class Paragraph extends StatelessWidget {
  const Paragraph({Key? key, required this.content}) : super(key: key);
  final String content;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Text(
      content,
      style: const TextStyle(fontSize: 18),
    ),
  );
}