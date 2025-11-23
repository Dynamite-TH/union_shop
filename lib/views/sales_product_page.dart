import 'package:flutter/material.dart';

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
      initialRoute: '/sales_product',
    );
  }
}

class SalesProductScreen extends StatelessWidget {
  const SalesProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Product Page'),
      ),
      body: const Center(
        child: Text('This is the Sales Product Page.'),
      ),
    );
  }
}
