import 'package:flutter/material.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';
import 'package:union_shop/Repositories/cart_manager.dart';
import 'package:union_shop/models/products.dart';

class ProductPage extends StatefulWidget {
  final ProductItem? product;

  const ProductPage({super.key, this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;

  final _availableColors = ['Light Blue', 'Black', 'White'];
  final _availableSizes = ['S', 'M', 'L', 'XL'];

  @override
  void initState() {
    super.initState();
    _selectedColor = _availableColors.first;
    _selectedSize = _availableSizes[1];
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product ??
        ProductItem(
          category: 'uncategorized',
          id: 'placeholder',
          name: 'Placeholder Product',
          description:
              'This is a placeholder product description. Students should replace this with actual product data.',
          price: 0.0,
          discount: 0.0,
          image:
              'https://via.placeholder.com/600x400.png?text=Placeholder+Image',
        );
    final salePrice = (p.price - p.discount).clamp(0.0, double.infinity);

    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800;

    Widget imageColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            p.image,
            width: isWide ? (screenWidth * 0.45) : double.infinity,
            height: isWide ? 420 : 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              width: isWide ? (screenWidth * 0.45) : double.infinity,
              height: isWide ? 420 : 300,
              child: const Center(
                child: Icon(Icons.image_not_supported,
                    size: 64, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              // For now reuse main image as thumbnails
              return Container(
                width: 72,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    p.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[200]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );

    Widget detailsColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.name,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (p.discount > 0)
              Text(
                '£${p.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              ),
            if (p.discount > 0) const SizedBox(width: 12),
            Text(
              '£${salePrice.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4d2963)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Tax included.', style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 24),

        // Options row: color, size, quantity
        Row(
          children: [
            // Color
            Expanded(
              flex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Color', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedColor,
                        items: _availableColors
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedColor = v),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Size
            Expanded(
              flex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Size', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSize,
                        items: _availableSizes
                            .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedSize = v),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Quantity
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quantity',
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => setState(() {
                            if (_quantity > 1) _quantity--;
                          }),
                        ),
                        Text('$_quantity',
                            style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() {
                            _quantity++;
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF4d2963),
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: Color(0xFF4d2963)),
          ),
          onPressed: () async {
            // Build a cart item from the product and current selections
            final item = CartItem(
              product: p,
              color: _selectedColor ?? 'Default',
              size: _selectedSize ?? 'M',
              quantity: _quantity,
            );

            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Add to cart'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('Color: ${item.color}'),
                    Text('Size: ${item.size}'),
                    Text('Quantity: ${item.quantity}'),
                    const SizedBox(height: 8),
                    Text('Total: £${item.total.toStringAsFixed(2)}'),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Add')),
                ],
              ),
            );

            if (confirmed == true) {
              CartManager.instance.addItem(item);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Added to cart')));
            }
          },
          child: const Text('ADD TO CART',
              style: TextStyle(fontWeight: FontWeight.w700)),
        ),

        const SizedBox(height: 12),

        const SizedBox(height: 20),

        const Text('Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(p.description,
            style:
                const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5)),
      ],
    );

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: imageColumn),
                    const SizedBox(width: 32),
                    Expanded(flex: 5, child: detailsColumn),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageColumn,
                    const SizedBox(height: 16),
                    detailsColumn
                  ],
                ),
        ),
      ),
      // Footer (keep placeholder footer to match student exercises/tests)
      bottomNavigationBar: const FooterWidget(),
    );
  }
}
