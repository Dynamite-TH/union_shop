import 'package:flutter/material.dart';
import 'package:union_shop/Repositories/union_shop_repository.dart';

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
    final logoWidth = (screenWidth * 0.12).clamp(56.0, 140.0);
    final menuFontSize = (screenWidth * 0.018).clamp(12.0, 18.0);
    final iconSize = (screenWidth * 0.02).clamp(16.0, 24.0);
    final iconPadding = (screenWidth * 0.01).clamp(6.0, 12.0);

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
                        width: logoWidth,
                        child: Image.network(
                          'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
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
                          onPressed: UnionShopRepository()
                              .placeholderCallbackForButtons,
                        ),
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
                          onPressed: UnionShopRepository()
                              .placeholderCallbackForButtons,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: iconSize,
                            color: Colors.grey,
                          ),
                          padding: EdgeInsets.all(iconPadding),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
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
