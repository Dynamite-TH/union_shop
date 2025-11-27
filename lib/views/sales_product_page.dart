import 'package:flutter/material.dart';
import 'package:union_shop/views/widgets/appbar.dart';
import 'package:union_shop/views/widgets/drawer.dart';

class SalesProductPage extends StatelessWidget {
  const SalesProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const SalesProductScreen(),
      // By default, the app starts at the '/' route, which is the HomeScreen
      initialRoute: 'collections/sales_product',
    );
  }
}

class SalesProductScreen extends StatelessWidget {
  const SalesProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const AppDrawer(),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: salesProducts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return ProductItemCard(product: salesProducts[index]);
        },
      ),
    );
  }
}

class SalesProductItem {
  final String name;
  final String description;
  final double price;
  final double discount;
  final String imageUrl;

  SalesProductItem({
    required this.name,
    required this.description,
    required this.price,
    this.discount = 0.0,
    required this.imageUrl,
  });
}

// Sample sales products data
final List<SalesProductItem> salesProducts = [
  SalesProductItem(
    name: 'Discounted T-Shirt',
    description: 'A stylish t-shirt at a discounted price.',
    price: 9.99,
    discount: 2.00,
    imageUrl: 'https://example.com/images/discounted_tshirt.jpg',
  ),
  SalesProductItem(
    name: 'Sale Jeans',
    description: 'Comfortable jeans on sale now.',
    price: 29.99,
    discount: 5.00,
    imageUrl: 'https://example.com/images/sale_jeans.jpg',
  ),
];

class ProductItemCard extends StatelessWidget {
  final SalesProductItem product;

  const ProductItemCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image area wrapped in an IconButton so the image is tappable.
          IconButton(
            padding: EdgeInsets.zero,
            icon: Stack(
              children: [
                // Image
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                // Name + price overlay at bottom-right
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${(product.price - product.discount).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // TODO: navigate to product detail page if available
            },
          ),

          // Description below image
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              product.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
