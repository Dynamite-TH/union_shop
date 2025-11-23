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
      initialRoute: 'collections/sales_product',
    );
  }
}

class SalesProductScreen extends StatelessWidget {
  const SalesProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      drawer: AppDrawer(),
      body: Center(
        child: Text('This is the Sales Product Page.'),
      ),
    );
  }
}
