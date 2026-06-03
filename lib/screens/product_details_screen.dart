import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  String selectedColor = 'Mauve';
  String selectedSize = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 64), // padding for appbar
            _buildHeroAndDetails(context),
            _buildCompleteTheLook(context),
            _buildCustomerBenefits(context),
            const SizedBox(height: 100), // padding for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
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
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart');
                        },
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

  Widget _buildHeroAndDetails(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildImageSection(context, 707)),
              Expanded(child: _buildDetailsSection(context)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildImageSection(context, 530),
              _buildDetailsSection(context),
            ],
          );
        }
      },
    );
  }

  Widget _buildImageSection(BuildContext context, double height) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBKas4Je7qC_dpv7CvaPz7p-MfOYoIjTBWL9JTlflL_jIU9aD-knI84MEqSJZHqdBfL3X0zkXTaS4ZwG5oezfqBNyoyRMTXzr1ygESHLjtZBoumQRtTammrKzeHBgyOrDjSdR8I0makab33qCcskJx9PRYXHgvB1GEod4DYXxqFqipiY0VGi_AWZH07xnRzGPxS7sNGxSYB4jqD14kJzveUkSzL5DqlIgu95XgkzmSNZaVmMnUGuHyXeKNagCifRuMl3l1ACocXr6w',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'NEW IN',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AUTUMN COLLECTION',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The Serene Drape Coat',
            style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$450.00',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '\$580.00',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.outline,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'COLOR: SOFT MAUVE',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildColorSwatch(const Color(0xFFE2BCCF), 'Mauve', selectedColor == 'Mauve'),
              const SizedBox(width: 12),
              _buildColorSwatch(const Color(0xFF3F3D56), 'Navy', selectedColor == 'Navy'),
              const SizedBox(width: 12),
              _buildColorSwatch(const Color(0xFFDADADA), 'Grey', selectedColor == 'Grey'),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SELECT SIZE',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.onSurface,
                ),
              ),
              Text(
                'SIZE GUIDE',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.primary,
                  decoration: TextDecoration.underline,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSizeButton('XS', selectedSize == 'XS'),
              _buildSizeButton('S', selectedSize == 'S'),
              _buildSizeButton('M', selectedSize == 'M'),
              _buildSizeButton('L', selectedSize == 'L'),
              _buildSizeButton('XL', selectedSize == 'XL'),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              final item = CartItem(
                id: '1', // Hardcoded for this screen
                title: 'Silk Drape Blouse',
                variant: '${selectedColor.toUpperCase()} / ${selectedSize.toUpperCase()}',
                price: 185.00,
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB4KZ8AmE_4FXG0QbJasq91eDYKZnkAbbUPkufujtE3d0o1_qdViCfsFH4bxcuh47HH95JiKFcwR83I7VpLL2ITVKo8UF2O2I66SJwQNExvb8pCzWCQRw82I5V946DUWEyJYKP6xRxpUwV8vOr7xcLY0nW648pmBHEn5G6kWTl4nqQwhwoWcRj92bCJQAve_Y8__chWUGZ7NE5ra30tjST0YcXwdYrjK_9Z74bsxDzcWlQLERJDsQULKHMbKCet4CV2GQEjTWudrik',
              );
              ref.read(cartProvider.notifier).addItem(item);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added to cart', style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(color: Colors.white)),
                  backgroundColor: AppTheme.secondary,
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'VIEW CART',
                    textColor: AppTheme.primaryFixed,
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F3D56),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              minimumSize: const Size(double.infinity, 60),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              elevation: 4,
            ),
            child: Text(
              'ADD TO CART',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(color: AppTheme.surfaceContainerHigh),
          const SizedBox(height: 32),
          Text(
            'Expertly tailored from a premium double-faced cashmere blend, the Serene Drape Coat offers a relaxed yet refined silhouette. Featuring dropped shoulders and an elegant waist-cinching belt, it is the quintessential layering piece for transitional weather.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _buildBulletPoint('Sustainable ethically sourced cashmere'),
          const SizedBox(height: 8),
          _buildBulletPoint('Hand-finished seams'),
        ],
      ),
    );
  }

  Widget _buildColorSwatch(Color color, String name, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = name;
        });
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildSizeButton(String size, bool isSelected) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedSize = size;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppTheme.secondary : Colors.transparent,
        foregroundColor: isSelected ? AppTheme.onPrimary : AppTheme.onSurface,
        side: BorderSide(
          color: isSelected ? AppTheme.primary : AppTheme.outlineVariant,
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        size,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: isSelected ? AppTheme.onPrimary : AppTheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, size: 18, color: AppTheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteTheLook(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURATED STYLING',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete the Look',
            style: AppTheme.lightTheme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              int count = constraints.maxWidth > 768 ? 4 : 2;
              return GridView.count(
                crossAxisCount: count,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.55,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildRecommendationCard(
                    context,
                    'Footwear',
                    'Truffle Chelsea Boot',
                    '\$285',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBX01y7FVGlHwnYvH6iSJ9fBp4zlQD6hMQT6cmTaB4Ijaz9fESTYLq2uMSTse6nM8HRLjnfjOu9DHRuO94sNxBYEnaA4H63qIl2lmZYTXrfjucoxZHcEAQjuGx5bfewwIKXuj2cDRMF0B26LFC5AbWVT5wcmo92YGHsMJexsj2Zx0uKiKJU5LsVUQebNrdkd87dK5VasHCCFDUSgKsBhVv__yCU_ADEdYNnFFoyRXujzkccUHq2ht_ELycq3Yn0heMWci_baFtop18',
                  ),
                  _buildRecommendationCard(
                    context,
                    'Jewelry',
                    'Orbit Gold Necklace',
                    '\$120',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAB3h5Q_cQnxHEZzvdosJNk8oXxCBA8bTDD-HpaF-tl076Qc9xA8rqJbuS6VLRGooXpzQIok3yEGg2bzBgAmRMof3J0NTAqX6OAX226MwMYNx2CSil6T_8XILynKqa_8swXzIiIlCV822nqGr7RphqM-BxgheL67r19m5qpvJ9kJqEcksZjcdFiJqe4LpdGZTW8wcHmS5gML7eMg4ctxDboLgD2sm5kXj_QB5suC8FZqL5hD-rcy66v-9br0d8Bq7SEu6yG8zJ2Ap8',
                  ),
                  _buildRecommendationCard(
                    context,
                    'Accessories',
                    'Sculpt Tote Bag',
                    '\$520',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuALSYkenwtc1_xVwdySXJaxyhU6wHFqwpGx4NzSD2kWnSN8SvxhjoB5gg8DcbITrbohJAiOhBG8Ome3jcYuaoI0_yV6yqtFPvaeOIhRlqSL87TbhmQ74qIdrceFlb4J32RBJx1SFsovWPhWDrd5QlKx3fj3rZThk6KkaQvs-rWswmgpR4Z87RyyYkEenPsxkSJQSuDOSPU9BvBcI3-h2us8EtBDE6dB4ur0pLWiXsRtD3qkecFNNkrlna8jqJeRQ8vufi-rY7PJIH0',
                  ),
                  _buildRecommendationCard(
                    context,
                    'Apparel',
                    'Pleat Wool Trouser',
                    '\$310',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA_-Eg_zqMUj6wdI-LZyS1p2iR0BZ_aPibxu6LwkhQgeHV-iFrM7-NCFAGloW2kKYnmV1luEzdK7ICYjWq4u9yrWevPoYxioK7MgkgoFGZam_pgKA7SIe7Vad80NNXsBMz9LuuyI6rt_Daf6VQ45ah9zLTo6ltZzz7m_8T4enrjfmtDGAx_a7wkqMTuKfkOnxO6rqpp84PhJifVtkaiUoZtTuKhHarZyevseXOg4-585wpkDuAdDYz2BDC5Yy55-V4Ad4a1dzZAuyA',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, String category, String title, String price, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
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
                    child: const Icon(Icons.add, color: AppTheme.secondary, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          category.toUpperCase(),
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.outline,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          price,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildCustomerBenefits(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.surfaceContainerHigh)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildBenefitItem(Icons.verified_outlined, 'Lifetime Quality', 'Constructed with high-grade materials meant to last decades, not seasons.')),
                Expanded(child: _buildBenefitItem(Icons.eco_outlined, 'Ethically Made', 'Proudly produced in small batches by artisan communities.')),
                Expanded(child: _buildBenefitItem(Icons.local_shipping_outlined, 'Carbon Neutral', 'Global carbon-neutral shipping on every single order.')),
              ],
            );
          } else {
            return Column(
              children: [
                _buildBenefitItem(Icons.verified_outlined, 'Lifetime Quality', 'Constructed with high-grade materials meant to last decades, not seasons.'),
                const SizedBox(height: 32),
                _buildBenefitItem(Icons.eco_outlined, 'Ethically Made', 'Proudly produced in small batches by artisan communities.'),
                const SizedBox(height: 32),
                _buildBenefitItem(Icons.local_shipping_outlined, 'Carbon Neutral', 'Global carbon-neutral shipping on every single order.'),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Column(
      children: [
        Icon(icon, size: 36, color: AppTheme.primary),
        const SizedBox(height: 16),
        Text(
          title.toUpperCase(),
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
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
              _buildNavItem(Icons.person_outline, 'Account', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
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
    );
  }
}
