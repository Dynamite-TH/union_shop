import 'package:flutter/material.dart';
import 'package:union_shop/Repositories/union_shop_repository.dart';
import 'package:union_shop/views/about_us.dart';
import 'package:union_shop/views/collections.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';
import 'package:union_shop/views/products_page.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/views/not_found.dart';
import 'package:union_shop/views/cart.dart';
import 'package:union_shop/models/products.dart';
import 'package:union_shop/models/collections.dart';
import 'package:union_shop/views/authentication.dart';

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
        '/cart': (context) => const CartScreen(),
        '/authentication': (context) => const AuthenticationScreen(),
      },
      // Dynamic routes (e.g. /collections/<collection-slug> or /collections/<collection-slug>/<product-slug>)
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        const collectionsPrefix = '/collections/';

        // Only handle routes that start with /collections/
        if (!name.startsWith(collectionsPrefix)) return null;

        // Get the path after /collections/ and split into non-empty segments
        final rest = name.substring(collectionsPrefix.length);
        final parts = rest.split('/').where((s) => s.isNotEmpty).toList();

        // If no parts (route was exactly '/collections' or '/collections/'), let the named route handling take precedence
        if (parts.isEmpty) return null;

        // If there are two or more segments, treat the last segment as a product slug
        if (parts.length >= 2) {
          final productSlug = parts.last.trim().toLowerCase();
          debugPrint('Attempting to find product for slug: $productSlug');
          try {
            final matched = _products.firstWhere((p) =>
                p.name.replaceAll(' ', '-').toLowerCase() == productSlug);
            final colours = matched.colors;
            return MaterialPageRoute(
              builder: (context) => ProductPage(
                product: matched,
                colours: colours,
              ),
              settings: settings,
            );
          } catch (_) {
            // Not found — show 404
            return MaterialPageRoute(
              builder: (context) => const PageNotFoundScreen(),
              settings: settings,
            );
          }
        }

        // Single segment after /collections/ — treat as a collection page
        final slug = parts.first.trim().toLowerCase();
        debugPrint('Navigating to collections with slug: $slug');
        return MaterialPageRoute(
          builder: (context) => ProductsScreen(
            filter: slug,
            collections: _collections.firstWhere(
                (c) => c.name.replaceAll(' ', '-').toLowerCase() == slug,
                orElse: () => CollectionsItem(
                    id: '', name: 'Unknown', description: '', image: '')),
          ),
          settings: settings,
        );
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
List<CollectionsItem> _collections = [];

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
    final collectionsLoaded = await loadCollectionsFromAsset();
    debugPrint('Loaded ${loaded.length} products for sales page');
    for (final p in loaded) {
      debugPrint(
        'Product: ${p.name}, Tags: ${p.tags}, Category: ${p.category}, Colors: ${p.colors}',
      );
    }
    // (no-op) collection slugs available via _collections when needed
    if (mounted) {
      setState(() {
        _products = loaded;
        _collections = collectionsLoaded;
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

    final promotionalFiltered = _products.where((p) {
      final isPromotional = p.category.contains('promotional');
      return isPromotional;
    }).toList();

    final accessoryFiltered = _products.where((p) {
      final isAccessory = p.category.contains('accessories');
      return isAccessory;
    }).toList();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sales Section
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
                          image: AssetImage(
                            'assets/images/collections/accessories.png',
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
                          'Accessories',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Explore our range of university-themed accessories, perfect for students and staff alike.",
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
                            UnionShopRepository().navigateToAccesories(context);
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
                      'UNIVERSITY ESSENTIALS',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: promotionalFiltered.isEmpty
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
                                  itemCount: promotionalFiltered.length,
                                  itemBuilder: (context, index) {
                                    // keep using the existing ProductItemCard; the larger grid tiles will make the image and text display like the reference
                                    while (index < 2) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0),
                                        child: ProductItemCard(
                                          product: promotionalFiltered[index],
                                          // provide the full slugged route so onGenerateRoute can match:
                                          route:
                                              '/collections/promotional-product/',
                                          // pass available colours from the loaded products
                                          // (this will allow the card / navigation logic to forward colors directly)
                                          colours:
                                              promotionalFiltered[index].colors,
                                          imageHeight: 400,
                                        ),
                                      );
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    const Text(
                      'ACCESSORIES',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: accessoryFiltered.isEmpty
                          ? const Center(
                              child: Text('No accessory products available.'))
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
                                    crossAxisSpacing: 18, // more breathing room
                                    mainAxisSpacing: 16,
                                    // increase tile height so images are larger relative to text
                                    childAspectRatio: 0.9,
                                  ),
                                  itemCount: accessoryFiltered.length,
                                  itemBuilder: (context, index) {
                                    // keep using the existing ProductItemCard; the larger grid tiles will make the image and text display like the reference
                                    while (index < 2) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 6.0),
                                        child: ProductItemCard(
                                          product: accessoryFiltered[index],
                                          // provide the full slugged route so onGenerateRoute can match:
                                          route:
                                              '/collections/accessory-product/',
                                          // pass available colours from the loaded products
                                          // (this will allow the card / navigation logic to forward colors directly)
                                          colours:
                                              accessoryFiltered[index].colors,
                                          imageHeight: 400,
                                        ),
                                      );
                                    }
                                    return null;
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
