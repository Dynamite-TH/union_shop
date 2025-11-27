import 'package:flutter/foundation.dart';
import 'package:union_shop/views/sales_product_page.dart';

class CartItem {
  final SalesProductItem product;
  String color;
  String size;
  int quantity;

  CartItem({
    required this.product,
    this.color = 'Default',
    this.size = 'M',
    this.quantity = 1,
  });

  double get unitPrice => (product.price - product.discount).clamp(0.0, double.infinity);
  double get total => unitPrice * quantity;
}

class CartManager extends ChangeNotifier {
  CartManager._private();

  static final CartManager instance = CartManager._private();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    // If same product + color + size already in cart, increase quantity
    final existing = _items.indexWhere((e) => e.product.name == item.product.name && e.color == item.color && e.size == item.size);
    if (existing >= 0) {
      _items[existing].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    final idx = _items.indexOf(item);
    if (idx >= 0) {
      _items[idx].quantity = newQuantity.clamp(1, 9999);
      notifyListeners();
    }
  }

  void updateColor(CartItem item, String color) {
    final idx = _items.indexOf(item);
    if (idx >= 0) {
      _items[idx].color = color;
      notifyListeners();
    }
  }

  double get total => _items.fold(0.0, (s, i) => s + i.total);

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
