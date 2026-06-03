import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 96), // padding for appbar
              _buildHeader(ref),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 768) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildItemsList(ref)),
                        const SizedBox(width: 32),
                        Expanded(flex: 5, child: _buildOrderSummary(context, ref)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildItemsList(ref),
                        const SizedBox(height: 32),
                        _buildOrderSummary(context, ref),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 64),
              _buildCompleteYourLook(),
              const SizedBox(height: 100), // padding for bottom nav
            ],
          ),
        ),
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
                    icon: const Icon(Icons.arrow_back, color: Colors.redAccent),
                    onPressed: () => Navigator.pop(context),
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
                        onPressed: () {},
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final itemCount = ref.watch(cartProvider.notifier).itemCount;
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

  Widget _buildHeader(WidgetRef ref) {
    final itemCount = ref.watch(cartProvider.notifier).itemCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Shopping Bag',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$itemCount ITEMS SELECTED',
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList(WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    
    if (cartItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Text(
          'Your cart is empty',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.outline,
          ),
        ),
      );
    }
    
    return Column(
      children: cartItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCartItem(item, ref),
        );
      }).toList(),
    );
  }

  Widget _buildCartItem(CartItem item, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceContainerLow),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D3F3D56),
            blurRadius: 20,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 96,
            height: 128,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(item.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 128,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: AppTheme.lightTheme.textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.variant.toUpperCase(),
                              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                                color: AppTheme.secondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close, size: 20, color: AppTheme.outline),
                        onPressed: () {
                          ref.read(cartProvider.notifier).removeItem(item.id, item.variant);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.outlineVariant),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref.read(cartProvider.notifier).updateQuantity(item.id, item.variant, item.quantity - 1);
                              },
                              child: const Icon(Icons.remove, size: 18, color: AppTheme.onSurfaceVariant),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              item.quantity.toString().padLeft(2, '0'),
                              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                                color: AppTheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                ref.read(cartProvider.notifier).updateQuantity(item.id, item.variant, item.quantity + 1);
                              },
                              child: const Icon(Icons.add, size: 18, color: AppTheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
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

  Widget _buildOrderSummary(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(cartProvider.notifier).subtotal;
    final shipping = subtotal > 0 ? 15.00 : 0.00;
    final tax = subtotal * 0.08;
    final total = subtotal + shipping + tax;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          _buildSummaryRow('Shipping', subtotal > 0 ? '\$${shipping.toStringAsFixed(2)}' : 'Calculated at checkout'),
          const SizedBox(height: 16),
          _buildSummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 24),
          const Divider(color: AppTheme.outlineVariant),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.onSurface,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/checkout');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondary,
              foregroundColor: AppTheme.onSecondary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              elevation: 4,
            ),
            child: Text(
              'PROCEED TO CHECKOUT',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.onSecondary,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.secondary,
              side: const BorderSide(color: AppTheme.secondary),
              padding: const EdgeInsets.symmetric(vertical: 20),
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Text(
              'CONTINUE SHOPPING',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.secondary,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user, color: AppTheme.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'SECURE CHECKOUT POWERED BY MARCO POLO',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.onTertiaryFixedVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteYourLook() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complete Your Look',
          style: AppTheme.lightTheme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildRecommendationItem(
                'Classic Leather Belt',
                '\$85.00',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDRgP4S0WDMvUyZ02yyQ0EGprknoTzykVCdLCdaaaePl_k12b1uyMJlMjKoqDJcKROeXkWiCaEMZwclXsQWMFszctMrormS6BomUAYDAgbrklrp-6ATcpiYAsifRbhFmhay5yKmFW5Rkhj3HtiGn6uPJfrYm60FDjZbk2OzPZy38Ei1Cai9dK5qJEqi58I9a6FLtDAcUYJVKJdqUv45xnx40XJF4HsP4bz7UYykE3KCx5U8J49nffe4Qkk5BCovp8WqhktwoqSJWZo',
              ),
              const SizedBox(width: 16),
              _buildRecommendationItem(
                'Archive Aviators',
                '\$210.00',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBIzZ1N5Kcz7bunN8E64GWPR7I9zgd4ybscz8ue5CTOpAgkZV7tcgyWWdlRUZXKIW7yqS50ZyvGkp8Wz5mu2H_D3SeZkoMfmYNaf-IMz5u8AU9Trpf6WhVLmp7Hrcua-4fSooP0wa26j9XRtRJBbOubY8Zt8S25Zc_hvPjrIp-EBc_L5nnpeB95PJddCLv4VfUI_rDfFfWYIWWastarskCjOC395HubZ8qBjHkumS8pCJ05CACVoRj_VXpcr-5o6tP37_HrX6s_Rn0',
              ),
              const SizedBox(width: 16),
              _buildRecommendationItem(
                'Organic Cotton Tee',
                '\$45.00',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBy17sEtsQ_WqX5pNJXiE0i1_e7OBVSJG2Yfala8YfmWCWJXD0xIDhO6ewnkKIYzU-ypPlJs9wFSDAyu0t55E0weBN4H8qhlYp-3YWVPXWais7QTi1tNEH6OHEagb0cf79riJgtvbXo4rSk_OQuby-FlLERUMbBpJ3fjP_gtdUEdjaU3q4Ltb0XrT2Zwk_7rhd9C9ONSEXqhd5TjCVGMw3kghSIDzIvASgzV6oLC-rePpePD2L5dp0UUbhoXjaEsxyB4TkQSXOXtbI',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationItem(String title, String price, String imageUrl) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A3F3D56),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 192,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              _buildNavItem(Icons.search, 'Explore', false),
              _buildNavItem(Icons.auto_awesome_motion, 'Collections', false),
              _buildNavItem(Icons.favorite_border, 'Wishlist', false),
              _buildNavItem(Icons.person_outline, 'Account', false, () {
                Navigator.pushNamed(context, '/profile');
              }), // Assuming cart comes under account or we leave it false
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
          color: isActive ? Colors.redAccent : AppTheme.outline,
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
