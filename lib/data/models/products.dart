class Product {
  final String catagory;
  final String name;
  final String category;
  final double price;
  final int discount;

  
  Product({
    required this.catagory,
    required this.name,
    required this.category,
    required this.price,
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      catagory: json['catagory'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toInt(),
    );
  }
}