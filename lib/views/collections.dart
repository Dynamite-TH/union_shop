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
    return const Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(
                child: Text(
                  'Collections',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

const List<_CollectionItem> _demoCollections = [
  _CollectionItem('Autumn Favourites',
      'https://via.placeholder.com/800x800.png?text=Autumn'),
  _CollectionItem('Black Friday',
      'https://via.placeholder.com/800x800.png?text=Black+Friday'),
  _CollectionItem(
      'Clothing', 'https://via.placeholder.com/800x800.png?text=Clothing'),
  _CollectionItem(
      'Hoodies', 'https://via.placeholder.com/800x800.png?text=Hoodies'),
  _CollectionItem(
      'T-Shirts', 'https://via.placeholder.com/800x800.png?text=Tshirts'),
  _CollectionItem('Accessories',
      'https://via.placeholder.com/800x800.png?text=Accessories'),
];

class _CollectionItem {
  final String title;
  final String imageUrl;

  const _CollectionItem(this.title, this.imageUrl);
}

class CollectionsCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const CollectionsCard({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
