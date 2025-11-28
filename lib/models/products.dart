// lib/models/products.dart
// Utility to load products from a JSON asset and map into Product items.

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProductItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final double discount;
  final List<String> tags;

  ProductItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.discount = 0.0,
    this.tags = const [],
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    double parsePrice(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return ProductItem(
      id: json['id']?.toString() ?? '',
      name: (json['name'] ?? json['title'])?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: parsePrice(json['price']),
      discount: parsePrice(json['discount']),
      image: json['image']?.toString() ?? '',
      category: json['catagory']?.toString() ?? 'uncategorized',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'image': image,
        'category': category,
        'discount': discount,
        'tags': tags
      };
}

/// Loads a list of Product from a JSON file in assets.
/// Default path: 'assets/products.json'
/// Make sure to add the JSON file to pubspec.yaml assets.
Future<List<ProductItem>> loadProductsFromAsset(
    [String path = 'assets/data/products.json']) async {
  try {
    final raw = await rootBundle.loadString(path);
    final decoded = json.decode(raw);
    if (decoded is List) {
      return decoded.map<ProductItem>((e) {
        if (e is Map<String, dynamic>) return ProductItem.fromJson(e);
        return ProductItem.fromJson(Map<String, dynamic>.from(e as Map));
      }).toList();
    } else if (decoded is Map<String, dynamic>) {
      // In case the JSON wraps the list in an object: { "products": [...] }
      if (decoded['products'] is List) {
        return (decoded['products'] as List).map<ProductItem>((e) {
          return ProductItem.fromJson(Map<String, dynamic>.from(e as Map));
        }).toList();
      }
    }
  } catch (_) {}
  return <ProductItem>[];
}

/// Loads products and groups them by category.
/// Returns a map where keys are category names and values are lists of ProductItem.
Future<Map<String, List<ProductItem>>> loadProductsGroupedByCategory(
    [String path = 'assets/data/products.json']) async {
  final products = await loadProductsFromAsset(path);
  final Map<String, List<ProductItem>> grouped = {};
  for (final p in products) {
    grouped.putIfAbsent(p.category, () => []).add(p);
  }
  return grouped;
}
