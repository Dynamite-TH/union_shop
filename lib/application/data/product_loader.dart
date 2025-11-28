import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'models/product.dart';

class ProductLoader {
  static const _assetPath = 'assets/data/products.json';

  /// Loads and parses the JSON asset into a List<Product>.
  static Future<List<Product>> loadProducts() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final dynamic parsed = json.decode(jsonString);
      if (parsed is List) {
        return parsed.map<Product>((e) {
          if (e is Map<String, dynamic>) return Product.fromJson(e);
          // If it's a map with dynamic key types
          return Product.fromJson(Map<String, dynamic>.from(e));
        }).toList();
      } else {
        throw FormatException('Expected a JSON array at $_assetPath');
      }
    } catch (e) {
      // Rethrow so callers (UI/repository) can handle the error.
      rethrow;
    }
  }

  /// Groups products by lowercased category name.
  static Map<String, List<Product>> categorize(List<Product> products) {
    final Map<String, List<Product>> map = {};
    for (final p in products) {
      final key = p.category.trim().toLowerCase();
      final bucket = key.isEmpty ? 'uncategorized' : key;
      map.putIfAbsent(bucket, () => []).add(p);
    }
    return map;
  }
}
