import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.liked,
    required this.creator,
    required this.uploadTime,
    required this.editedTime,
    required this.name,
    required this.id,
    required this.price,
    required this.image,
    required this.description,
  });

  final String id;
  final String name;
  final int price;
  final int liked;
  final String image;
  final String description;

  final String creator;

  final String uploadTime;
  final String editedTime;
}
