import 'package:flutter/material.dart';
import 'package:union_shop/Repositories/union_shop_repository.dart';
import 'package:union_shop/Repositories/cart_manager.dart';
import 'package:union_shop/models/products.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    // topBannerHeight + mainHeaderHeight should roughly match preferredSize.height
    const double topBannerHeight = 40.0;
    final double mainHeaderHeight = preferredSize.height - topBannerHeight;

    final screenWidth = MediaQuery.of(context).size.width;
    final logoWidth = (screenWidth * 5).clamp(56.0, 140.0);
    final menuFontSize = (screenWidth * 0.018).clamp(12.0, 18.0);
    final iconSize = (screenWidth * 0.02).clamp(16.0, 24.0);
    final iconPadding = (screenWidth * 0.01).clamp(6.0, 12.0);

    final bool isMobile = screenWidth < 600;

    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFF4d2963),
              child: const Text(
                'Free UK delivery on orders over £30',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            // Main header row
            Container(
              height: mainHeaderHeight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      UnionShopRepository().navigateToHome(context);
                    },
                    child: SizedBox(
                        width: logoWidth - 20,
                        height: mainHeaderHeight,
                        child: Image.network(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image_not_supported,
                                    color: Colors.grey),
                              ),
                            );
                          },
                        )),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isMobile) ...[
                          TextButton(
                            onPressed: () {
                              UnionShopRepository().navigateToHome(context);
                            },
                            child: Text(
                              'HOME',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: menuFontSize,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              UnionShopRepository().navigateToAboutUs(context);
                            },
                            child: Text(
                              'ABOUT US',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: menuFontSize,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              UnionShopRepository().navigateToSales(context);
                            },
                            child: Text(
                              'SALE!',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: menuFontSize,
                              ),
                            ),
                          )
                        ] else
                          ...[],
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            size: iconSize,
                            color: Colors.grey,
                          ),
                          padding: EdgeInsets.all(iconPadding),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: UnionShopRepository()
                              .placeholderCallbackForButtons,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.person_outline,
                            size: iconSize,
                            color: Colors.grey,
                          ),
                          padding: EdgeInsets.all(iconPadding),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () => UnionShopRepository()
                              .navigateToAuthentication(context),
                        ),
                        // Cart icon with live badge reflecting items in cart
                        AnimatedBuilder(
                          animation: CartManager.instance,
                          builder: (context, _) {
                            final count = CartManager.instance.items
                                .fold<int>(0, (s, i) => s + i.quantity);
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.shopping_bag_outlined,
                                    size: iconSize,
                                    color: Colors.grey,
                                  ),
                                  padding: EdgeInsets.all(iconPadding),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  onPressed: () => UnionShopRepository()
                                      .navigateToCart(context),
                                ),
                                if (count > 0)
                                  Positioned(
                                    // place badge at top right corner of the icon
                                    right: 4,
                                    top: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(2.5),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(
                                            color: Colors.white, width: 1.5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          count > 99 ? '99+' : count.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        if (isMobile) ...[
                          Builder(
                            builder: (menuContext) {
                              return IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                  size: menuFontSize * 1.6,
                                ),
                                padding: EdgeInsets.all(iconPadding),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                onPressed: () {
                                  final overlay = Overlay.of(menuContext)
                                      .context
                                      .findRenderObject() as RenderBox?;
                                  final appBarBox =
                                      context.findRenderObject() as RenderBox;
                                  final appBarOffset = appBarBox.localToGlobal(
                                      Offset.zero,
                                      ancestor: overlay);
                                  final top =
                                      appBarOffset.dy + appBarBox.size.height;

                                  // Show a full-width, top-positioned menu under the app bar
                                  showGeneralDialog(
                                    context: menuContext,
                                    barrierDismissible: true,
                                    barrierLabel: 'Menu',
                                    barrierColor: Colors.transparent,
                                    transitionDuration:
                                        const Duration(milliseconds: 150),
                                    pageBuilder:
                                        (ctx, animation, secondaryAnimation) {
                                      return Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            top: top,
                                            child: Material(
                                              color: Colors.white,
                                              elevation: 6,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(menuContext)
                                                          .pop();
                                                      UnionShopRepository()
                                                          .navigateToHome(
                                                              context);
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 14),
                                                      child: const Center(
                                                        child: Text(
                                                          'Home',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(height: 1),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(menuContext)
                                                          .pop();
                                                      UnionShopRepository()
                                                          .navigateToAboutUs(
                                                              context);
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 14),
                                                      child: const Center(
                                                        child: Text(
                                                          'About Us',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(height: 1),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(menuContext)
                                                          .pop();
                                                      UnionShopRepository()
                                                          .navigateToSales(
                                                              context);
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 14),
                                                      child: const Center(
                                                        child: Text(
                                                          'Sale!',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.all(24),
      child: const Text(
        'Contact Email: info@example.com / Phone: 123-456-7890 \n'
        '© 2024 Union Shop. All rights reserved. \n'
        'Privacy Policy | Terms of Service',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ProductItemCard extends StatefulWidget {
  final ProductItem product;
  final String? route;
  final List<String>? colours;
  final double? imageHeight;

  const ProductItemCard(
      {Key? key,
      required this.product,
      this.route,
      this.colours,
      this.imageHeight})
      : super(key: key);

  @override
  State<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard> {
  bool _isHovering = false;

  void _setHover(bool hover) {
    if (_isHovering != hover) {
      setState(() {
        _isHovering = hover;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image (top) — clipped to top corners
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: GestureDetector(
              onTap: () {
                final slug = product.name.replaceAll(' ', '-').toLowerCase();
                Navigator.pushNamed(context, '${widget.route}$slug');
              },
              child: SizedBox(
                height: widget.imageHeight ?? 250,
                width: double.infinity,
                child: Image.network(
                  product.image,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),

          // Small white box that only wraps the text; rounded bottom corners to match the card.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: MouseRegion(
              onEnter: (_) => _setHover(true),
              onExit: (_) => _setHover(false),
              cursor: SystemMouseCursors.click,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      final slug =
                          product.name.replaceAll(' ', '-').toLowerCase();
                      Navigator.pushNamed(context, '${widget.route}$slug');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                        decoration:
                            _isHovering ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '£${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          decoration: product.discount > 0
                              ? TextDecoration.lineThrough
                              : null,
                          color:
                              product.discount > 0 ? Colors.grey : Colors.black,
                          fontSize: product.discount > 0 ? 12 : 14,
                          fontWeight: product.discount > 0
                              ? FontWeight.w500
                              : FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      product.discount > 0
                          ? Text(
                              '£${(product.price - (product.price * (product.discount / 100))).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
