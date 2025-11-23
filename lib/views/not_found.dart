import 'package:flutter/material.dart';
import 'package:union_shop/views/widgets/drawer.dart';
import 'package:union_shop/views/widgets/appbar.dart';

/// A simple page shown when the app cannot find a route (404).
class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text('404 - The page you are looking for does not exist.'),
      ),
      drawer: AppDrawer(),
    );
  }
}
