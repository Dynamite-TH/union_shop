import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CollectionsItem {
  final String id;
  final String name;
  final String description;
  final String image;

  CollectionsItem({
    required this.id,
    required this.name,
    required this.description,
    this.image = 'assets/images/collection_placeholder.png',
  });

  factory CollectionsItem.fromJson(Map<String, dynamic> json) {
    return CollectionsItem(
      id: json['id']?.toString() ?? '',
      name: (json['name'] ?? json['title'])?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ??
          'assets/images/collection_placeholder.png',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'image': image,
      };
}

Future<List<CollectionsItem>> loadCollectionsFromAsset() async {
  final jsonString =
      await rootBundle.loadString('assets/data/collections.json');
  final List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((item) => CollectionsItem.fromJson(item)).toList();
}
