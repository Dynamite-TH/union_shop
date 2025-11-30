import 'package:flutter/material.dart';
import 'package:union_shop/models/collections.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';
import 'package:union_shop/models/products.dart';

// Provide a fallback top-level 'product' list so this file compiles
// If your models/products.dart already exposes a product list (named 'product'),
// remove this fallback.

class ProductsScreen extends StatefulWidget {
  const ProductsScreen(
      {Key? key, required this.filter, required this.collections})
      : super(key: key);

  final String filter;
  final CollectionsItem collections;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late String filter = widget.filter;
  String? _selectedTag;
  List<ProductItem> _products = [];
  late CollectionsItem collections;
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 4);

    // display-friendly selected tag name

    final filtered = _products.where((p) {
      final isfiltered = p.category.contains(filter);
      if (_selectedTag == null) {
        return isfiltered;
      } else {
        return isfiltered && p.tags.contains(_selectedTag);
      }
    }).toList();

    final tags = _products
        .where((p) =>
            p.category.toLowerCase().trim() == filter.toLowerCase().trim())
        .expand((p) => p.tags)
        .toSet()
        .toList()
      ..sort();

    final dropdownWidth =
        screenWidth < 420 ? (screenWidth - 48).clamp(120.0, 320.0) : 200.0;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Text(
                  filter.toUpperCase().replaceAll('-', ' '),
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                widget.collections.description,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
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
                              ...tags
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
                            return ProductItemCard(
                              product: filtered[index],
                              route: '/collections/$filter/',
                            );
                          },
                        ),
                      ),
                    ),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}
