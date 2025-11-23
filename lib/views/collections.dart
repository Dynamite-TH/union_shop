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
      home: const CollectionsPage(),
      // By default, the app starts at the '/' route, which is the HomeScreen
      initialRoute: '/collections',
    );
  }
}

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: _demoCollections.length,
                itemBuilder: (context, index) {
                  final collection = _demoCollections[index];
                  return CollectionsCard(
                    imageUrl: collection.imageUrl,
                    title: collection.title,
                    onTap: () {
                      Navigator.of(context).pushNamed(collection.route);
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
  _CollectionItem('Autumn Favourites',
      '/assets/images/collections/autumn_favourites.png', '/'),
  _CollectionItem(
      'Sales', '/assets/images/collections/black_friday_deals.png', '/'),
  _CollectionItem('Hoodies', '', '/'),
  _CollectionItem('T-Shirts', '', '/'),
  _CollectionItem('Accessories', '', '/about_us'),
];

class _CollectionItem {
  final String title;
  final String imageUrl;
  final String route;

  const _CollectionItem(this.title, this.imageUrl, this.route);
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
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          title,
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
