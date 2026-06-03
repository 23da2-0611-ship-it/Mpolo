import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../providers/cart_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context),
            _buildCategoryBentoGrid(context),
            _buildFeaturedArrivals(context),
            _buildStyleQuote(context),
            // Padding to ensure content is not hidden behind the bottom navigation bar
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.chat_bubble),
      ),
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
                    icon: const Icon(Icons.menu, color: Colors.redAccent), // text-rose-400
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
    return SizedBox(
      height: 707,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDrtZ1YvOZENtCb1LywzGE41GsIi4_U29gBMwtiDeOKZKl5aWaemdUCiCtyoQuz--lpZAes0VhZ-01ng4fATG043Wju_jQYP5ZtczemlIJHnhrOez3u59asLVtqBTKaU3nvXjMupVxSwzVvEWQ2xnaEALb_yLmE8z_Ao57I3_RJwUXZuuq8OYdKSvUIjMuTOy4LiUMXJMmnv6szq06OcxxH9REsXc3fVnhul6h_Io1DnYZiXUe_SIRXITB_s2bkJb94LXxH4Sm4EPg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0x661A1930), // on-secondary-fixed/40
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 64,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SPRING SUMMER 2024',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.surfaceContainerLowest,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The Ethereal Collection',
                  style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
                    color: AppTheme.surfaceContainerLowest,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondary,
                    foregroundColor: AppTheme.surfaceContainerLowest,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'EXPLORE NOW',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.surfaceContainerLowest,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBentoGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            // Desktop Layout
            return SizedBox(
              height: 600,
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: _buildCategoryCard(
                      context,
                      'Women',
                      'Shop Collection',
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBpF7PD4g-gWv_S2RikEugdWdWf47z250oZRfITzTx1YjYclE1rvt5dnfjJHHzS9n8PpsPch090VaMblYeD35EFZwarnbYwN8WE0LZN-6wMXXrV_ICzbfI74UX6KkyostQdO3JgvDCFLn6G_kxWbNbn0RQHaW0D-S9AibmXBtZqvpr8GL0X066kwgK1XagMhfuTZruPJt-ev9BZhQ3yNWiiuIKSDXdPQBP8DnF4lBEWI8bZU4jxSWQLnNMBh49Vc7MY7e_6DbhX8Ng',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildCategoryCard(
                            context,
                            'Men',
                            'Shop Collection',
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBTSXW8EPxnQTKormLgl-iwfG4rZXI4Er1iRyqzSqKeUx0vgLAPiSUiWWC_bw8hjiOdckl06Lzos4OvtPrCnABBWtocCWLouBwia-xW8YeprFokjNH7PIiN5_rn0EK-dGuGxjQspFtnCgKHA2jarA008LGH334UwFEN4O-ifC0n81vEhCFPuenMiMaIOaAx2wUXzfJNauGO5sU7qL3n8X75uXE2RU-lHx6vFf6pIN9YxOHC5CEts1b7OWf2AbRMUycTacm3210GSC4',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: _buildCategoryCard(
                            context,
                            'Accessories',
                            'Discover More',
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAEJAn_a9hUEGT5vRwNjIgGmL2Y-5DDOLhx_tIIJafw9kvdgcs3ywxY08v4WY6wxHkC8gO5w8ZVljxYns54noBX7VOfdCf9ZPdgJO-PWsjFimjPVxrW8peFtlk8TSisTdTXulXhD9L9hupqwVGEhLDscoQ3D55CWz0o0dM5FtlYgEiO3F_dbuk2SRAVgCOr6gPw2b79q0o1130TZr6DRawrLn4Loz5R3tTx17uR8WgZq2Aba2tG3Do-T47A0FvCYu_F9P77p7Fg2QM',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Mobile Layout
            return Column(
              children: [
                SizedBox(
                  height: 400,
                  child: _buildCategoryCard(
                    context,
                    'Women',
                    'Shop Collection',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBpF7PD4g-gWv_S2RikEugdWdWf47z250oZRfITzTx1YjYclE1rvt5dnfjJHHzS9n8PpsPch090VaMblYeD35EFZwarnbYwN8WE0LZN-6wMXXrV_ICzbfI74UX6KkyostQdO3JgvDCFLn6G_kxWbNbn0RQHaW0D-S9AibmXBtZqvpr8GL0X066kwgK1XagMhfuTZruPJt-ev9BZhQ3yNWiiuIKSDXdPQBP8DnF4lBEWI8bZU4jxSWQLnNMBh49Vc7MY7e_6DbhX8Ng',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: _buildCategoryCard(
                    context,
                    'Men',
                    'Shop Collection',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBTSXW8EPxnQTKormLgl-iwfG4rZXI4Er1iRyqzSqKeUx0vgLAPiSUiWWC_bw8hjiOdckl06Lzos4OvtPrCnABBWtocCWLouBwia-xW8YeprFokjNH7PIiN5_rn0EK-dGuGxjQspFtnCgKHA2jarA008LGH334UwFEN4O-ifC0n81vEhCFPuenMiMaIOaAx2wUXzfJNauGO5sU7qL3n8X75uXE2RU-lHx6vFf6pIN9YxOHC5CEts1b7OWf2AbRMUycTacm3210GSC4',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: _buildCategoryCard(
                    context,
                    'Accessories',
                    'Discover More',
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAEJAn_a9hUEGT5vRwNjIgGmL2Y-5DDOLhx_tIIJafw9kvdgcs3ywxY08v4WY6wxHkC8gO5w8ZVljxYns54noBX7VOfdCf9ZPdgJO-PWsjFimjPVxrW8peFtlk8TSisTdTXulXhD9L9hupqwVGEhLDscoQ3D55CWz0o0dM5FtlYgEiO3F_dbuk2SRAVgCOr6gPw2b79q0o1130TZr6DRawrLn4Loz5R3tTx17uR8WgZq2Aba2tG3Do-T47A0FvCYu_F9P77p7Fg2QM',
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, String subtitle, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/listing');
      },
      child: Container(
        decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D3F3D56),
            blurRadius: 20,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white)),
                    ),
                    child: Text(
                      subtitle.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildFeaturedArrivals(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURATED FOR YOU',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Latest Arrivals',
                      style: AppTheme.lightTheme.textTheme.headlineMedium,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/listing');
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppTheme.secondary)),
                    ),
                    child: Text(
                      'VIEW ALL',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 480,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildProductCard(
                  'Outerwear',
                  'Sculpted Mauve Coat',
                  '\$420',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDhG9H4aG54q3GA0MvuK53Ym9iMgIUJPOlkiF6FkH3Ug6J6u9X2Q6DA_HUjuIqEEZLfeI71sSFPRfSqWTLqOFIZ_-DDyqxSbV-K9ryuRWmvyCtboqV6YTy7pexYZ5NqvtEYvPme5GbN2G23OSJ3L6zXQHbH06VEEDXsE3SMGzJWUMvTSiYQXXtpIVCysaheaE1I-6Lw1wRk2mVQmP0toOU_Na9mmfVsv3wJqeag4V6quxdf0uzNMJo-2_HozeF_QfnJvPblXQPMzf4',
                  tag: 'New In',
                ),
                const SizedBox(width: 16),
                _buildProductCard(
                  'Bottoms',
                  'Pleated Silk Trousers',
                  '\$285',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDczfyurPpvCteXGexqiPoVxDa142JqLOye9dS7DXEkgJdXXsxsRT-G2RHVr_zs59XA7BwcdGIBACSZhwVyJ9pcBUwX1RsifkQ3aLmnXei3elei_f5M8E0YAvPeTKTaMCd2v3Eiz02ixFSzJl0HemKR_HoO3QrKCNN-w-ynP0Z9BVx1QZ0iRjVsnSi5TGJphr_ECGS5OB3Cmmou-Qt0NDdSzxnPFpKy-0a2atW8ZdVLSMl9QZsBaGZALNgWF3Xz5St7mjJ1xrLZYUM',
                ),
                const SizedBox(width: 16),
                _buildProductCard(
                  'Bags',
                  'The Bucket Bag',
                  '\$350',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCYC03HBOIBkiU2pzVGSwiKKAng39-nEQ3tTpN7Rvp_SlnFXUW9BdvXiGBvikqFhi7BhMwtk7fL8Q8bv133viVJ9u_7YhBt6evGVJUTi0-R43YczBDlN7I6HHvsFGzy18zjlsKJdkEom6PX_l84J_WG0lA7PSunjJCQCxOneCCkkCllWCxXDr9cgRKzmJ18_IstAoMpekzvyxGzboF0gVpeE2e_rA1WlMScP25vJOfE4s9xGJJLjBPu0HgmjgCl-kVLTbzadd1Hfi8',
                  tag: 'Limited',
                ),
                const SizedBox(width: 16),
                _buildProductCard(
                  'Tops',
                  'Organza Layered Blouse',
                  '\$195',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuC27-XYrXeE_awIFwXjpopoprKPaCltbRX3GML-mgTPzB27bBlaigJl0x8yWasocFJyVYhhSC2XSQ1EgMGXekdYrze2AX6lUjK1xncnb_QrCZBDqkVQjKifimmsc1C1XJWVJyMnLPHtuRvzg8DOe9XFdO_qBcSalqCCRoJmYvFizL1cHE866Ftlw3jApo_p2YnOFZE4hUHlwsWM-FlrMMRrmIz29DsCNGDMZfMAe84zZmtEIAd2I9SOs9XwhkUDKi8FOK-LhAre2YE',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String category, String name, String price, String imageUrl, {String? tag}) {
    return SizedBox(
      width: 288, // w-72
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 384, // aspect 3/4
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A3F3D56),
                  blurRadius: 30,
                  offset: Offset(0, 8),
                )
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                if (tag != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryFixedDim,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        tag.toUpperCase(),
                        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.onPrimaryFixed,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            category.toUpperCase(),
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.tertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: AppTheme.lightTheme.textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleQuote(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.surfaceContainerLow,
      child: Column(
        children: [
          const Icon(
            Icons.format_quote,
            color: AppTheme.primaryContainer,
            size: 36,
          ),
          const SizedBox(height: 24),
          Text(
            '"Style is a way to say who you are without having to speak."',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
              fontSize: 32,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'THE MARCO POLO PHILOSOPHY',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.tertiary,
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
              _buildNavItem(Icons.search, 'Explore', true, () {
                // Already on Explore (Home)
              }),
              _buildNavItem(Icons.auto_awesome_motion, 'Collections', false, () {
                Navigator.pushReplacementNamed(context, '/listing');
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
