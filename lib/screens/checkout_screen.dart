import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 96), // padding for appbar
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 768) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 8, child: _buildLeftColumn()),
                        const SizedBox(width: 32),
                        Expanded(flex: 4, child: _buildRightColumn(context, ref)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildLeftColumn(),
                        const SizedBox(height: 32),
                        _buildRightColumn(context, ref),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
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

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepIndicator(),
        const SizedBox(height: 32),
        _buildShippingAddressSection(),
        const SizedBox(height: 32),
        _buildDeliveryMethodSection(),
        const SizedBox(height: 32),
        _buildPaymentTeaserSection(),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.surfaceContainerHigh)),
      ),
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStep('01', 'Shipping', true),
          _buildStepLine(),
          _buildStep('02', 'Payment', false),
          _buildStepLine(),
          _buildStep('03', 'Review', false),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String label, bool isActive) {
    return Row(
      children: [
        Text(
          number,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: isActive ? AppTheme.primary : AppTheme.outline,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: isActive ? AppTheme.primary : AppTheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 48,
      height: 1,
      color: AppTheme.surfaceContainerHighest,
    );
  }

  Widget _buildShippingAddressSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D3F3D56),
            blurRadius: 20,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Address',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTextField('FIRST NAME', 'Julianne')),
              const SizedBox(width: 24),
              Expanded(child: _buildTextField('LAST NAME', 'Moore')),
            ],
          ),
          const SizedBox(height: 24),
          _buildTextField('STREET ADDRESS', '124 Elegant Way, Suite 400'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTextField('CITY', 'Manhattan')),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildTextField('STATE', 'NY')),
                    const SizedBox(width: 24),
                    Expanded(child: _buildTextField('ZIP', '10001')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.outline,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.outlineVariant,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.outlineVariant),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryMethodSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D3F3D56),
            blurRadius: 20,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Method',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildDeliveryOption('Standard Shipping', '3-5 Business Days', 'Free', true)),
              const SizedBox(width: 16),
              Expanded(child: _buildDeliveryOption('Express Delivery', 'Next Day Arrival', '\$25.00', false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOption(String title, String subtitle, String price, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primary.withValues(alpha: 0.05) : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerHigh,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<bool>(
            value: true,
            activeColor: AppTheme.primary,
            // ignore: deprecated_member_use
            onChanged: (value) {},
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.outline,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              price,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: isSelected ? AppTheme.primary : AppTheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTeaserSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.outlineVariant,
          style: BorderStyle.solid, // Should be dashed ideally
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete shipping details to unlock payment options.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildOrderSummary(context, ref),
        const SizedBox(height: 24),
        _buildPromoCodeCard(),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartProvider.notifier).subtotal;
    final shipping = subtotal > 0 ? 15.00 : 0.00;
    final tax = subtotal * 0.08;
    final total = subtotal + shipping + tax;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceContainerHigh),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A3F3D56),
            blurRadius: 40,
            offset: Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ORDER SUMMARY',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.secondary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 24),
          if (cartItems.isEmpty)
            Text('Your cart is empty', style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.outline)),
          for (var item in cartItems) ...[
            _buildSummaryItem(item.title, item.variant, '\$${item.price.toStringAsFixed(2)}', item.imageUrl),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          const Divider(color: AppTheme.surfaceContainerHigh),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _buildSummaryRow('Shipping', subtotal > 0 ? '\$${shipping.toStringAsFixed(2)}' : 'Calculated at checkout'),
          const SizedBox(height: 12),
          _buildSummaryRow('Estimated Tax', '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.surfaceContainerHigh),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.secondary,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: cartItems.isEmpty
                ? null
                : () {
                    // Navigate to a simple confirmation / payment placeholder
                    Navigator.pushNamed(context, '/order-confirmation');
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
              'CONTINUE TO PAYMENT',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.onSecondary,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 18, color: AppTheme.outline),
              const SizedBox(width: 8),
              Text(
                'SECURE ENCRYPTED CHECKOUT',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String variant, String price, String imageUrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 96,
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                variant,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.outline,
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.outline,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCodeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROMO CODE',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.outline,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'MARCO20',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppTheme.outlineVariant),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppTheme.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.secondary,
                  side: const BorderSide(color: AppTheme.secondary),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Text(
                  'APPLY',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
