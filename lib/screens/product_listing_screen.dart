import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../providers/cart_provider.dart';

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100), // padding for appbar
                _buildHeroSection(context),
                _buildFiltersAndSorting(context),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: _buildProductGrid(context),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 64),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F3D56),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    elevation: 8,
                  ),
                  child: Text(
                    'LOAD MORE DISCOVERIES',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100), // padding for bottom nav
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withValues(alpha: 0.8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.redAccent),
                    onPressed: () {},
                  ),
                  Text(
                    'MARCO POLO',
                    style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Noto Serif',
                      fontSize: 20,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.redAccent),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart');
                        },
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final cartItems = ref.watch(cartProvider);
                          final itemCount = cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
                          if (itemCount == 0) return const SizedBox();
                          return Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$itemCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summer Collection',
            style: AppTheme.lightTheme.textTheme.displayLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Discover our curated selection of seasonal essentials, blending modern aesthetics with timeless craftsmanship for the discerning individual.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSorting(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 768;
          
          final filterChips = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All Styles', isActive: true),
                const SizedBox(width: 8),
                _buildFilterChip('Outerwear'),
                const SizedBox(width: 8),
                _buildFilterChip('Knitwear'),
                const SizedBox(width: 8),
                _buildFilterChip('Accessories'),
                const SizedBox(width: 8),
                _buildFilterChip('Footwear'),
              ],
            ),
          );

          final sortingDropdown = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SORT BY:',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.tertiary,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: 'Recommended',
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                underline: const SizedBox(),
                onChanged: (String? value) {},
                items: <String>[
                  'Recommended',
                  'Price: Low to High',
                  'Price: High to Low',
                  'Newest First'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          );

          if (isDesktop) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: filterChips),
                sortingDropdown,
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                filterChips,
                const SizedBox(height: 16),
                const Divider(),
                sortingDropdown,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.onSecondaryFixedVariant : AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: isActive ? null : Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: isActive ? Colors.white : AppTheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.crossAxisExtent >= 1280) {
          crossAxisCount = 4;
        } else if (constraints.crossAxisExtent >= 1024) {
          crossAxisCount = 3;
        } else if (constraints.crossAxisExtent >= 640) {
          crossAxisCount = 2;
        }

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.55, // Adjusted to fit image and text
          ),
          delegate: SliverChildListDelegate([
            _buildGridProductCard(
              context,
              'Minimalist Linen Trench',
              'Mauve Sand Edition',
              '\$245.00',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDhD1QfgeoUClnDhKqs2cD8lp2rs9Jm_KaUezxjhLHSmeAfIiBy-gBVkFk4UeTG5QFIwVOob-yHwWkv4lrofHKkDvC-sQ2n5CClz4yKdDJTYcGbxLwaxEd3OqHqDcoC8RST4Og6Gx6sJkR04UjqZkO-Gk8gzH7OQLd1yQPW5t9jY90ZQy2WMaW9DK6YDLsXOH__gkspXpfnF5mQEhN8019UKkLSmC_J67gi59Rxur3NTIzgedDYFtN5dZdoMMeXJ9-QVkFuqlOAa_M',
              tag: 'New In',
              colors: [const Color(0xFFD1C3C8), const Color(0xFF3F3D56)],
            ),
            _buildGridProductCard(
              context,
              'Structured Silk Blazer',
              'Plum Noir',
              '\$310.00',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCjKpbecHfJ7NZqHxbw8e9jhDfSFcSf_zdcUmeikZSw3LmEwkwrKIT-kKi9ZOg7PWIVwR3KTfJI_oHy2eXIC7s-7V2VkiuKX_-kPaeQ8zkKKedVQ1Bl3Kd46CZbF4F3_LX8pL7dIFcKnZ0OgJU2fS3AGASTFr_hYihbwtHJ3xj3jNSxmkELTXOVL8TkxT_WQRz_7l_Uedxa7C42GVDxajc_LX4pdp0ZPjgM0KClOGomwohiA824wL8Gzn0KgQMll8J-SBPWq0U7WTM',
              colors: [const Color(0xFF5E5B76)],
            ),
            _buildGridProductCard(
              context,
              'Cashmere Blend Knit',
              'Soft Lavender',
              '\$180.00',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDyaynUajNmFboJQy1Zdyuxp3yw-O0tpA2jPcdyGeSzXTAyDtQQGLr6bSqerBJI3Z7iR7D8i3A3WVulJmNvk3Ei_fulJNGFnxS9d_masbaaCjYAhgLxvWQvn0lRJ8FeJif6kkxdqSpNcaIlqVGvjw5zUv6MeFmy-Bm8GTeifHkpQSX8seYBzvLz0eRSkSRbMDrvrZgzgVi4f4Js4-2vaoBA0hrW8Zs6k6PQ3icXRH56oO_yGWxEBykFqAsMvUoZiwOIi9FFtBtKRe8',
              oldPrice: '\$225.00',
              tag: '20% Off',
              colors: [const Color(0xFFE2BCCF)],
            ),
            _buildGridProductCard(
              context,
              'Signature Leather Tote',
              'Deep Espresso',
              '\$450.00',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDm7pQm4W6gmNrFLetTdt_VRMTaoR_oURB40fiZS88HefJtl-HY-X1TpfXBsIb4qbPbDcPf3IEfN8a6huvElLFodzyixw5-AmM-wWQvWTTg1CbJ3cBTyEFCUbQKAznmwfiH3cKJEYvDvg0A-ETlxHJv5TYgNe3IhB1byxin6VQcSBWoCBiUAS9GSz-nYOXIY2156J0i69Zgm6K37AN5N0BaEHW5UokN7Aswwrb38pJDVaelRI7h3iG-1zPzHPmMUwDI3m1bfTqqO9k',
              colors: [const Color(0xFF1A1C1C)],
            ),
            _buildGridProductCard(
              context,
              'Pleated Wool Trousers',
              'Ivory Mist',
              '\$195.00',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDfLMDKhc17IjzEvmSlUBgK8moFz4aYsncOCVYBAHPgoTgmXk5LeqMXCrhMhQV6stkC-IVC7AwAdwKy0iX6HKrPTQw7hU0EYH7dLYLd83g5Fv8sF6Z5yNycjOocWHcMwvVv8xjhFwG0guqnQcKR6P-vAX88nu51cbjrSkLYXjxz-Zjr0y2yNM0KrCfm1KBNKq9MMRNP_pXtoIiIgEeu-J2Zcs0aiVl79MY_c9Cfv-_0d2L1KbuUuguVV_hdu1vH1G1yrTLGmvjmLFA',
            ),
            _buildGridProductCard(
              context,
              'Hand-Burnished Loafers',
              'Classic Tan',
              '\$285.00',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA393dsK1VgvzVB6GCQCQb1zDbazm1jw2BETNKTlFNVm1jL0SFWiowTnu89p9PccaO5yqgmA2ca8f61eNEAoCU3Xej-HxSuoM6K3XkRv_f1HtOTZ640eoRx4Y6EmHie4PtwM5ppf39bvcjdnc5G6RY4MD8VMAukbqcDOT0wYZbfUZqU0OaE8wD8Ws54Ct58oOSatoM6ykvFyVhOj5Qem7Cn5K2w5UgpmAPz1zc-VNUDl907rLWMJp-3OO1Qju6kuIP58glHRSt4854',
            ),
          ]),
        );
      },
    );
  }

  Widget _buildGridProductCard(
    BuildContext context,
    String title,
    String subtitle,
    String price,
    String imageUrl, {
    String? tag,
    String? oldPrice,
    List<Color>? colors,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details');
      },
      child: Container(
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143F3D56),
            blurRadius: 30,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                if (tag != null)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryFixedDim,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        tag.toUpperCase(),
                        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.onPrimaryFixed,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, color: AppTheme.secondary, size: 20),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.tertiary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          price,
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (oldPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            oldPrice,
                            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.tertiary,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (colors != null)
                      Row(
                        children: colors.map((color) {
                          return Container(
                            margin: const EdgeInsets.only(left: 4),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(top: BorderSide(color: AppTheme.surfaceContainerHighest)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143F3D56),
            blurRadius: 20,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.search, 'Explore', false, () {
                Navigator.pushReplacementNamed(context, '/home');
              }),
              _buildNavItem(Icons.auto_awesome_motion, 'Collections', true, () {
                // Already on Collections
              }),
              _buildNavItem(Icons.favorite_border, 'Wishlist', false, () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wishlist coming soon!')));
              }),
              _buildNavItem(Icons.person_outline, 'Account', false, () {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Icon(
          icon,
          color: isActive ? Colors.redAccent : AppTheme.outline, // text-rose-400
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.redAccent : AppTheme.outline,
          ),
        ),
        if (isActive) ...[
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    ),
    );
  }
}
