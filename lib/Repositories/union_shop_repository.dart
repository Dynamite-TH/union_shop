import 'package:flutter/material.dart';
class UnionShopRepository {

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product_page');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }
}