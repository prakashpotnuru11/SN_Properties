import 'package:flutter/material.dart';

enum PropertyType { buy, rent, sell }

enum PropertyCategory { residential, commercial, agricultural, plots }

class Property {
  const Property({
    required this.title,
    required this.location,
    required this.price,
    required this.type,
    required this.category,
    required this.bedrooms,
    required this.area,
    required this.accentColor,
    this.description = '',
    this.imageUrls = const [],
    this.isFeatured = false,
  });

  final String title;
  final String location;
  final String price;
  final PropertyType type;
  final PropertyCategory category;
  final int bedrooms;
  final String area;
  final Color accentColor;
  final String description;
  final List<String> imageUrls;
  final bool isFeatured;
}
