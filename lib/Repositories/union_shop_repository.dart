import 'package:flutter/material.dart';

class UnionShopRepository {
  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  void navigateToCollections(BuildContext context) {
    Navigator.pushNamed(context, '/collections');
  }

  void navigateToAboutUs(BuildContext context) {
    Navigator.pushNamed(context, '/about_us');
  }

  void navigateToSales(BuildContext context) {
    Navigator.pushNamed(context, 'collections/sales');
  }

  void navigateToCart(BuildContext context) {
    Navigator.pushNamed(context, '/cart');
  }

  void navigateToAuthentication(BuildContext context) {
    Navigator.pushNamed(context, '/authentication');
  }



  void placeholderCallbackForButtons() {
    // Placeholder function for buttons without functionality
  }
}
