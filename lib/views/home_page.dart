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
        '/collections/sales-product': (context) => const ProductsScreen(),
        '/cart': (context) => const CartScreen(),
      },
      // Dynamic routes (e.g. /collections/sales-product/<product-slug>)
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        const prefix = '/collections/sales-product/';
        const promoPrefix = '/collections/promotional-product/';
        if (name.startsWith(prefix) || name.startsWith(promoPrefix)) {
          final slug = name.startsWith(prefix)
              ? name.substring(prefix.length)
              : name.substring(promoPrefix.length);

          // Try to find the product with a matching slug
          try {
            final matched = _products.firstWhere(
                (p) => p.name.replaceAll(' ', '-').toLowerCase() == slug);
            final colours = matched.colors;
            return MaterialPageRoute(
              builder: (context) => ProductPage(
                product: matched,
                colours: colours,
              ),
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
        'Product: ${p.name}, Tags: ${p.tags}, Category: ${p.category}, Colors: ${p.colors}',
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
    final screenWidth = MediaQuery.of(context).size.width;
    // Show 1 column on very small screens, and 2 columns for wider screens
    final crossAxisCount = screenWidth < 600 ? 1 : 2;

    final filtered = _products.where((p) {
      final isPromotional =
          p.category.toLowerCase().trim() == 'promotional'.toLowerCase();
      return isPromotional;
    }).toList();

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
                        decoration: const BoxDecoration(
                          // dim the background so overlay text is readable
                          color: Color(0xB3000000),
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
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: filtered.isEmpty
                          ? const Center(
                              child: Text('No promotional products available.'))
                          : Center(
                              child: ConstrainedBox(
                                // Keep the grid centered and readable on wide screens
                                // narrower maxWidth makes two items appear larger and centered like the design
                                constraints:
                                    const BoxConstraints(maxWidth: 900),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 12, // more breathing room
                                    mainAxisSpacing: 16,
                                    // increase tile height so images are larger relative to text
                                    childAspectRatio: 0.9,
                                  ),
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    // keep using the existing ProductItemCard; the larger grid tiles will make the image and text display like the reference
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 6.0),
                                      child: ProductItemCard(
                                        product: filtered[index],
                                        // provide the full slugged route so onGenerateRoute can match:
                                        route:
                                            '/collections/promotional-product/',
                                        // pass available colours from the loaded products
                                        // (this will allow the card / navigation logic to forward colors directly)
                                        colours: filtered[index].colors,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}
