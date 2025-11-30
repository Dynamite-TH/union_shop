import 'package:flutter/material.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';

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
  @override
  void initState() {
    super.initState();
    // Any initialization if needed
  }

  @override
  Widget build(BuildContext context) {
    // filter items by selected tag (null = all)

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

            // Grid or empty message
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: _demoCollections.length,
                itemBuilder: (context, index) {
                  final collection = _demoCollections[index];
                  return CollectionsCard(
                    imageUrl: collection.imageUrl,
                    title: collection.title,
                    route: collection.route,
                    onTap: () {
                      Navigator.pushNamed(context, collection.route);
                    },
                  );
                },
              ),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}

const List<_CollectionItem> _demoCollections = [
  _CollectionItem(
      'Autumn Favourites',
      '/assets/images/collections/autumn_favourites.png',
      '/collections/autumn-favourites',
      ['autumn', 'fall', 'clothing']),
  _CollectionItem('Sales', '/assets/images/collections/sales.png',
      '/collections/sales', ['discount', 'clothing', 'accessories']),
  _CollectionItem('Hoodies', '', 'collections/hoodies',
      ['hoodies', 'sweatshirts', 'clothing']),
  _CollectionItem(
      'T-Shirts', '', '/collections/t-shirts', ['tshirt', 'tees', 'clothing']),
  _CollectionItem(
      'Accessories', '', '/collections/accessories', ['accessories']),
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
