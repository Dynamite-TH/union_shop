import 'package:flutter/material.dart';
import 'package:union_shop/views/widgets/appbar.dart';
import 'package:union_shop/views/widgets/drawer.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const CollectionsScreen(),
      initialRoute: '/collections',
    );
  }
}

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({Key? key}) : super(key: key);

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  String? _selectedTag;
  late List<String> _allTags;

  @override
  void initState() {
    super.initState();
    // collect unique tags from demo data
    final tagSet = <String>{};
    for (final c in _demoCollections) {
      tagSet.addAll(c.tags);
    }
    _allTags = tagSet.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    // filter items by selected tag (null = all)
    final filtered = _selectedTag == null
        ? _demoCollections
        : _demoCollections.where((c) => c.tags.contains(_selectedTag)).toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 4);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(
                child: Text(
                  'Collections',
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

            // Tag filter chips (horizontal)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedTag == null,
                        selectedColor: const Color(0xFF4d2963),
                        onSelected: (sel) {
                          setState(() {
                            _selectedTag = null;
                          });
                        },
                        labelStyle: TextStyle(
                          color: _selectedTag == null
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ..._allTags.map((tag) {
                      final selected = _selectedTag == tag;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(tag),
                          selected: selected,
                          selectedColor: const Color(0xFF4d2963),
                          onSelected: (sel) {
                            setState(() {
                              _selectedTag = sel ? tag : null;
                            });
                          },
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            // Grid or empty message
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Text(
                          'No collections match "$_selectedTag"',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final collection = filtered[index];
                        return CollectionsCard(
                          imageUrl: collection.imageUrl,
                          title: collection.title,
                          route: collection.route,
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/collections${collection.route}');
                          },
                        );
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

const List<_CollectionItem> _demoCollections = [
  _CollectionItem(
      'Autumn Favourites',
      '/assets/images/collections/autumn_favourites.png',
      '/',
      ['autumn', 'fall', 'clothing']),
  _CollectionItem('Sales', '/assets/images/collections/sales.png',
      '/sales-product', ['discount', 'clothing', 'accessories']),
  _CollectionItem('Hoodies', '', '/', ['hoodies', 'sweatshirts', 'clothing']),
  _CollectionItem('T-Shirts', '', '/', ['tshirt', 'tees', 'clothing']),
  _CollectionItem('Accessories', '', '/about_us', ['accessories']),
];

class _CollectionItem {
  final String title;
  final String imageUrl;
  final String route;
  final List<String> tags;

  const _CollectionItem(this.title, this.imageUrl, this.route, this.tags);
}

class CollectionsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String route;
  final VoidCallback? onTap;

  const CollectionsCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.route = '/',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: Stack(
          children: [
            Positioned.fill(
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                              child: Text(
                                  'Image not available - page for $title',
                                  style: const TextStyle(color: Colors.grey))),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          'image not available - page for $title',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black54),
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
