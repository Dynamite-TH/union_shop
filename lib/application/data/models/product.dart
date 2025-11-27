import 'dart:convert';

class Product {
  final String category;
  final String name;
  final double price;
  final String description;
  final int discount;
  final List<String> tags;

  Product({
    required this.category,
    required this.name,
    required this.price,
    required this.description,
    required this.discount,
    required this.tags,
  });

  double get discountedPrice => (price * (1 - discount / 100)).toDouble();

  factory Product.fromJson(Map<String, dynamic> json) {
    // accept either 'catagory' (misspelled in the provided file) or 'category'
    final rawCategory = json['catagory'] ?? json['category'] ?? 'uncategorized';

    String parseString(dynamic v, [String fallback = '']) {
      if (v == null) return fallback;
      return v.toString();
    }

    double parsePrice(dynamic p) {
      if (p == null) return 0.0;
      if (p is num) return p.toDouble();
      if (p is String) return double.tryParse(p) ?? 0.0;
      return 0.0;
    }

    int parseDiscount(dynamic d) {
      if (d == null) return 0;
      if (d is int) return d;
      if (d is num) return d.toInt();
      if (d is String) return int.tryParse(d) ?? 0;
      return 0;
    }

    final tagsRaw = json['tags'];
    List<String> tags = [];
    if (tagsRaw is List) {
      tags = tagsRaw.map((e) => e.toString()).toList();
    }

    return Product(
      category: parseString(rawCategory, 'uncategorized'),
      name: parseString(json['name'], 'Unnamed product'),
      price: parsePrice(json['price']),
      description: parseString(json['description'], ''),
      discount: parseDiscount(json['discount']),
      tags: tags,
    );
  }

  Map<String, dynamic> toJson() => {
        'catagory': category,
        'name': name,
        'price': price,
        'description': description,
        'discount': discount,
        'tags': tags,
      };

  @override
  String toString() => jsonEncode(toJson());
}
