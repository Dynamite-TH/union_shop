import 'package:flutter/material.dart';
import 'package:union_shop/views/widgets/appbar.dart';
import 'package:union_shop/views/widgets/drawer.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/Repositories/cart_manager.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const CartScreen(),
      initialRoute: '/cart',
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = CartManager.instance;

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const AppDrawer(),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          final items = cart.items;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Your cart is empty.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to shopping'),
                  )
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final ci = items[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              ci.product.imageUrl,
                              width: 92,
                              height: 92,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                width: 92,
                                height: 92,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ci.product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text(ci.product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.black54)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text('£${ci.unitPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => cart.removeItem(ci),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Controls: color, size, quantity
                                Row(
                                  children: [
                                    // Color
                                    DropdownButton<String>(
                                      value: ci.color,
                                      items: ['Light Blue', 'Black', 'White', 'Default']
                                          .map((c) => DropdownMenuItem(
                                                value: c,
                                                child: Text(c),
                                              ))
                                          .toList(),
                                      onChanged: (v) {
                                        if (v != null) cart.updateColor(ci, v);
                                      },
                                    ),
                                    const SizedBox(width: 12),

                                    // Quantity controls
                                    Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(6)),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () => cart.updateQuantity(ci, ci.quantity - 1),
                                            padding: EdgeInsets.zero,
                                            visualDensity: VisualDensity.compact,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text('${ci.quantity}'),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () => cart.updateQuantity(ci, ci.quantity + 1),
                                            padding: EdgeInsets.zero,
                                            visualDensity: VisualDensity.compact,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Footer: totals + checkout
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey[50], borderRadius: BorderRadius.circular(6)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text('Total: £${cart.total.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm checkout'),
                              content: Text('Pay £${cart.total.toStringAsFixed(2)} now?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Confirm')),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            // Simulate checkout
                            final total = cart.total;
                            cart.clear();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Checked out £${total.toStringAsFixed(2)}. Thank you!')));
                          }
                        },
                        child: const Text('CHECKOUT'),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
