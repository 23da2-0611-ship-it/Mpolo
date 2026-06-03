import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../providers/cart_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);
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
              _buildProfileHero(user),
              const SizedBox(height: 32),
              _buildBentoGrid(),
              const SizedBox(height: 48),
              _buildRecentAdditions(),
              const SizedBox(height: 48),
              _buildDangerZone(ref, context),
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

  Widget _buildProfileHero(UserProfile user) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth <= 768;
        return Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 128,
                  height: 128,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primary, width: 2),
                    color: AppTheme.surfaceContainerLowest,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBnMNIKoMwBwWE_diPmfJLSlHISMITVi_vJn7_8Qm0qD2cS65n_jp-vLPMYWSA-ienSFC7ZgTSv3c0A6vfDGL7-N40lcb-0VRA7qa9o3370Z1C2t2g-f9l_zk0atePO7daZe1Bqn2kA-dIAUgXoJS1_Hl7Md4AgsIEKCQLBVbBJr1VObZQa49lN0xk_muv5Bgmq8mjIGVfoSTdsD0kmr0u3nP9RMzQchXoPmufGBz4vq9Gp65F-o3WFOzJloV4zjLRUjRIueKCVw5w',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.verified, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            SizedBox(width: isMobile ? 0 : 32, height: isMobile ? 16 : 0),
            Column(
              crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.membership.isEmpty ? 'MEMBER SINCE APRIL 2026' : user.membership,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'STYLE ENTHUSIAST',
                        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'CURATOR',
                        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBentoGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 8, child: _buildGoldCard()),
                  const SizedBox(width: 24),
                  Expanded(flex: 4, child: _buildActiveOrder()),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildNavigationCard(Icons.shopping_bag_outlined, 'My Orders', 'View your purchase history, returns, and order status.', 'MANAGE ORDERS')),
                  const SizedBox(width: 24),
                  Expanded(child: _buildNavigationCard(Icons.favorite_outline, 'Wishlist', '24 items saved to your boards for future inspiration.', 'VIEW WISHLIST')),
                  const SizedBox(width: 24),
                  Expanded(child: _buildNavigationCard(Icons.location_on_outlined, 'Addresses', 'Manage your shipping and billing locations.', 'EDIT ADDRESSES')),
                ],
              ),
              const SizedBox(height: 24),
              _buildAccountSettings(),
            ],
          );
        } else {
          return Column(
            children: [
              _buildGoldCard(),
              const SizedBox(height: 24),
              _buildActiveOrder(),
              const SizedBox(height: 24),
              _buildNavigationCard(Icons.shopping_bag_outlined, 'My Orders', 'View your purchase history, returns, and order status.', 'MANAGE ORDERS'),
              const SizedBox(height: 24),
              _buildNavigationCard(Icons.favorite_outline, 'Wishlist', '24 items saved to your boards for future inspiration.', 'VIEW WISHLIST'),
              const SizedBox(height: 24),
              _buildNavigationCard(Icons.location_on_outlined, 'Addresses', 'Manage your shipping and billing locations.', 'EDIT ADDRESSES'),
              const SizedBox(height: 24),
              _buildAccountSettings(),
            ],
          );
        }
      },
    );
  }

  Widget _buildGoldCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143F3D56),
            blurRadius: 30,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withValues(alpha: 0.2),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EXCLUSIVE STATUS',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Samrath Gold',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'POINTS BALANCE',
                        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '12,450',
                            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'pts',
                            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(
                      'REDEEM NOW',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrder() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143F3D56),
            blurRadius: 30,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.local_shipping_outlined, color: AppTheme.primary),
              Text(
                'ACTIVE ORDER',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'In Transit',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Arriving Wednesday, May 12',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.75,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(IconData icon, String title, String subtitle, String actionLabel) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143F3D56),
            blurRadius: 30,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.secondary),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                actionLabel,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 16, color: AppTheme.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143F3D56),
            blurRadius: 30,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth <= 768;
          return Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.settings_outlined, color: AppTheme.secondary),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Settings',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Privacy, notifications, and security preferences.',
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 24 : 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.onSurface,
                      side: const BorderSide(color: AppTheme.outlineVariant),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Text(
                      'SECURITY',
                      style: AppTheme.lightTheme.textTheme.labelSmall,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Text(
                      'EDIT PROFILE',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecentAdditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Additions',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            int count = constraints.maxWidth > 768 ? 4 : 2;
            return GridView.count(
              crossAxisCount: count,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.65,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildWishlistItem(
                  'VALENTINO RED',
                  'Silk Evening Blouse',
                  '\$890',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCJQW8UUrzCRQDZAt4-4quitjS3493fayop33src3JpTCa4NNX87yRXbuUJJCAddy1i7G5AN6sYq-PJl-tBQ30cH_m2GeLwuHPiclgBzPSNO0HW8S5ukVZ8jYlcnzXPqMfmmuL3fpLouEPdGEBTwx7jiJqpLhPEHQjwB9jmmzdEeTD8Q0SvZLe29Fk0EC5-XsekQoyuZYuzhaMIuRrp8_yFjLx1dbv4ZSNvPg-jJnl4LN20q80WPeHWvUMpivk5fPACF97q0P0Pwfc',
                ),
                _buildWishlistItem(
                  'ESSENTIALS',
                  'Structured Tote Bag',
                  '\$450',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAuJ_Ddp1N-vhLbhgucrPWmE97wdn-RwX7q_Lzpnp2k2POgpWUOUA3G8rOy97-QnckTWbKhxjYVOBSLEoY9wDtguwjqJ429Pj4aSKUIzD38YHxarabs5zR5rE9dXate_Kp2dbm1g_Ad4h2p6nzY_3JVRUARbfhvSVX-n0cmfr6V0DqDUcoj63GVm0HEV0Rz5h8a5EagMZsgpLfTRlTfOWuzRcE7E4oVBskNGFrXY-_HQVJu2Y6h2vozP8r4SmwYsFgEtyz2iw_cLy8',
                ),
                _buildWishlistItem(
                  'FOOTWEAR',
                  'Suede Pump Heels',
                  '\$320',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDRCaQlZFd2q6d0uxHw8JVReoQ3jhHjGsI85PXIhSBbAq5v64Q8QGhsa4zzw8Tp8m28vqQpg4E4O17ch0BoYXuD8iVqS-UlhkjGG7zD95wgZLUOLgQQLnjftlE3Y-eBAIiGoaO9giyjI6gpsI8yRQM8HxKPydlzM6yPD-NRcadc9uFq1-pW8Xu60S7KXu8Vls_LVndbzUTDTHRsoWT_FBFQ4PZuekvXVEEM6al9322z6EnOjtFBM5hy1J7wG6pTZImUNwt8RXwlDKA',
                ),
                _buildViewAllItem(),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildWishlistItem(String brand, String title, String price, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, color: AppTheme.primary, size: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          brand,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          price,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.primary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildViewAllItem() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.surfaceContainerHigh, style: BorderStyle.solid), // Ideally dashed
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_circle_outline, color: AppTheme.outlineVariant, size: 36),
          const SizedBox(height: 8),
          Text(
            'VIEW ALL',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone(WidgetRef ref, BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          ref.read(cartProvider.notifier).clearCart();
          ref.read(profileProvider.notifier).logout();
          debugPrint('Logout complete; routing to /register.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out — redirected to sign up.')),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false);
        },
        icon: const Icon(Icons.logout, color: AppTheme.error, size: 16),
        label: Text(
          'LOG OUT FROM ALL DEVICES',
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.error,
          ),
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
              _buildNavItem(Icons.auto_awesome_motion, 'Collections', false, () {
                Navigator.pushReplacementNamed(context, '/listing');
              }),
              _buildNavItem(Icons.favorite_border, 'Wishlist', false, () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wishlist coming soon!')));
              }),
              _buildNavItem(Icons.person, 'Account', true, () {
                // Already on Account
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
