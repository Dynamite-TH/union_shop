import 'package:flutter/material.dart';
import 'package:union_shop/views/widgets/appbar.dart';

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

class SalesProductScreen extends StatefulWidget {
  const SalesProductScreen({Key? key}) : super(key: key);

  @override
  State<SalesProductScreen> createState() => _SalesProductScreenState();
}

class _SalesProductScreenState extends State<SalesProductScreen> {
  String? _selectedTag;
  late List<String> _allTags;

  @override
  void initState() {
    super.initState();
    // collect unique tags from salesProducts
    final tagSet = <String>{};
    for (final p in salesProducts) {
      tagSet.addAll(p.tags);
    }
    _allTags = tagSet.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 4);

    // display-friendly selected tag name
    final dropdownWidth =
        screenWidth < 420 ? (screenWidth - 48).clamp(120.0, 320.0) : 200.0;

    final filtered = _selectedTag == null
        ? salesProducts
        : salesProducts.where((p) => p.tags.contains(_selectedTag)).toList();

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
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Explore our exclusive sales products at unbeatable prices! Don\'t miss out on these limited-time offers.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Use the filter below to find products on sale by category.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),

            // Filter dropdown (centered on wide/full screens)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              // Center the filter row and constrain its maximum width so on
              // very wide/full-screen windows the filter stays visually central.
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: Icon(Icons.filter_list, color: Colors.black54),
                    ),
                    SizedBox(
                      width: dropdownWidth,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String?>(
                            isExpanded: true,
                            value: _selectedTag,
                            hint: const Text('Select filter'),
                            items: [
                              const DropdownMenuItem<String?>(
                                value: null,
                                child: Text('All'),
                              ),
                              ..._allTags
                                  .map((tag) => DropdownMenuItem<String?>(
                                        value: tag,
                                        child: Text(tag),
                                      ))
                                  .toList(),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _selectedTag = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: filtered.isEmpty
                  ? const Center(child: Text('No sales products available.'))
                  : Center(
                      child: ConstrainedBox(
                        // Keep the grid centered and readable on wide screens
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return ProductItemCard(product: filtered[index]);
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesProductItem {
  final String name;
  final String description;
  final double price;
  final double discount;
  final List<String> tags;
  final String imageUrl;

  SalesProductItem({
    required this.name,
    required this.description,
    required this.price,
    this.discount = 0.0,
    List<String>? tags,
    required this.imageUrl,
  }) : tags = tags ?? const [];
}

// Sample sales products data
final List<SalesProductItem> salesProducts = [
  SalesProductItem(
    name: 'Discounted T-Shirt',
    description: 'A stylish t-shirt at a discounted price.',
    price: 9.99,
    discount: 2.00,
    tags: ['clothing', 'tshirt', 'discount'],
    imageUrl: 'assets/images/collections/sales.png',
  ),
  SalesProductItem(
    name: 'Sale Jeans',
    description: 'Comfortable jeans on sale now.',
    price: 29.99,
    discount: 5.00,
    tags: ['clothing', 'jeans', 'discount'],
    imageUrl: 'https://example.com/images/sale_jeans.jpg',
  ),
  SalesProductItem(
    name: 'Clearance Jacket',
    description: 'A warm jacket available at clearance prices.',
    price: 49.99,
    discount: 10.00,
    tags: ['clothing', 'jacket', 'clearance'],
    imageUrl: 'https://example.com/images/clearance_jacket.jpg',
  ),
  SalesProductItem(
      name: 'Bracelet',
      description: 'An elegant bracelet perfect for any occasion.',
      price: 19.99,
      discount: 0.0,
      tags: ['jewelry', 'bracelet'],
      imageUrl: 'https://example.com/images/bracelet.jpg')
];

class ProductItemCard extends StatefulWidget {
  final SalesProductItem product;

  const ProductItemCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard> {
  bool _isHovering = false;

  void _setHover(bool hover) {
    if (_isHovering != hover) {
      setState(() {
        _isHovering = hover;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image (top) — clipped to top corners
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: GestureDetector(
              onTap: () {
                final slug = product.name.replaceAll(' ', '-').toLowerCase();
                Navigator.pushNamed(
                    context, '/collections/sales-product/$slug');
              },
              child: SizedBox(
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
            ),
          ),

          // Small white box that only wraps the text; rounded bottom corners to match the card.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: MouseRegion(
              onEnter: (_) => _setHover(true),
              onExit: (_) => _setHover(false),
              cursor: SystemMouseCursors.click,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                      decoration: _isHovering ? TextDecoration.underline : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '£${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '£${(product.price - product.discount).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
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
