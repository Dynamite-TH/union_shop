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
      initialRoute: 'collections/sales-product',
    );
  }
}

class SalesProductScreen extends StatelessWidget {
  const SalesProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 4);

    // display-friendly selected tag name

    // dropdown width: keep it compact on larger screens but allow shrinking on small devices

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(
                child: Text(
                  'Sales Products',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: salesProducts.isEmpty
                  ? const Center(child: Text('No sales products available.'))
                  : GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: salesProducts.length,
                      itemBuilder: (context, index) {
                        return ProductItemCard(product: salesProducts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
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
      elevation: 1,
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
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context,
                  '/collections/sales-product/product-${product.name.replaceAll(' ', '-').toLowerCase()}');
            },
          ),

          // Description below image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black),
                children: [
                  TextSpan(text: '${product.name} \n'),
                  TextSpan(
                    text: '£${product.price.toStringAsFixed(2)} ',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    text:
                        '£${(product.price - product.discount).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
