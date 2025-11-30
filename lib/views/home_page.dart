import 'package:flutter/material.dart';
import 'package:union_shop/Repositories/union_shop_repository.dart';
import 'package:union_shop/views/about_us.dart';
import 'package:union_shop/views/collections.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';
import 'package:union_shop/views/sales_product_page.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/views/not_found.dart';
import 'package:union_shop/views/cart.dart';
import 'package:union_shop/models/products.dart';

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const HomeScreen(),
      // By default, the app starts at the '/' route, which is the HomeScreen
      initialRoute: '/',
      // When navigating to '/product', build and return the ProductPage
      // In your browser, try this link: http://localhost:49856/#/product
      routes: {
        '/about_us': (context) => const AboutUsScreen(),
        '/collections': (context) => const CollectionsScreen(),
        '/collections/sales-product': (context) => const SalesProductScreen(),
        '/cart': (context) => const CartScreen(),
      },
      // Dynamic routes (e.g. /collections/sales-product/<product-slug>)
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        const prefix = '/collections/sales-product/';
        if (name.startsWith(prefix) || name.startsWith('/')) {
          final slug = name.substring(prefix.length);
          // Try to find the product with a matching slug
          try {
            final matched = _products.firstWhere(
                (p) => p.name.replaceAll(' ', '-').toLowerCase() == slug);
            return MaterialPageRoute(
              builder: (context) => ProductPage(product: matched),
              settings: settings,
            );
          } catch (_) {
            // Not found — fall through to unknown route
            return MaterialPageRoute(
              builder: (context) => const PageNotFoundScreen(),
              settings: settings,
            );
          }
        }
        return null;
      },
      // If a route is not found, show the 404 page
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const PageNotFoundScreen(),
          settings: settings,
        );
      },
    );
  }
}

List<ProductItem> _products = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  // store loaded products for use in build
  @override
  void initState() {
    super.initState();
    // start async tag loading
    _initTags();
  }

  Future<void> _initTags() async {
    // collect unique tags from asynchronously loaded products
    final loaded = await loadProductsFromAsset();
    debugPrint('Loaded ${loaded.length} products for sales page');
    for (final p in loaded) {
      debugPrint(
        'Product: ${p.name}, Tags: ${p.tags}, Category: ${p.category}',
      );
    }
    if (mounted) {
      setState(() {
        _products = loaded;
      });
    }
  }

  void placeholderCallbackForButtons() {
    UnionShopRepository().placeholderCallbackForButtons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                  // Content overlay
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Hero Collection',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Discover our exclusive range of products celebrating the spirit of Portsmouth. From apparel to accessories, find the perfect item to showcase your love for the city.",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            UnionShopRepository()
                                .navigateToCollections(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4d2963),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'BROWSE PRODUCTS',
                            style: TextStyle(fontSize: 14, letterSpacing: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products Section
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text(
                      'PRODUCTS SECTION',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 48),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 48,
                      children: [],
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              color: Colors.grey[50],
              padding: const EdgeInsets.all(24),
              child: const Text(
                'Contact Email: info@example.com / Phone: 123-456-7890 \n'
                '© 2024 Union Shop. All rights reserved. \n'
                'Privacy Policy | Terms of Service',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sample sales products data
class ProductItemCard extends StatefulWidget {
  final ProductItem product;

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
                height: 350,
                width: double.infinity,
                child: Image.network(
                  product.image,
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
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        textStyle: WidgetStateProperty.all(
                          TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black,
                            decoration:
                                _isHovering ? TextDecoration.underline : null,
                          ),
                        ),
                      ),
                      onPressed: () {
                        final slug =
                            product.name.replaceAll(' ', '-').toLowerCase();
                        Navigator.pushNamed(
                            context, '/collections/sales-product/$slug');
                      },
                      child: Text(product.name)),
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
